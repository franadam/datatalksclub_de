# 🚀 **Orchestration – Kestra**

### *DataTalksClub - Data Engineering Zoomcamp 2025*


## Load Data to AWS

> **Note:** Although the Data Engineering Zoomcamp course use GCP, this project uses AWS services (S3, Athena) to load and process data. 

> **Important:** You must manually create the Athena database in the AWS console before running any Kestra tasks that interact with Athena.

## Overview

This project demonstrates how to orchestrate a data ingestion and transformation workflow using Kestra. The workflow downloads NYC taxi data, uploads it to an AWS S3 bucket, and then creates an external Athena table in the Iceberg format. Using Iceberg enables ACID operations such as MERGE, ensuring robust and efficient data processing.

## Prerequisites

- **AWS Account:** Ensure you have access to AWS services with permissions for S3 and Athena.
- **AWS Credentials:** Configure your AWS credentials (access key, secret key, region) in your environment or via Kestra’s configuration.
- **Athena Database:** Create an Athena database manually in the AWS console. This database (referenced by the `AWS_ATHENA_DATABASE` variable) must exist before the workflow creates any tables.


## Workflow Steps

The Kestra workflow comprises the following key steps:

### 1. **Data Extraction:**  
   Download and extract the NYC taxi CSV data from the DataTalksClub GitHub releases.


```yaml
tasks:
  - id: extract
    type: io.kestra.plugin.scripts.shell.Commands
    outputFiles:
      - "*.csv"
    taskRunner:
      type: io.kestra.plugin.core.runner.Process
    commands:
      - wget -qO- https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{{inputs.taxi}}/{{render(vars.file)}}.gz | gunzip > {{render(vars.file)}}
```


### 2. **Create and Upload to AWS S3:**  

To be able to interact with AWS you need to be connected, one way is to use access key, secret key, region

```yaml
pluginDefaults:
  - type: io.kestra.plugin.aws
    values:
      accessKeyId: "{{kv('AWS_ACCESS_KEY_ID')}}"
      secretKeyId: "{{kv('AWS_SECRET_ACCESS_KEY')}}"
      region: "{{kv('AWS_REGION')}}"
      bucket: "{{kv('AWS_BUCKET_NAME')}}"
```
   Upload the extracted CSV file to a designated AWS S3 bucket. The S3 bucket name is configured via the `AWS_BUCKET_NAME` variable.
```yaml
tasks:
  - id: upload_to_aws_s3_bucket
    type: "io.kestra.plugin.aws.s3.Upload"
    from: "{{render(vars.data)}}"
    key: "csv/{{inputs.taxi}}/{{render(vars.file)}}"
    bucket: "{{kv('AWS_BUCKET_NAME')}}"
```

### 3. **Load data from a CSV into a table:**
The athena_green_tripdata_ext task is designed to load data stored in S3 bucket into Athena creating an external table, which means that the data does not reside directly in Athena, but rather, it is accessed externally.

- Flow: [05_aws_taxi.yaml](flows/05_aws_taxi.yaml)
```yaml
tasks:
    - id: athena_green_tripdata_ext
      type: io.kestra.plugin.aws.athena.Query
      database: "{{kv('AWS_ATHENA_DATABASE')}}"
      outputLocation: "s3://{{kv('AWS_BUCKET_NAME')}}/athena_output/{{inputs.taxi}}"
      query: |
        CREATE EXTERNAL TABLE IF NOT EXISTS {{ render(vars.table) }}_ext (
            VendorID string,
            lpep_pickup_datetime timestamp,
            lpep_dropoff_datetime timestamp,
            store_and_fwd_flag string,
            RatecodeID string,
            PULocationID string,
            DOLocationID string,
            passenger_count int,
            trip_distance double,
            fare_amount double,
            extra double,
            mta_tax double,
            tip_amount double,
            tolls_amount double,
            ehail_fee double,
            improvement_surcharge double,
            total_amount double,
            payment_type int,
            trip_type string,
            congestion_surcharge double
        )
        ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
        WITH SERDEPROPERTIES ('field.delim' = ',')
        STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
        LOCATION 's3://{{kv('AWS_BUCKET_NAME')}}/csv/{{inputs.taxi}}/'
        TBLPROPERTIES ('classification' = 'csv');
```

### 3. **Merge Athena Tables:**  
   Execute an Athena query to merge 2 tables using the INSERT INTO function. This way we can populate the `green_tripdata` with the data from all the months.

- Flow: [05_aws_taxi.yaml](flows/05_aws_taxi.yaml)

```yml
tasks:
    - id: athena_green_insert_into
        type: io.kestra.plugin.aws.athena.Query
        database: "{{kv('AWS_ATHENA_DATABASE')}}"
        outputLocation: "s3://{{kv('AWS_BUCKET_NAME')}}/athena_output/{{inputs.taxi}}"
        query: |
          INSERT INTO {{kv('AWS_ATHENA_DATABASE')}}.green_tripdata
          SELECT
            S.unique_row_id,
            S.filename,
            S.VendorID,
            S.lpep_pickup_datetime,
            S.lpep_dropoff_datetime,
            S.store_and_fwd_flag,
            S.RatecodeID,
            S.PULocationID,
            S.DOLocationID,
            S.passenger_count,
            S.trip_distance,
            S.fare_amount,
            S.extra,
            S.mta_tax,
            S.tip_amount,
            S.tolls_amount,
            S.ehail_fee,
            S.improvement_surcharge,
            S.total_amount,
            S.payment_type,
            S.trip_type,
            S.congestion_surcharge
          FROM {{ render(vars.table) }} S
          LEFT JOIN {{kv('AWS_ATHENA_DATABASE')}}.green_tripdata T
            ON T.unique_row_id = S.unique_row_id
          WHERE T.unique_row_id IS NULL;
   ```

### 4. **Manage Schedules and Backfills:**

We can now schedule the same pipeline shown above to run at 9:00 AM on the first day of every month for the green dataset and to run at 10:00 AM on the first day of every month for the yellow dataset. You can backfill historical data directly from the Kestra UI.

- Flow: [06_aws_taxi_scheduled.yaml](flows/06_aws_taxi_scheduled.yaml)

Access the Kestra UI --> Select triggers --> Backfill executions

Lets load all data from Yellow Taxi:

- Start date: 2019-01-01 00:00:00
- End date: 2021-03-31 11:00:00

```yml
inputs:
  - id: taxi
    type: SELECT
    displayName: Select taxi type
    values: [yellow, green]
    defaults: yellow

variables:
  file: "{{inputs.taxi}}_tripdata_{{trigger.date | date('yyyy-MM')}}.csv"
  s3_bucket_file: "s3://{{kv('AWS_BUCKET_NAME')}}/{{vars.file}}"
  table: "{{kv('AWS_ATHENA_DATABASE')}}.{{inputs.taxi}}_tripdata_{{trigger.date | date('yyyy_MM')}}"
  data: "{{outputs.extract.outputFiles[inputs.taxi ~ '_tripdata_' ~ (trigger.date | date('yyyy-MM')) ~ '.csv']}}"

tasks:
  ...

triggers:
  - id: green_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 9 1 * *"
    inputs:
      taxi: green

  - id: yellow_schedule
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "0 10 1 * *"
    inputs:
      taxi: yellow
   ```