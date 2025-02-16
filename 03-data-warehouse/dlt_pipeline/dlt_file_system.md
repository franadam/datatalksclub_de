# 🚀 **Loading Data from AWS S3 to AWS Athena with dlt in Python**

### *Guide to Efficient Data Loading and Querying with dlt & AWS Athena*

## **📌 Overview**

This guide provides a step-by-step walkthrough on how to load **Parquet files from AWS S3** into **AWS Athena** using **dlt (Data Loading Tool)**. By the end of this tutorial, you will be able to:

✅ **Install and configure dlt**  
✅ **Set up an AWS connection**  
✅ **Build a dlt pipeline to load data from S3**  
✅ **Create Athena tables and query data efficiently**

---

## **1️⃣ Installing and Configuring dlt**

First, install dlt with the required dependencies for AWS Athena:

```bash
pip install dlt[athena]
```

Verify the installation:

```bash
dlt --version
```

✅ **dlt should be successfully installed before proceeding.**

---

## **2️⃣ AWS Configuration**

Before loading data into **AWS Athena**, ensure that your AWS environment is properly set up.

There are multiple way to do it, here  will discuss the .toml files and Environment variables configurations. 

### **🔹 secrets.toml and config.toml**

To initialize a new pipeline with your source and destination, run this command in your terminal:
```bash
dlt init filesystem athena
```
You now have the following folder structure in your project:
```bash
my_dlt_project/
  |-- .dlt/
            |-- config.toml
            |-- secrets.toml
  |-- filesystem_pipeline.py
  |-- .gitignore
```
#secrets.toml
```bash
[sources.filesystem.credentials]
aws_access_key_id = "your_access_key" 
aws_secret_access_key = "your_secret_key"
region_name = "your_region"

[destination.filesystem.credentials]
aws_access_key_id = "your_access_key" 
aws_secret_access_key = "your_secret_key"

[destination.athena.credentials]
aws_access_key_id = "your_access_key"
aws_secret_access_key = "your_secret_key"
region_name = "your_region"
```
#config.toml
```bash

[sources.filesystem]
bucket_url = "s3://sources/filesystem/"

[destination.filesystem]
bucket_url = "s3://destination/filesystem/"

[destination.athena]
query_result_bucket = "s3://destination/query_result/"
athena_work_group = "primary"

[athena.filesystem]
bucket_url = "s3://athena/filesystem/"
```
### **🔹 Environment variables**

Alternatively, you can set up credentials using environment variables. The format of lookup keys is slightly different from secrets files because for environment variables, all names are capitalized, and sections are separated with a double underscore "__"


```bash
# S3 source credentials
SOURCES__FILESYSTEM__CREDENTIALS__AWS_ACCESS_KEY_ID =your_access_key
SOURCES__FILESYSTEM__CREDENTIALS__AWS_SECRET_ACCESS_KEY=your_secret_key
SOURCES__FILESYSTEM__CREDENTIALS__REGION_NAME=your_region

# S3 destination credentials
DESTINATION__FILESYSTEM__CREDENTIALS__AWS_ACCESS_KEY_ID=your_access_key
DESTINATION__FILESYSTEM__CREDENTIALS__AWS_SECRET_ACCESS_KEY=your_secret_key

# Athena credentials
DESTINATION__ATHENA__CREDENTIALS__AWS_ACCESS_KEY_ID=your_access_key
DESTINATION__ATHENA__CREDENTIALS__AWS_SECRET_ACCESS_KEY=your_secret_key
DESTINATION__ATHENA__CREDENTIALS__REGION_NAME=your_region

# S3 source config
SOURCES__FILESYSTEM__BUCKET_URL=s3://sources/filesystem/

# S3 destination config
DESTINATION__FILESYSTEM__BUCKET_URL=s3://destination/filesystem/

# Athena config
DESTINATION__ATHENA__QUERY_RESULT_BUCKET=s3://destination/query_result/
DESTINATION__ATHENA__ATHENA_WORK_GROUP=primary
ATHENA__FILESYSTEM__BUCKET_URL=s3://athena/filesystem/
```

---

## **3️⃣ Setting Up the dlt Pipeline**

Now, we define a **dlt pipeline** to load **Parquet files from AWS S3**.

### **🔹 Define Pipeline Configuration**

```python
import dlt
from dotenv import load_dotenv 

# loading variables from .env file
load_dotenv() 

# 1. Setting Up the dlt Pipeline
pipeline = dlt.pipeline(
    pipeline_name="s3_to_athena_pipeline",
    destination="athena",
    dataset_name="dlt_ny_taxi"
)
```

✅ **This sets up the dlt pipeline to load data into AWS Athena.**

---

## **4️⃣ Loading Data from AWS S3**


```python
import dlt
from dlt.sources.helpers.filesystem import FilesystemSource

files = filesystem(bucket_url=os.getenv('SOURCES__FILESYSTEM__BUCKET_URL'))
reader = (files | read_parquet()).with_name("ny_taxi_yellow_2024") #name of the table
info = pipeline.run(reader)
print(info)
```

✅ **This reads Parquet files from AWS S3 and loads them into AWS Athena.**

---

## **5️⃣ Creating Athena Tables and Querying Data**

Once data is loaded, define **Athena table schemas** and query them.

### **🔹 Define Athena Table Schema**

```python
with pipeline.sql_client() as client:
    client.execute_sql(
        f"""
        CREATE EXTERNAL TABLE IF NOT EXISTS ny_taxi_yellow_2024 (
            VendorID int,
            tpep_pickup_datetime timestamp,
            tpep_dropoff_datetime timestamp,
            passenger_count int,
            trip_distance double,
            RatecodeID int,
            store_and_fwd_flag string,
            PULocationID int,
            DOLocationID int,
            payment_type int,
            fare_amount double,
            extra double,
            mta_tax double,
            tip_amount double,
            tolls_amount double,
            improvement_surcharge double,
            total_amount double,
            congestion_surcharge double
        )
        STORED AS PARQUET
        LOCATION '{os.getenv('DESTINATION__ATHENA__BUCKET_URL')}';
        """
    )
```

✅ **This command registers the table in Athena using the S3 data location.**

---

### **🔹 Query Data from Athena**

Now that the table is created, run queries using dlt:

```python
with pipeline.sql_client() as client:
   results = client.execute_sql(
       """
       SELECT COUNT(*) FROM ny_taxi_yellow_2024
       """
   )
   print(results)
#[(20332093,)]
```

✅ **This retrieves records with a fare amount greater than $20.**

---

## **🎯 Conclusion**

By following this guide, you have successfully:

✔ Installed and configured dlt for AWS Athena  
✔ Set up AWS credentials  
✔ Defined a dlt pipeline to load Parquet files from AWS S3  
✔ Created Athena tables and queried the data  




## **📚 Additional Resources**
- **[dlt Documentation](https://dlthub.com/docs)**
- **[dlt FileSystem Documentation](https://dlthub.com/docs/pipelines/filesystem-aws/load-data-with-python-from-filesystem-aws-to-athena)**
- **[dlt Credentials Documentation](https://dlthub.com/docs/general-usage/credentials/complex_types#awscredentials)**
- **[DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)**

