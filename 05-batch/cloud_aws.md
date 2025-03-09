# **Setting Up Apache Spark for AWS** 

### *DataTalksClub - Data Engineering Zoomcamp 2025*


<br>

This guide provides step-by-step instructions on how to set up **Apache Spark** for **AWS**, enabling efficient **data processing, transformation, and analytics** with **S3 storage integration**.

<br>

## **📌 Overview**
1. [Overview of Apache Spark](#1-overview-of-apache-spark)  
2. [Prerequisites](#2-prerequisites)  
3. [Installing and Configuring Spark](#3-installing-and-configuring-spark)  
4. [Setting Up AWS Credentials](#4-setting-up-aws-credentials)  
5. [Connecting Spark to S3](#5-connecting-spark-to-s3)  
6. [Reading and Writing Data from S3](#6-reading-and-writing-data-from-s3)  
7. [Running Spark on AWS EMR (Optional)](#7-running-spark-on-aws-emr-optional)  
8. [Best Practices](#8-best-practices)  

<br>

## **1️⃣ Overview of Apache Spark**
Apache Spark is a **fast, distributed computing system** for big data analytics and machine learning. It provides **in-memory processing** and supports multiple programming languages (**Python, Scala, Java, R**).  

🔥 **Why Spark on AWS?**
- **Scalability** – Easily processes large datasets in distributed mode  
- **Integration with AWS S3** – Cost-effective storage and processing  
- **Serverless options (AWS EMR, AWS Glue)** – No infrastructure management  

<br>

## **2️⃣ Prerequisites**
Before setting up Spark with AWS, ensure you have:
- ✅ **Python 3.8+ installed**
- ✅ **Java 8 or later installed**
- ✅ **Apache Spark 3.x installed**
- ✅ **Hadoop AWS SDK for S3 support**
- ✅ **AWS CLI configured** with valid credentials

Install Spark:
```bash
wget https://downloads.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz
tar -xvzf spark-3.3.2-bin-hadoop3.tgz
mv spark-3.3.2-bin-hadoop3 /opt/spark
```

Set up environment variables:
```bash
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_PYTHON=python3
```

Verify the installation:
```bash
spark-shell --version
```

<br>

## **3️⃣ Installing and Configuring Spark**
### **Install Required Dependencies**
Use `pip` to install the necessary Python libraries:
```bash
pip install pyspark python-dotenv
```

<br>

## **4️⃣ Setting Up AWS Credentials**
Ensure AWS credentials are properly configured:
With the AWS CLI
```bash
aws configure
```
Or manually add credentials in `~/.aws/credentials`:
```
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY
region = us-east-1
```

Alternatively, use environment variables with `dotenv`:
```python
from dotenv import load_dotenv
import os

load_dotenv()
aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
s3a_bucket_url = os.getenv('AWS_S3A_BUCKET_URL')
```
> spark use s3a protocol so you must a `a` to the bucket url 
```bash
AWS_S3_BUCKET_URL=s3://bucket_name
AWS_S3A_BUCKET_URL=s3a://bucket_name
```
<br>

## **5️⃣ Connecting Spark to S3**
Modify Spark configuration to enable S3 access:
```python
from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession

conf = SparkConf() \
    .setMaster('local[*]') \
    .setAppName('AWS_Spark') \
    .set('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.3.4') \
    .set("spark.hadoop.fs.s3a.access.key", aws_access_key_id) \
    .set("spark.hadoop.fs.s3a.secret.key", aws_secret_access_key)

sc = SparkContext.getOrCreate(conf=conf)

hadoop_conf = sc._jsc.hadoopConfiguration()
hadoop_conf.set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
hadoop_conf.set('fs.s3a.aws.credentials.provider','org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider')

spark = SparkSession.builder \
    .config(conf=conf) \
    .getOrCreate()
```

<br>

## **6️⃣ Reading and Writing Data from S3**
### **Reading Parquet Data from S3**
```python
df = spark.read.parquet(f'{s3a_bucket_url}/data/nyc_taxi.parquet')
df.show()
```

### **Writing Data to S3**
```python
df.write.mode("overwrite").parquet(f'{s3a_bucket_url}/output/processed_data/')
```

<br>

## **7️⃣  Best Practices**
✅ **Use Parquet over CSV** – Reduces data scan costs  
✅ **Enable S3 Partitioning** – Optimizes query performance  
✅ **Leverage Spark Caching** – Speeds up iterative processing  
✅ **Monitor Costs on AWS EMR** – Avoid unnecessary resource usage  
✅ **Use Spot Instances on EMR** – Saves up to 70% on compute costs  



<br>

## **📚 Additional Resources**
🔗 [Apache Spark Documentation](https://spark.apache.org/docs/latest/)  
🔗 [AWS EMR Guide](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-what-is-emr.html)  
🔗 [S3 File System with Hadoop](https://hadoop.apache.org/docs/stable/hadoop-aws/tools/hadoop-aws/index.html)  


