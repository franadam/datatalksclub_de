# **📊 Analytics Engineering**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*

This repository contains my notes and key takeaways from **Module 4 – Analytics Engineering** of the **DataTalksClub Data Engineering Zoomcamp 2025**. The focus of this module is on **AWS Athena** and **dbt (Data Build Tool)** to transform raw data into structured analytical models.

> **Mastering Analytics Engineering with AWS Athena & dbt** 🚀  


<br>

## **📚 Summary of Key Topics**
| **Section** | **Description** | **Key Takeaways** |
|------------|---------------|------------------|
| [🔹 Analytics Engineering Basics](analytics_engineering_basics.md) | Introduction to **analytics engineering**, the role of **dbt**, and how transformations fit into a modern data stack. | ✅ dbt bridges **raw data** and **analytics-ready models** <br> ✅ Separating **ELT vs ETL** – dbt is used after data is loaded into a warehouse <br> ✅ The importance of **version control** and modular transformations |
| [🔹 Creating Athena Tables](/02-workflow-orchestration/Athena_tables.md) | Covers how to create **Athena tables**, structure data, and optimize performance using **external and iceberg tables and partitions**. | ✅ Use **external tables** to query data in **Amazon S3** <br> ✅ Apply **partitioning** to reduce scan costs <br> ✅ Optimize using **Parquet format** instead of CSV/JSON |
| [🔹 dbt Cloud Setup](dbt_cloud_setup.md) | Step-by-step guide to setting up **dbt Cloud** to work with AWS Athena. | ✅ Connect **dbt Cloud** to **AWS Athena** using the proper **IAM permissions** <br> ✅ Use **S3 as a data lake** and query via Athena <br> ✅ Configure **profiles.yml** to manage connections |
| [🔹 Building Your First dbt Model](dbt_first_model.md) | Creating and running the first **dbt model** to transform Athena data. | ✅ Define **dbt models** using **SQL select statements** <br> ✅ Use **dbt run** to execute models <br> ✅ Leverage **staging and marts** layers for better data organization |
| [🔹 dbt Testing & Documentation](dbt_test_documentation.md) | Implementing **data quality tests** and documenting models in dbt. | ✅ Use **dbt tests** (unique, not null, accepted values) to ensure data integrity <br> ✅ Write **YAML documentation** for dbt models <br> ✅ Use **dbt docs generate** to create interactive documentation |

<br>

## **📌 Key Learnings from Module 4**
🚀 **dbt + AWS Athena = Serverless Data Transformation**  
- **Athena** allows querying structured data in **Amazon S3** without managing a database.  
- **dbt** transforms raw data into **clean, reusable models** following the **ELT (Extract-Load-Transform)** approach.  
- **Partitioning & Parquet** formats are crucial for **cost-efficient queries**.  

### 🔍 **Best Practices for Analytics Engineering**  
✔ Use **external tables** for querying S3 data in Athena  
✔ Optimize performance with **partitioned** and **compressed** data  
✔ Apply **dbt transformations** to create structured analytics models  
✔ Automate testing with **dbt tests** to ensure data integrity  
✔ Maintain clear **documentation** for data models  

<br>

👉 [My homework](homework.md)

## **🔜 Next Steps**
My next step is to apunderstand batch processing ply **transformations and analytics** using **Spark.** Stay tuned for more updates! 🚀

