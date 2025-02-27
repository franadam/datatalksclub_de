# **📊 Analytics Engineering**  
### **Setting Up dbt with AWS Athena**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*

> **Guide to configuring dbt Cloud with AWS Athena for analytics engineering** 🚀



## **📌 Overview**

This guide walks through the setup of **dbt Cloud** to work with **AWS Athena**, allowing you to run **dbt models** on an S3-backed data warehouse.

✅ **What is dbt**  
✅ **Prerequisites**  
✅ **Step 1: Set Up AWS Athena for dbt**  
✅ **Step 2: Configure IAM Permissions**
<br>
✅ **Step 3: Configure dbt Cloud for AWS Athena**
<br>
✅ **Step 4: Run dbt Models in AWS Athena**
<br>
✅ **Best Practices for dbt + AWS Athena**

<br>

## **📌 What is dbt?**
**dbt (Data Build Tool)** is an open-source framework that allows **data analysts and engineers** to transform raw data into **analytics-ready models** using SQL.

### **Why Use dbt with AWS Athena?**
✔ **Serverless** – No need to manage infrastructure  
✔ **SQL-Based** – Transform data using familiar SQL queries  
✔ **Version-Controlled** – dbt projects integrate with Git  
✔ **Efficient** – Optimized for AWS S3 and data lakes  


<br>

## **📖 Prerequisites**
Before starting, ensure you have:
✅ An **AWS Account** with **IAM permissions**  
✅ An **S3 bucket** for storing Athena query results  
✅ An **AWS Glue Data Catalog** set up  
✅ **dbt Cloud** account (free or paid)  

<br>

## **📌 Step 1: Set Up AWS Athena for dbt**
**AWS Athena** is a **serverless query engine** that reads structured data from **Amazon S3** using **SQL**.

### **1️⃣ Create an S3 Bucket for Athena Query Results**
Athena requires an **S3 bucket** to store query outputs. Create one in AWS:

1. Go to **AWS Console** → **S3**
2. Click **Create Bucket** → Choose a unique name (e.g., `my-athena-query-results`)
3. Set permissions as needed (make sure your IAM user has access)
4. Click **Create Bucket**

### **2️⃣ Enable AWS Glue for Schema Management**
AWS Glue acts as the **Data Catalog** for Athena.

1. Navigate to **AWS Glue** → **Databases**
2. Create a new **database** (e.g., `dbt_athena_catalog`)
3. This Glue database will store table metadata for dbt.

<br>

## **📌 Step 2: Configure IAM Permissions**
For dbt to interact with **Athena and S3**, you need an **IAM role** with the right policies.

### **1️⃣ Create an IAM User for dbt**
1. Go to **AWS IAM** → **Users** → **Create User**
2. Name the user (e.g., `dbt-athena-user`)  
3. Attach the following **IAM Policies**:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "athena:StartQueryExecution",
           "athena:GetQueryResults",
           "athena:GetQueryExecution"
         ],
         "Resource": "*"
       },
       {
         "Effect": "Allow",
         "Action": [
           "s3:GetObject",
           "s3:ListBucket",
           "s3:PutObject"
         ],
         "Resource": [
           "arn:aws:s3:::my-athena-query-results",
           "arn:aws:s3:::my-athena-query-results/*"
         ]
       },
       {
         "Effect": "Allow",
         "Action": [
           "glue:GetDatabase",
           "glue:GetTable",
           "glue:GetPartitions"
         ],
         "Resource": "*"
       }
     ]
   }
   ```
4. Save and **download access credentials**.

<br>

## **📌 Step 3: Configure dbt Cloud for AWS Athena**
Now, connect **dbt Cloud** to AWS Athena.

### **1️⃣ Create a New dbt Cloud Project**
1. Log in to [dbt Cloud](https://cloud.getdbt.com/)
2. Go to **Projects** → **New Project**
3. Select **AWS Athena** as the connection type

### **2️⃣ Configure dbt Cloud Connection**
Fill in the details:

| Setting               | Value                          |
|-----------------------|--------------------------------|
| **Database**         | `dbt_athena_catalog` (Glue DB, name of the data source in Athena) |
| **Schema**           | `analytics` (name of the database in Athena)  |
| **AWS Region**       | e.g., `eu-east-1`             |
| **S3 Staging Directory** | `s3://my-athena-query-results/` |
| **AWS Access Key ID** | *Your IAM key*               |
| **AWS Secret Access Key** | *Your IAM secret*       |

### **3️⃣ Test the Connection**
Click **Test Connection** → If successful, dbt Cloud is ready!

<br>

## **📌 Step 4: Run dbt Models in AWS Athena**
Now, run a test **dbt model**.

1. In **dbt Cloud**, go to **Deploy → Jobs**
2. Click **New Job** → Select the project
3. Add the command:  
   ```sh
   dbt run
   ```
4. Click **Run Job**

Once completed, your **dbt models** will be materialized as **tables in Athena**.

✅ **Now you’re ready to build a Data Warehouse using AWS Athena and dbt Cloud!** 🚀  
<br>
## **📌 Best Practices for dbt + AWS Athena**
💡 **Use Parquet format** for faster queries  
💡 **Enable Partitioning** to reduce scanned data  
💡 **Monitor Costs** – Athena charges per **TB scanned**  
💡 **Use `dbt incremental models`** for large datasets  

<br>

## **📚 Additional Resources**
🔗 [AWS Athena Documentation](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)  
🔗 [dbt + Athena Setup Guide](https://docs.getdbt.com/guides/athena?step=8)  
🔗 [dbt Cloud Official Docs](https://docs.getdbt.com/docs/dbt-cloud)
🔗 [DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)