# 🚀 **Workshop: Data Ingestion with dlt**

### *DataTalksClub - Data Engineering Zoomcamp 2025*

## **📌 Overview**

This repository contains my implementation of the **"Data Ingestion with dlt"** workshop from the **DataTalksClub Data Engineering Zoomcamp 2025**. The goal of this workshop is to leverage **dlt** (data loading tool) to extract, load, and transform **NYC Taxi data** from an API into a database.

This README covers:

- **Building Robust, Scalable, and Self-Maintaining Pipelines**
- **Best Practices for Ensuring Clean and Reliable Data Flows**
- **Incremental Loading Techniques**
- **Building a Data Lake with dlt**

---

## **🔧 Building Robust, Scalable, and Self-Maintaining Pipelines**

dlt allows for the construction of **highly scalable and maintainable** data pipelines with minimal manual intervention. Key features include:

✅ **Declarative Pipeline Configuration** – Define transformations and destinations without complex coding.<br>
✅ **Built-in Data Normalization** – Automatically converts nested JSON into structured tables.<br>
✅ **Automatic Schema Evolution** – dlt handles schema changes dynamically, reducing failures.<br>
✅ **Retry and Error Handling** – Ensures smooth execution by retrying failed requests and logging errors.

Example pipeline setup:

```python
import dlt

pipeline = dlt.pipeline(
    pipeline_name="ny_taxi_pipeline",
    destination="duckdb",  # Choose destination (BigQuery, Redshift, etc.)
    dataset_name="ny_taxi_data"
)
```

---

## **⚡Best Practices for Ensuring Clean and Reliable Data Flows**

To maintain high-quality and reliable data pipelines, follow these best practices:

✔ **Built-in Data Governance** – dlt ensures metadata tracking and auditing, maintaining data integrity.<br>
✔ **Automated Data Validation** – Detects anomalies and enforces constraints.<br>
✔ **Data Lineage Tracking** – Monitors the journey of data from source to destination.<br>
✔ **Deduplication and Schema Enforcement** – Avoids duplicate records and enforces expected structures.

Example of schema enforcement with `dlt.schema()`:

```python
schema = dlt.Schema({
    "trip_id": "string",
    "pickup_datetime": "timestamp",
    "dropoff_datetime": "timestamp",
    "fare_amount": "float"
})
```

---

## **Incremental Loading Techniques**

Incremental loading allows **fast and cost-effective data updates** by loading only **new or changed records**. 

### **Methods for Incremental Loading:**

1️⃣ **Timestamp-based Filtering** – Fetch only recent records using a timestamp column.<br>
2️⃣ **Primary Key Deduplication** – Use unique keys to avoid duplicate ingestion.<br>
3️⃣ **Upsert Strategy** – Merge new records with existing data instead of full replacements.

Example implementation:

```python
pipeline.run(
    get_ny_taxi(),
    incremental="pickup_datetime"  # Load only new data based on timestamp
)
```

✅ This minimizes data scanning costs and speeds up the pipeline!

---

## **Building a Data Lake with dlt**

dlt integrates seamlessly with **cloud storage solutions** (AWS S3, Google Cloud Storage, Azure Blob) to build a **cost-effective and scalable Data Lake**.

### **Steps to Build a Data Lake:**

1️⃣ **Ingest Raw Data** – Extract API data and store it in cloud storage.<br>
2️⃣ **Apply Schema and Transformations** – Convert raw JSON into structured tables.<br>
3️⃣ **Partition and Optimize Storage** – Use Parquet/ORC formats for efficient querying.<br>
4️⃣ **Query with BigQuery, Athena, or DuckDB** – Analyze data without moving it.

Example storing data in **AWS S3**:

```python
pipeline = dlt.pipeline(
    pipeline_name="ny_taxi_pipeline",
    destination="s3",
    dataset_name="ny_taxi_data"
)

pipeline.run(get_ny_taxi())
```

---

## **✅ Conclusion**

dlt provides a **powerful, scalable, and easy-to-use framework** for data ingestion. By following best practices like **incremental loading, data governance, and schema enforcement**, we ensure **clean, reliable, and efficient** data workflows.

This workshop provided hands-on experience with **dlt**, an efficient tool for **data ingestion, pipeline creation, and querying**. By integrating **dlt with DuckDB**, we successfully extracted, loaded, and analyzed **NYC Taxi data** from an API.

A huge thanks to **Alexey Grigorev** and the **DataTalksClub** team for this fantastic learning opportunity! 🚀


## **📚 Additional Resources**
- **[dlt Documentation](https://dlthub.com/docs)**
- **[DuckDB Documentation](https://duckdb.org/)**
- **[DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)**

### **🚀 What’s Next?**
The next step is to **transform and analyze** this data further using **dbt (Data Build Tool)**. Stay tuned for more updates on my journey in the **Data Engineering Zoomcamp!**  

