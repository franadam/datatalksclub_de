# **📊 Analytics Engineering**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*
 

## **📌 Overview**

 In this module, I explored **dbt (Data Build Tool)** to build **modular, scalable, and efficient data transformations** in **AWS Athena**. 

✅ **Data sources** <br>
✅ **Materializations** <br>
✅ **Modular modeling techniques** <br>
✅ **Macros, variables**  <br>
✅ **dbt Packages**  
✅ **dbt Seed**  
✅ **Best Practices for Managing Transformations in dbt**

<br>

## **📌 Data Sources in dbt**
**dbt** allows you to define and transform data sources stored in **Amazon S3** by querying them via **AWS Athena**.

### **Common Data Sources in AWS Athena**
1. **External Tables in S3** – Query raw data stored in formats like **Parquet, ORC, CSV, JSON**  
2. **Partitioned Tables** – Optimize query performance using partitioning strategies  
3. **Staging Models (`stg_*`)** – Extract raw data and prepare it for transformations  

#### **🔍 Example: Defining a Data Source in `sources.yml`**
```yml
version: 2

sources:
  - name: staging
    database: AwsDataCatalog # Data source in athena
    schema: kestra_zoomcamp # Database in Athena

    tables:
      - name: green_tripdata_iceberg
      - name: yellow_tripdata_iceberg
      - name: fhv_tripdata_iceberg
```

<br>

## **🔄 Materializations in dbt**
Materializations define **how dbt stores transformed data**. The main types include:

1. **View** : Creates a virtual table, useful for lightweight transformations  
2. **Table** : Stores materialized data in a physical table, useful for performance  
3. **Incremental** : Updates only new data, reducing processing time  
4. **Ephemeral** : Temporary, only exists during query execution  

#### **🛠️ Example: Incremental Materialization in AWS Athena**
```sql
{{ config(
    materialized='incremental',
    unique_key='trip_id'
) }}

SELECT 
    trip_id,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    trip_distance,
    fare_amount
FROM {{ source('nyc_taxi', 'green_taxi') }}
{% if is_incremental() %}
    WHERE pickup_datetime > (SELECT MAX(pickup_datetime) FROM {{ this }})
{% endif %}
```
🔹 **Why use Incremental?** Reduces query costs by only processing new data instead of full table scans.

<br>

## **🧩 Modular Modeling Techniques**
dbt promotes **modular modeling**, breaking down transformations into **staging, intermediate, and fact models**.

### **🌟 Key dbt Models:**
1. **Staging (`stg_*`)** – Standardize raw data before transformation  
2. **Intermediate (`int_*`)** – Apply business logic and joins  
3. **Fact & Dimension (`fact_*`, `dim_*`)** – Final models for analytics  

#### **📌 Example: Creating a Staging Model (`stg_green_taxi.sql`)**
```sql
SELECT 
    trip_id,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    trip_distance,
    fare_amount
FROM {{ source('nyc_taxi', 'green_taxi') }}
WHERE trip_distance > 0
```
This prepares the raw data for **further transformations** in **fact and dimension models**.

<br>

## **⚙️ Macros & Variables in dbt**
Macros and variables allow for **code reuse** and **dynamic transformations**.

### **🔧 Example: A Macro to Convert Timestamps**
Define a macro (`macros/convert_timestamp.sql`):
```sql
{% macro convert_timestamp(column_name) %}
    CAST({{ column_name }} AS TIMESTAMP)
{% endmacro %}
```
Use the macro in a model:
```sql
SELECT 
    trip_id,
    {{ convert_timestamp('pickup_datetime') }} AS pickup_time
FROM {{ ref('stg_green_taxi') }}
```
🔹 **Why use Macros?** Helps avoid redundant code and ensures consistency.

<br>

## **📦 dbt Packages**
dbt **packages** allow the reuse of predefined **dbt models, macros, and tests**.

### **🛠️ Example: Adding a dbt Package**
Modify `packages.yml`:
```yml
packages:
  - package: dbt-labs/dbt_utils
    version: [">=0.8.0", "<1.0.0"]
```
Install the package:
```sh
dbt deps
```
🔹 **Why use dbt Packages?** They provide **prebuilt macros** and utilities, improving efficiency.

<br>

## **📝 dbt Seed (Loading Static Data)**
`dbt seed` is used to **load small CSV files** into a data warehouse.

### **🛠️ Example: Using dbt Seed**
1. Create a CSV file (`seeds/payment_types.csv`):
```csv
payment_type,payment_description
1,Credit Card
2,Cash
3,No Charge
4,Dispute
5,Unknown
```
2. Define it in `seeds.yml`:
```yml
version: 2

seeds:
  - name: payment_types
    description: "Mapping of payment_type to descriptions"
```
3. Run the seed command:
```sh
dbt seed
```
🔹 **Why use dbt Seed?** Useful for reference tables that **don’t change often**.

<br>

## **🛠️ Best Practices for Managing Transformations in dbt**
✅ **Use Modular Models** – Break down transformations into **staging, intermediate, and final models**  
✅ **Leverage Incremental Loading** – Avoid scanning the entire dataset when updating tables  
✅ **Optimize Queries** – Filter data early, use **Parquet**, and avoid **SELECT ***  
✅ **Use Macros & Variables** – Keep transformations reusable and maintainable  
✅ **Monitor Costs** – Use Athena’s cost-tracking features to avoid excessive scanning  
✅ **Use dbt Tests** – Ensure data quality using built-in and custom tests  
✅ **Organize Project Structure** – Follow dbt best practices to make projects scalable  

<br>

## **📚 Additional Resources**
📖 [dbt Documentation](https://docs.getdbt.com/)  
📖 [AWS Athena Documentation](https://docs.aws.amazon.com/athena/latest/ug/)  
📖 [dbt Utils Package](https://hub.getdbt.com/dbt-labs/dbt_utils/)  
📖 [DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)
