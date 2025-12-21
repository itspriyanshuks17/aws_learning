# 🐘 Amazon EMR (Elastic MapReduce) - Deep Dive

Amazon EMR is the industry-leading cloud big data platform for processing vast amounts of data using open source tools such as **Apache Spark**, **Apache Hive**, **Apache HBase**, **Apache Flink**, **Apache Hudi**, and **Presto**.

## 📋 Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Node Types](#2-node-types)
3. [Storage Options (HDFS vs EMRFS)](#3-storage-options-hdfs-vs-emrfs)
4. [Use Cases](#4-use-cases)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Architecture Overview

EMR clusters are ***composed of EC2 instances*** (nodes) ***arranged in a specific topology***. EMR **manages** the ***provisioning, configuration, and tuning of these clusters***.

### Key Concepts

- **Cluster**: A collection of EC2 instances.
- **Step**: A unit of work (e.g., a Spark job or Hive query).
- **Bootstrap Actions**: Scripts that run on nodes when the cluster launches (installing software, configuring OS).

---

## 2. Node Types

An EMR cluster has three types of nodes:

### A. Master Node (1 node, or 3 for HA)

- **Role**: Manages the cluster. Tracks the status of tasks and monitors the health of the cluster.
- **Components**: Runs the Hadoop NameNode, YARN ResourceManager.
- **Recommendation**: Use On-Demand or Reserved Instances (Critical component).

### B. Core Nodes (Min 1 node)

- **Role**: Runs tasks AND stores data in the Hadoop Distributed File System (**HDFS**).
- **Components**: Runs DataNode and NodeManager.
- **Scaling**: Can add/remove, but removing risks data loss if not careful (since it stores HDFS data).

### C. Task Nodes (Optional)

- **Role**: Only runs tasks (Compute only). Does **NOT** store data in HDFS.
- **Components**: Runs NodeManager.
- **Scaling**: Can be added/removed instantly. Perfect for **Spot Instances** to save money.

### Architecture Diagram

```
         +-----------------+
         |   Master Node   |  (Manages Cluster)
         +--------+--------+
                  |
        +---------+---------+
        |                   |
+-------+-------+   +-------+-------+
|  Core Node 1  |   |  Core Node 2  |  (Compute + HDFS Storage)
+-------+-------+   +-------+-------+
        |                   |
+-------+-------+   +-------+-------+
|  Task Node 1  |   |  Task Node 2  |  (Compute Only - Spot Instances)
+---------------+   +---------------+
```

---

## 3. Storage Options (HDFS vs EMRFS)

### HDFS (Hadoop Distributed File System)

- **Where**: Local disk (EBS) of Core Nodes.
- **Pros**: High performance for intermediate data processing.
- **Cons**: Ephemeral. If cluster terminates, data is lost (unless backed up). expensive to scale storage (need to add more Core Nodes).

### EMRFS (EMR File System)

- **Where**: **Amazon S3**.
- **Pros**:
  - **Persistent**: Data survives cluster termination.
  - **Decoupled**: Scale storage (S3) independently of compute (EMR).
  - **Cheaper**: S3 storage class pricing.
- **Consistency**: EMRFS Consistent View ensures strong consistency for S3 objects.

---

## 4. Use Cases

1. **Big Data Processing**: Processing petabytes of data (logs, clickstreams) using Apache Spark.
2. **Machine Learning**: Training ML models on large datasets (Spark MLlib).
3. **Real-time Streaming**: Processing streaming data with Apache Flink.
4. **Interactive Analytics**: Using Presto or Spark SQL for low-latency queries on S3 data.

---

## 5. Exam Cheat Sheet

- **Hadoop / Spark**: Keywords "Hadoop", "Spark", "Big Data processing" -> **EMR**.
- **Decouple Storage**: "Analyze data in S3 without loading it into a database" -> **EMR with EMRFS** (or Redshift Spectrum / Athena).
- **Cost Optimization**: Use **Spot Instances** for **Task Nodes**. Use On-Demand/Reserved for Master/Core.
- **Performance**: If question mentions "MapReduce" or "PIG" or "HIVE" -> **EMR**.
- **Security**: EMR supports IAM roles, Kerberos, and Encryption (At-rest in S3/EBS and In-transit).
