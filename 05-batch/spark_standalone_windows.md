# **Setting Up a Standalone Spark Cluster on Windows** 🚀  

### *DataTalksClub - Data Engineering Zoomcamp 2025*

<br>

> **A Step-by-Step Guide for Data Engineers** | DataTalksClub Data Engineering Zoomcamp 2025  




<br>

## **📌 Overview**
This guide walks through setting up a **standalone Apache Spark cluster on Windows**, allowing you to run Spark applications **locally with a master and worker nodes**.

### **Table of Contents**
✅ [Prerequisites](#prerequisites)  
✅ [Starting the Spark Master](#starting-the-spark-master)  
✅ [Starting a Worker Node](#starting-a-worker-node)  
✅ [Connecting an Application to the Cluster](#connecting-an-application-to-the-cluster)  
✅ [Best Practices](#best-practices)  

<br>

## **1️⃣ Prerequisites**
Before setting up Spark, make sure you have:
✅ **Java 8+ Installed**: Spark requires Java Development Kit (JDK)  
✅ **Apache Spark Installed**: Download from [Apache Spark Website](https://spark.apache.org/downloads.html)  
✅ **SPARK_HOME Set Up**: Environment variable pointing to your Spark installation folder  
✅ **Python Installed**: Needed plan to run PySpark  

### **Verify Java Installation**
Run in Command Prompt (CMD):
```sh
java -version
```


### **Verify Spark Installation**
Make sure you have this file:
```sh
%SPARK_HOME%\bin\spark-shell
```
If Spark starts successfully, your setup is correct.

<br>

## **2️⃣ Starting the Spark Master**
To start the **Spark Master node**, follow these steps:

1️⃣ **Open CMD** and navigate to the Spark `bin` directory:
```sh
cd %SPARK_HOME%\bin
```

2️⃣ **Run the Spark Master process**:
```sh
spark-class org.apache.spark.deploy.master.Master
```
🔹 The **Master URL** will be displayed in the format:  
   ```
   spark://your-ip:7077
   ```
   (Make a note of this for later.)

<br>

## **3️⃣ Starting a Worker Node**
To start a **worker node**, follow these steps:

1️⃣ Open a **new CMD window** and navigate to the Spark `bin` directory:
```sh
cd %SPARK_HOME%\bin
```

2️⃣ Run the worker node, replacing `<MASTER_URL>` with the **Spark Master URL** from the previous step:
```sh
spark-class org.apache.spark.deploy.worker.Worker <MASTER_URL>
```
Example:
```sh
spark-class org.apache.spark.deploy.worker.Worker spark://192.168.1.10:7077
```
✔ You should now see a **worker connected** to the master.

<br>

## **4️⃣ Connecting an Application to the Cluster**
Now that the cluster is running, you can connect a **Spark application**.

1️⃣ Start the **Spark Shell** with the master node:
```sh
spark-shell --master spark://your-ip:7077
```

2️⃣ Run a sample Spark job:
```scala
val data = spark.range(1, 1000000)
data.count()
```
✔ This confirms that Spark is running correctly!

<br>

## **5️⃣ Best Practices**
💡 **Ensure Java & Spark Paths Are Set Correctly** – Add them to system environment variables  
💡 **Allocate Enough Memory for Workers** – Use `spark.executor.memory` for tuning  
💡 **Monitor Spark Web UI** – Open `http://localhost:8080` to see master and workers  
💡 **Use Parquet or ORC for Data Storage** – Optimized for Spark processing  
