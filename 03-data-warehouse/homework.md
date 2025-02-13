## Module 3 Homework

<b><u>Important Note:</b></u> </br>
For this homework we will be using the Yellow Taxi Trip Records for **January 2024 - June 2024 NOT the entire year of data** 
Parquet Files from the New York
City Taxi Data found here:  https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page </br>
You will need to use the PARQUET option files when creating an External Table</br>

### ATHENA SETUP:
Create an external table using the Yellow Taxi Trip Records. </br>
Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table). </br>


```sql
-- Creating external table referring to s3 path
CREATE EXTERNAL TABLE IF NOT EXISTS kestra_zoomcamp.yellow_tripdata_2024_external (
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
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION 's3://kestra-s3-bucket-dtc-de/parquets/yellow'
TBLPROPERTIES ('classification' = 'parquet');


-- Create a non partitioned table from external table
CREATE TABLE kestra_zoomcamp.yellow_tripdata_2024_non_partitoned AS
SELECT * FROM kestra_zoomcamp.yellow_tripdata_2024_external;

```


## Question 1:
Question 1: What is count of records for the 2024 Yellow Taxi Data?
```sql
SELECT COUNT(*) FROM "yellow_tripdata_2024_external"
```
`20,332,093`


## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT COUNT( DISTINCT "pulocationid"  )
FROM "yellow_tripdata_2024_external" ;

SELECT COUNT( DISTINCT  "pulocationid"  )
FROM "yellow_tripdata_2024_non_partitoned" ;
```

`0 MB for the External Table and 155.12 MB for the Materialized Table`
External tables are not store in Big Query, they are pointing to files in Google Cloud Storage

## Question 3:
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

```sql
SELECT COUNT( DISTINCT  "pulocationid"  )
FROM "yellow_tripdata_2024_non_partitoned" ;
-- 13.91 MB

SELECT COUNT( DISTINCT "pulocationid"  ) as pulocationid
    , COUNT( DISTINCT "dolocationid"  ) as dolocationid
FROM "yellow_tripdata_2024_non_partitoned" ;
-- 35.69 MB
```

`BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.`

## Question 4:
How many records have a fare_amount of 0?

```sql
SELECT count( fare_amount)  
FROM "yellow_tripdata_2024_non_partitoned" 
where fare_amount = 0
```
`8,333`

## Question 5:
What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

```sql
CREATE TABLE kestra_zoomcamp.yellow_tripdata_2024_optimized
WITH (
  format = 'PARQUET',
  external_location = 's3://kestra-s3-bucket-dtc-de/parquets/yellow_2024_optimized',
  partitioned_by = ARRAY['dropoff_date'],
  bucketed_by = ARRAY['vendorid'],
  bucket_count = 10
)
AS
SELECT *,
  date(tpep_dropoff_datetime) AS dropoff_date
FROM kestra_zoomcamp.yellow_tripdata_2024_external;
```

`Partition by tpep_dropoff_datetime and Cluster on VendorID`



## Question 6:
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

```sql
SELECT DISTINCT VendorID
FROM yellow_tripdata_2024_non_partitoned
WHERE tpep_dropoff_datetime >= timestamp '2024-03-01 00:00:00'
  AND tpep_dropoff_datetime < timestamp '2024-03-16 00:00:00';
-- 93.43 MB

SELECT DISTINCT VendorID
FROM yellow_tripdata_2024_optimized
WHERE dropoff_date >= timestamp '2024-03-01 00:00:00'
  AND dropoff_date < timestamp '2024-03-16 00:00:00';
-- 2.92 KB
```

`310.24 MB for non-partitioned table and 26.84 MB for the partitioned table`

## Question 7: 
Where is the data stored in the External Table you created?

`GCP Bucket`

## Question 8:
It is best practice in Big Query to always cluster your data:
`False`
Whether to use clustering depends on query patterns, dataset size, and cost considerations.
When Clustering is Beneficial:
- Frequent Filtering on Specific Column
- Large Datasets


## (Bonus: Not worth points) Question 9:
No Points: Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
```sql
SELECT COUNT(*) FROM "yellow_tripdata_2024_non_partitoned"
-- 0 KB
```
`SELECT count(*)` only uses the methadata so no data is actually scanned. 

## Submitting the solutions

Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw3