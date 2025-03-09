# **Batch Processing with Apache Spark**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*


<br>

## **📌 Overview**

This repository contains my **notes and insights** from **Module 5 (Batch Processing - Spark)** of the **DataTalksClub Data Engineering Zoomcamp 2025**. In this module, I explored **Apache Spark**, focusing on **batch processing, Spark SQL, DataFrames, and cluster internals**.

✅ [Introduction to Batch Processing](#introduction-to-batch-processing)  
✅ [Introduction to Apache Spark](#introduction-to-apache-spark)  
✅ [Spark SQL and DataFrames](#spark-sql-and-dataframes)  
✅ [Spark Internals (Cluster and GroupBy)](#spark-internals-cluster-and-groupby)  
✅ [Best Practices for Optimizing Spark Workloads](#best-practices-for-optimizing-spark-workloads)  

<br>

## **📌 Introduction to Batch Processing**
### **What is Batch Processing?**
Batch processing is a **data processing method** where large volumes of data are collected, stored, and processed in **chunks (batches)** instead of being processed in real-time.

### **Key Characteristics of Batch Processing:**
✔ **Efficient for Large Datasets** – Suitable for ETL workflows and analytical workloads.  
✔ **Scalability** – Can process **terabytes to petabytes** of data using distributed computing.  
✔ **Optimized for Throughput** – Trades **latency for performance** to process data in bulk.  

### **Common Use Cases**
1️⃣ **ETL Pipelines** – Extracting, transforming, and loading data into a Data Warehouse.  
2️⃣ **Data Lake Processing** – Transforming raw S3/HDFS files into structured datasets.  
3️⃣ **Machine Learning Model Training** – Processing historical data for training ML models.  

<br>

## **🔥 Introduction to Apache Spark**
### **What is Apache Spark?**
Apache Spark is an **open-source distributed computing engine** optimized for **big data processing and analytics**. It supports **batch processing, streaming, SQL, machine learning, and graph processing**.

### **Key Features**
🔹 **In-Memory Computation** – Faster processing compared to Hadoop.  
🔹 **Scalability** – Runs on **clusters with thousands of nodes**.  
🔹 **Unified API** – Supports **SQL, Python (PySpark), Java, Scala, and R**.  
🔹 **Supports Data Lakes** – Works with **AWS S3, HDFS, Delta Lake, and Parquet**.  

### **How Spark Works**
1. **Driver Program** – Sends execution requests to Spark.  
2. **Cluster Manager** – Distributes work across **Executor Nodes**.  
3. **Executors** – Perform the actual computation in parallel.  
4. **Resilient Distributed Dataset (RDD)** – Spark’s internal data structure for distributed computing.  

<br>

## **📌 Spark SQL and DataFrames**
### **What is Spark SQL?**
Spark SQL allows you to **query structured data using SQL syntax** while benefiting from Spark’s distributed engine.

### **DataFrames vs RDDs**
| Feature | DataFrame | RDD |
|---------|----------|-----|
| Performance | **Optimized** | Slower |
| API | SQL-like | Low-level |
| Schema | **Enforced** | Not enforced |
| Use Case | **Analytics, ETL, Reporting** | Complex transformations |

### **🛠️ Creating a Spark DataFrame**
```python
from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

# Read data from a Parquet file
df = spark.read.parquet("/local_sotage/nyc_taxi_data/")
df.show()
```

### **🛠️ Querying Data Using Spark SQL**
```python
df.createOrReplaceTempView("nyc_taxi")

result = spark.sql("""
SELECT vendor_id, COUNT(*) as trip_count
FROM nyc_taxi
GROUP BY vendor_id
""")

result.show()
```

<br>

## **📌 Spark Internals**
### **Spark Cluster Architecture**
Spark operates in a **distributed computing environment** with the following components:

1. **Driver Program** – The main entry point for Spark applications.  
2. **Cluster Manager** – Allocates resources (e.g., YARN, Kubernetes, Mesos, Standalone).  
3. **Executors** – Worker nodes that **process tasks in parallel**.  
4. **Tasks** – Individual computation units executed by Executors.  

### **🛠️ Understanding GroupBy in Spark**
- Spark **shuffles data** across nodes during `groupBy()`, which can be **expensive**.  
- **Alternative**: Use `groupByKey()` sparingly or **reduce data movement** using partitions.  

#### **Example of GroupBy Aggregation**
```python
from pyspark.sql.functions import col, count

df.groupBy("vendor_id").agg(count("*").alias("trip_count")).show()
```

#### **Optimized Approach with Window Functions**
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import row_number

window_spec = Window.partitionBy("vendor_id").orderBy(col("trip_distance").desc())

df.withColumn("rank", row_number().over(window_spec)).show()
```

<br>

## **✅ Best Practices for Optimizing Spark Workloads**
🚀 **Partitioning & Bucketing** – Store large datasets in partitioned tables to **reduce scan time**.  
🚀 **Cache & Persist** – Use `.cache()` or `.persist()` for **frequent re-use of datasets**.  
🚀 **Optimize File Formats** – Use **Parquet/ORC** instead of CSV for **faster processing**.  
🚀 **Broadcast Joins** – For small tables, use `broadcast(df)` to **avoid expensive shuffles**.  
🚀 **Reduce Shuffle Operations** – Minimize **`groupBy()` and `.join()`** operations to improve efficiency.  

<br>


## **📚 Additional Resources**
🔗 [Apache Spark Docs](https://spark.apache.org/docs/latest/)  
🔗 [PySpark API Reference](https://spark.apache.org/docs/latest/api/python/)   
