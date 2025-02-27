# **📊 Analytics Engineering**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*

> **Transforming Data into Insights with AWS Athena & Modern Analytics Engineering** 🚀  
 
## **📌 Overview**

This page contains my notes and key takeaways from **Module 4 – Analytics Engineering** of the **DataTalksClub Data Engineering Zoomcamp 2025**. This module focuses on **transforming raw data into structured, actionable insights** using **AWS Athena** and modern data practices. 

✅ **What is Data Engineering ?**  
✅ **What is Analytics Engineering ?**  
✅ **What is Data Analysis ?**  
✅ **Key Differences**


## **📌What is Data Engineering?**
**Data Engineering** involves designing and **building systems** that enable the **collection**, **storage**, and **analysis** of data at scale. 
It encompasses:

✅ **Data Collection**: Gathering data from various sources. <br>
✅ **Data Storage**: Organizing data in databases or data lakes. <br>
✅ **Data Processing**: Transforming raw data into usable formats. <br>
✅ **Data Management**: Ensuring data quality, accessibility, and security.

Data engineers lay the foundation for data-driven decision-making by creating robust data pipelines and infrastructure.


## **📌 What is Analytics Engineering?**  
**Analytics Engineering** is the process of **cleaning, transforming, and modeling raw data** to make it **usable for business intelligence, analytics, and decision-making**.  

It acts as the bridge between **data engineering (building pipelines)** and **data analysis (generating insights)** by ensuring that raw data is structured and optimized for efficient querying.  

### **🔹 Key Responsibilities of an Analytics Engineer:**  
✅ **Design & Implement Data Models** : Build well-structured tables for analysis  
✅ **Optimize Queries** : Improve performance and reduce costs in cloud-based data warehouses  
✅ **Maintain Data Quality** : Ensure accuracy and consistency of data  
✅ **Enable Self-Service Analytics** : Make data accessible to analysts and business users  

<br>

## **📊 What is Data Analysis?**  
**Data Analysis** is the process of **exploring, interpreting, and visualizing data** to extract insights and support decision-making.  

While Analytics Engineering **prepares** the data, Data Analysis **consumes** it to identify trends, anomalies, and key metrics.  

### **🔍 Key Differences: Analytics Engineering vs. Data Analysis**  
| Feature | Data Engineering | Analytics Engineering | Data Analysis |
|------|---------------|----------|----------|
| **Purpose** | Building ETL/ELT pipelines Managing databases, Ensuring data quality and availability| Transform & structure data | Interpret & analyze data |
| **Focus** | Data infrastructure and pipeline development | Data pipelines & modeling | Metrics, KPIs, and trends |
| **Tools** | SQL, terraform, Python, Airflow| SQL, dbt, Athena, BigQuery | Python (Pandas), Tableau, Power BI |
| **Output** | Optimized data pipeline | Optimized tables & schemas | Reports, dashboards, insights |

✅ **Best Practice:** **Analytics Engineering should ensure that data is clean, efficient, and well-structured, so Data Analysts can focus on generating insights rather than fixing messy data.**  

<br>

## **🔄 ETL vs. ELT – Which One to Choose?**  

Both **ETL (Extract, Transform, Load)** and **ELT (Extract, Load, Transform)** are methods for processing data, but they differ in **when and where transformations happen**.

### **1️⃣ ETL (Extract → Transform → Load)**  
Data is extracted, transformed in an external processing layer, and then loaded into the warehouse.  
✅ **Use Case:** Traditional data warehouses (e.g., **SQL Server, Oracle**)  

```yaml
Extract → Clean & Transform Data → Load into Warehouse → Ready for Queries
```

**Example:**  
- Extract from an API → Clean data in Spark → Load into **AWS Redshift**  
- Works well for **structured data** but **slower for big data**  

<br>

### **2️⃣ ELT (Extract → Load → Transform) – The Modern Approach**  
Data is first loaded **as raw** into a **data lake (S3, GCS)** and transformed **within the warehouse** using SQL-based tools like **AWS Athena or dbt**.  
✅ **Use Case:** Cloud-based architectures (e.g., **BigQuery, Snowflake, AWS Athena**)  

```yaml
Extract → Load Raw Data into Warehouse → Transform Using SQL
```

**Example:**  
- Extract from an API → Store raw JSON in **S3** → Use **Athena/dbt** for transformations  
- **Faster & more scalable**, as it leverages **serverless compute**  

🔹 **AWS Athena is an ELT-first engine**, as it directly queries raw data in **S3** and applies transformations **on demand**.

<br>

## **📚 Additional Resources**
📖 [Modern Data Stack Best Practices](https://www.dataengineering.wiki/)  
📖 [DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)