# **Stream Processing**  

### *DataTalksClub - Data Engineering Zoomcamp 2025*

<br>

## **📌 Overview**

This page contains my notes and key takeaways from **Module 6 – Stream Processing** of the **DataTalksClub Data Engineering Zoomcamp 2025**. 

✅ **What is Stream Processing ?**  
✅ **Stream Processing vs. Batch Processing**  
✅ **What is Apache Kafka?**  
✅ **Producer & Consumer Architecture**  
✅ **Stream Windowing**  

<br>

## **📌 What is Stream Processing ?**  
Stream processing is a real-time data processing paradigm that continuously ingests, processes, and analyzes data streams. Unlike batch processing, which processes data in fixed intervals, stream processing handles data **event-by-event** as soon as it is generated. This allows for immediate insights and actions, making it ideal for use cases such as fraud detection, real-time monitoring, and predictive analytics.

<br>

## **📌 Stream Processing vs. Batch Processing**  

| Feature             | Batch Processing  | Stream Processing  |
|---------------------|------------------|--------------------|
| **Processing Mode** | Processes large chunks of data at scheduled intervals | Processes data event-by-event in real-time |
| **Latency**        | High (minutes to hours) | Low (milliseconds to seconds) |
| **Use Cases**      | Data warehousing, reporting, ETL processes | Real-time analytics, fraud detection, IoT monitoring |
| **Scalability**    | Scales with bigger machines or distributed clusters | Requires distributed, horizontally scalable systems |
| **Examples**       | Hadoop, Apache Spark (Batch Mode) | Apache Kafka, Apache Flink, Spark Streaming |

<br>

## **📌 What is Apache Kafka?**  

Kafka is a **distributed event streaming platform** designed to handle large-scale, high-throughput, real-time data processing. It is widely used for building real-time data pipelines and streaming applications.

### **Key Components of Kafka:**
- **Producers**: Publish data (events) into Kafka topics.
- **Topics**: Logical channels where messages are stored.
- **Brokers**: Kafka servers that manage data distribution.
- **Consumers**: Subscribe to topics and process the data.
- **Zookeeper**: Manages metadata and leader election in Kafka clusters.

### **Common Use Cases of Kafka:**
- Log aggregation
- Real-time analytics
- Messaging systems
- Event-driven architectures

<br>

## **📌 Stream Processing: Producer & Consumer Architecture**  

In a **stream processing system**, the **producer** generates and sends events to a stream, and the **consumer** reads and processes these events. Kafka serves as a **broker** between producers and consumers, ensuring fault tolerance and scalability.

### **How It Works:**
1. A **Producer** generates messages (events) and sends them to a Kafka topic.
2. Kafka **stores** these messages in a distributed log.
3. A **Consumer** reads messages from the topic and processes them in real time.

This decoupling of producers and consumers enables **scalable, fault-tolerant streaming applications**.

<br>

## **📌 Stream Windowing**  

Stream windowing allows aggregation and processing of **continuous data streams** over defined time intervals. This helps **batch real-time data** while maintaining low latency.

### **Types of Windows:**
1. **Tumbling Windows**: Fixed, non-overlapping time intervals (e.g., sum of sales every 10 seconds).
2. **Sliding Windows**: Overlapping time intervals (e.g., calculate moving averages).
3. **Session Windows**: Dynamic time intervals based on user activity (e.g., group website visits per session).

### **Example in Apache Flink (Sliding Window on Kafka Events):**
```sql
SELECT 
    user_id, COUNT(event) AS event_count
FROM event_stream
GROUP BY user_id, 
    HOP(time_column, INTERVAL '5' SECONDS, INTERVAL '30' SECONDS);
```
This query counts events per user every **5 seconds**, looking at the last **30 seconds** of data.

<br>


## **📚 Additional Resources**
📖 [Kafka documentation](https://kafka.apache.org/documentation/)  
📖 [Flink documentation](https://nightlies.apache.org/flink/flink-docs-master/docs/learn-flink/datastream_api/)  
📖 [DataTalksClub DE Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp)

