# Module 5 Homework

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the Yellow 2024-10 data from the official website: 

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-10.parquet
```


## Question 1: Install Spark and PySpark

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?

```python
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

spark.version
# '3.5.5'
```
> [!NOTE]
> To install PySpark follow this [guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/pyspark.md)


## Question 2: Yellow October 2024

Read the October 2024 Yellow into a Spark Dataframe.

Repartition the Dataframe to 4 partitions and save it to parquet.

What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.

`25MB`

```python
output_path = 'yellow_tripdata_2024-10_partitioned.parquet'
df_yellow_2024_10 = spark.read.parquet('yellow_tripdata_2024-10.parquet')
df_yellow_2024_10\
    .repartition(4) \
    .write.parquet(output_path)
```


## Question 3: Count records 

How many taxi trips were there on the 15th of October?

Consider only trips that started on the 15th of October.

`125,567`

```python
df_yellow_2024_10.registerTempTable('yellow_2024_10_data')
count_records_query = """
SELECT
    COUNT(1) AS count_records    
FROM yellow_2024_10_data
WHERE day(tpep_pickup_datetime) = 15 and day(tpep_dropoff_datetime) = 15
"""
spark\
    .sql(count_records_query)\
    .show()
```

## Question 4: Longest trip

What is the length of the longest trip in the dataset in hours?

`162`

```python
longest_trip_query =  """
SELECT
    MAX(date_diff(SECOND, tpep_pickup_datetime, tpep_dropoff_datetime)) / 3600.0 AS longest_trip_hours    
FROM yellow_2024_10_data
WHERE tpep_pickup_datetime < tpep_dropoff_datetime
"""
spark\
    .sql(longest_trip_query)\
    .show()
```

## Question 5: User Interface

Spark’s User Interface which shows the application's dashboard runs on which local port?

`4040`



## Question 6: Least frequent pickup location zone

Load the zone lookup data into a temp view in Spark:

```bash
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```

Using the zone lookup data and the Yellow October 2024 data, what is the name of the LEAST frequent pickup location Zone?

`Governor's Island/Ellis Island/Liberty Island`

```python
 df_zone = spark.read \
     .option("header", "true") \
     .csv('taxi_zone_lookup.csv')

 df_zone \
     .repartition(4) \
     .write.parquet('zone')
df_zone.registerTempTable('zone_data')
```
```python
least_pu_zone_query = """
SELECT
    COUNT(y.PULocationID) AS pu_count,
    z.Zone
FROM yellow_2024_10_data y
JOIN zone_data z
    ON y.PULocationID = z.LocationID
GROUP BY z.Zone
ORDER BY pu_count ASC
LIMIT 1
"""
spark\
    .sql(least_pu_zone_query)\
    .show()
```


## Submitting the solutions

- Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw5
- Deadline: See the website