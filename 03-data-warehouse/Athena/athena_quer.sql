-- Creating external table referring to s3 path
CREATE EXTERNAL TABLE IF NOT EXISTS kestra_zoomcamp.yellow_tripdata_2022_external (
    VendorID string,
    tpep_pickup_datetime timestamp,
    tpep_dropoff_datetime timestamp,
    passenger_count int,
    trip_distance double,
    RatecodeID string,
    store_and_fwd_flag string,
    PULocationID string,
    DOLocationID string,
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
LOCATION 's3://kestra-s3-bucket-dtc-de/parquet/yellow'
TBLPROPERTIES ('classification' = 'parquet');


-- Create a non partitioned table from external table
CREATE TABLE kestra_zoomcamp.yellow_tripdata_2022_non_partitoned AS
SELECT * FROM kestra_zoomcamp.yellow_tripdata_2022_external;


-- Create a partitioned table from external table
CREATE TABLE kestra_zoomcamp.yellow_tripdata_2022_optimized
WITH (
  format = 'PARQUET',
  external_location = 's3://kestra-s3-bucket-dtc-de/parquet/yellow_2022_optimized',
  partitioned_by = ARRAY['dropoff_date'],
  bucketed_by = ARRAY['vendorid'],
  bucket_count = 10
)
AS
SELECT
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    PULocationID,
    DOLocationID,
  date(tpep_dropoff_datetime) AS dropoff_date
FROM kestra_zoomcamp.yellow_tripdata_2022_external;