# **📊 Analytics Engineering**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*
 

## **📌 Overview**

 In this module, In this module, I explored **dbt (Data Build Tool)** for transforming, testing, and documenting data in **AWS Athena**.

✅ **How dbt Tests Work** <br>
✅ **Types of dbt Tests & How to Implement Them** <br>
✅ **Data Validation** <br>
✅ **Automating YAML File Generation**  <br>
✅ **Maintaining Project Documentation**  
✅ **Best Practices for Managing Transformations in dbt**

<br>


## **🛠️ How dbt Tests Work**
**dbt tests** allow us to **validate data integrity and enforce constraints** in our data warehouse (e.g., **AWS Athena**). Tests are written in YAML and executed when running `dbt test`.  

### **🎯 Why Use dbt Tests?**
✔ **Detect Missing or Incorrect Data Early**  
✔ **Ensure Data Consistency Across Tables**  
✔ **Automate Validation Without Writing SQL Scripts**  

<br>

## **📌 Types of dbt Tests & How to Implement Them**
There are **two primary types of tests** in dbt:

### **1️⃣ Generic Tests (Built-in)**
These **predefined tests** validate common data constraints using **YAML configuration**.

#### **Example: Testing for Uniqueness & Null Values**
```yaml
models:
  - name: customers
    description: "Table containing customer data"
    columns:
      - name: customer_id
        description: "Unique ID for each customer"
        tests:
          - unique
          - not_null
```

✅ **Built-in dbt Tests**:
- `unique` → Ensures column values are unique  
- `not_null` → Ensures no null values exist  
- `accepted_values` → Ensures values fall within a given set  
- `relationships` → Ensures foreign key integrity  

Run all tests using:
```sh
dbt test
```

<br>

### **2️⃣ Custom Tests**
For complex logic, **custom tests** are written in **SQL**.

#### **Example: Custom Test to Check for Negative Sales**
Create a SQL test file in `tests/negative_sales.sql`:
```sql
SELECT *
FROM {{ ref('sales') }}
WHERE total_amount < 0
```
Then, reference it in YAML:
```yaml
models:
  - name: sales
    description: "Sales transactions"
    tests:
      - negative_sales
```

<br>

## **📌 How dbt Enforces Constraints for Data Validation**
Although **AWS Athena does not support database constraints (e.g., PRIMARY KEY, FOREIGN KEY)**, dbt enforces them through **testing & validation rules**.

✅ **How dbt Ensures Data Quality in Athena**
- **Test execution (`dbt test`)** → Identifies data anomalies before deployment  
- **Custom constraints using SQL tests** → Mimics database-level constraints  
- **Data freshness checks (`dbt source freshness`)** → Ensures up-to-date data  

<br>

## **📌 Automating YAML File Generation**
Manually writing `schema.yml` files for large datasets is tedious. **dbt provides automation tools**:

### **Generate YAML for a Table Automatically**
```sh
{% set models_to_generate = codegen.get_models(directory='core') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}
```
🔹 **What This Does**:  
- Extracts column names from the table  
- Auto-generates descriptions and test placeholders  
- Saves time when documenting **large datasets**  

<br>

## **📌 Maintaining Project Documentation**
dbt has a built-in **documentation feature** that generates a user-friendly UI for model documentation.

### **📝 How to Document dbt Models**
1. Define descriptions in `schema.yml`:
```yaml
models:
  - name: orders
    description: "This table stores customer orders"
    columns:
      - name: order_id
        description: "Unique identifier for each order"
      - name: order_date
        description: "Date when the order was placed"
```
2. Generate the documentation:
```sh
dbt docs generate
```
3. Start a local documentation server:
```sh
dbt docs serve
```
This opens a **web interface** for navigating models, tests, and relationships.

<br>


## **📚 Additional Resources**
📖 [dbt Documentation](https://docs.getdbt.com/)  
📖 [dbt Utils Package](https://hub.getdbt.com/dbt-labs/dbt_utils/)  
📖 [dbt Testing Guide](https://docs.getdbt.com/docs/build/tests)  
📖 [AWS Athena Documentation](https://docs.aws.amazon.com/athena/latest/ug/)  
📖 [DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)
