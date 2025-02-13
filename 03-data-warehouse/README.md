# **📦 Data Warehouse – AWS Athena (DataTalksClub DE Zoomcamp 2025)**
> **Mastering Data Warehousing with AWS Athena – Partitioning, Clustering, and Optimization** 🚀  

This repository contains my notes and key takeaways from **Module 3 – Data Warehouse** of the **DataTalksClub Data Engineering Zoomcamp 2025**. In this module, I explored **AWS Athena**, focusing on performance optimization, cost efficiency, and best practices for querying large datasets.


<br>

## **🛠️ What is a Data Warehouse?**
A **Data Warehouse (DWH)** is a centralized storage system that allows organizations to store, process, and analyze **structured and semi-structured data**. Unlike traditional databases, a DWH is optimized for **analytical queries** rather than transactional workloads.

### **💡 Key Features of a Data Warehouse**
✅ **Designed for Analytics** – Optimized for complex queries and reporting  
✅ **Scalability** – Handles large datasets efficiently  
✅ **Separation of Storage & Compute** – Query engines like **AWS Athena** and **BigQuery** process data without moving it  
✅ **Schema-on-Read** – Works well with data lakes (e.g., AWS S3)  

<br>

## **📌 AWS Athena – Serverless Query Engine**
**AWS Athena** is a **serverless, interactive query service** that allows querying data stored in **Amazon S3** using standard.  

Unlike traditional data warehouses, Athena does not require infrastructure provisioning or maintenance. You **only pay for the data scanned** in each query.

### **🎯 Why Use AWS Athena?**
✔ **SQL-Based** \
✔ **No Infrastructure to Manage** – Fully managed, pay-as-you-go  
✔ **Works with S3 Data Lakes** – Reads data **directly from S3** in formats like **Parquet, ORC, JSON, CSV**  
✔ **Scalable & Cost-Effective** – Optimized for on-demand queries  

<br>

## **📊 External Tables in AWS Athena**
An **external table** in AWS Athena is a **logical table definition** that references **data stored in Amazon S3**. The data itself is **not stored in Athena**.

### **🛠️ Creating an External Table**
To create an external table in AWS Athena, use the following SQL:

```sql
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
```

<br>

## **📌 Partitioned Tables in AWS Athena**
Partitioning **splits large datasets into smaller, manageable pieces** based on a column (e.g., `year`, `month`). This reduces the amount of data scanned, improving query performance and reducing costs.

### **🛠️ Creating a Partitioned Table**
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
<br>


## **📌 Clustered Tables in AWS Athena**
Clustering **organizes data within partitions** to improve query efficiency. Unlike partitioning, **clustering stores data in sorted blocks** based on a key.

### **🛠️ Creating a Clustered Table**
Athena **does not natively support clustering**, but you can achieve a similar effect by:
1. **Using sorted Parquet files**  
2. **Applying bucketed storage using Glue or EMR**  

Example of bucketing in **Apache Hive (used in Glue/EMR)**:

```sql
CREATE TABLE kestra_zoomcamp.yellow_2024_clustered
WITH (
  format = 'PARQUET',
  external_location = 's3://kestra-s3-bucket-dtc-de/parquets/yellow_2024_clustered',
  bucketed_by = ARRAY['vendorid'],
  bucket_count = 10
)
AS
SELECT *
FROM kestra_zoomcamp.yellow_tripdata_2024_external;
```

<br>

## **📌 Partitioning vs. Clustering**
| Feature         | Partitioning | Clustering (Bucketing) |
|----------------|-------------|------------------------|
| **Definition** | Divides data into separate **folders** based on a column | Organizes data within partitions in **sorted blocks** |
| **Performance** | Reduces scanned data but may create many small files | Optimizes queries on specific columns without many partitions |
| **Storage Impact** | Can lead to too many small files if overused | Requires pre-sorted Parquet/ORC data |
| **Use Case** | Filtering by **year, month, region** | Queries with frequent **GROUP BY, ORDER BY** on a specific column |

✅ **Best Practice**:  
- **Use partitioning** for high-cardinality columns (e.g., `year`, `month`)  
- **Use clustering** for frequently **filtered/sorted** columns (e.g., `vendor_id`)  

<br>

## **✅ Best Practices for AWS Athena**
🚀 **Optimize Queries for Performance & Cost:**
1. **Use Parquet/ORC instead of CSV/JSON** – Columnar formats reduce scan costs  
2. **Partition Data Smartly** – Avoid over-partitioning (e.g., too many unique values)  
3. **Use Compression** – Snappy, Gzip, or ZSTD improves query speed  
4. **Limit SELECT \*** – Always select only the necessary columns  
5. **Leverage Bucketing (Clustering)** – Organize data for better query performance  
6. **Monitor Query Costs** – Use `EXPLAIN` to understand query execution  
7. **Compact Small Files** – Too many small files slow down query execution  

<br>

## **🔜 Next Steps**
Now that I understand **AWS Athena** for querying data warehouses, my next step is to apply **transformations and analytics** using **DBT (Data Build Tool).** Stay tuned for more updates! 🚀

📌 **Check out my homework on GitHub:**  
👉 [My homework](/03-data-warehouse/homework.md)

<br>

### **🙏 Credits & Thanks**
Massive thanks to **Alexey Grigorev** and **DataTalksClub** for the **Data Engineering Zoomcamp 2025**! 🎉

<br>

## **📚 Additional Resources**
📖 AWS Athena Docs: [🔗 Link](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)  
📖 Athena Query Performance Tuning: [🔗 Link](https://docs.aws.amazon.com/athena/latest/ug/performance-tuning.html)

