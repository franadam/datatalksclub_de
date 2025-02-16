#pip install dlt[athena]

# importing os module for environment variables
import os
# importing necessary functions from dotenv library
from dotenv import load_dotenv 
import dlt
from dlt.sources.filesystem import filesystem, read_parquet

# loading variables from .env file
load_dotenv() 

# 1. Setting Up the dlt Pipeline
pipeline = dlt.pipeline(
    pipeline_name="s3_to_athena_pipeline",
    destination="athena",
    dataset_name="dlt_ny_taxi"
)

# 2. Loading Data from AWS S3
files = filesystem(bucket_url=os.getenv('AWS_S3_BUCKET_SOURCE'))
reader = (files | read_parquet()).with_name("ny_taxi_yellow_2024") #name of the table
info = pipeline.run(reader)
print(info)

# 3. Creating Athena Tables
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

# 3. Querying Data with Athena
with pipeline.sql_client() as client:
   results = client.execute_sql(
       """
       SELECT COUNT(*) FROM ny_taxi_yellow_2024
       """
   )
   print(results)