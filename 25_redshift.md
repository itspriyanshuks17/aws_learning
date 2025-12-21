# 📊 Amazon Redshift - Deep Dive

Amazon Redshift is a **_fully managed, petabyte-scale data warehouse service_** in the cloud. It is designed for **_Online Analytical Processing (OLAP)_** and business intelligence applications.

## 📋 Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Performance Features](#2-performance-features)
3. [Redshift Spectrum](#3-redshift-spectrum)
4. [Redshift Serverless](#4-redshift-serverless)
5. [Resizing Clusters](#5-resizing-clusters)
6. [Backup &amp; DR](#6-backup--dr)
7. [Exam Cheat Sheet](#7-exam-cheat-sheet)

---

## 1. Architecture Overview

Redshift is a cluster-based service composed of a **Leader Node** and **Compute Nodes**.

### Component Roles

- **Leader Node**:
  - Receives queries from client apps (SQL clients, BI tools).
  - Parses queries and generates execution plans.
  - Coordinates parallel execution on Compute Nodes.
  - Aggregates results from Compute Nodes and returns them to the client.
- **Compute Nodes**:
  - Execute the query code.
  - Store data (partitioned across shards called **Slices**).
  - Perform parallel processing.

### Architecture Diagram

```
         +-------------+      (1) SQL Query
         |  BI Tools   |-------------------------+
         | (Tableau..) |                         |
         +-------------+                         v
                                       +------------------+
                                       |   Leader Node    |
                                       | (Coordinates)    |
                                       +--------+---------+
                                                |
                        +-----------------------+-----------------------+
                        | (2) Distribute Work                           |
                        v                                               v
              +------------------+                            +------------------+
              | Compute Node 1   |                            | Compute Node 2   |
              | +------+ +-----+ |                            | +------+ +-----+ |
              | |Slice1| |Slice2 |                            | |Slice3| |Slice4 |
              | +------+ +-----+ |                            | +------+ +-----+ |
              +------------------+                            +------------------+
```

---

## 2. Performance Features

### A. Columnar Storage

Redshift stores data by **column**, not by row (like RDS).

- **Benefit**: If you only select 3 columns out of 100, Redshift only reads those 3 columns from the disk. Drastically reduces I/O.
- **Optimization**: Ideal for aggregates (SUM, AVG) over huge datasets.

### B. Massively Parallel Processing (MPP)

Redshift **_automatically distributes data AND query load across all nodes_**. "**Massively Parallel**" means _many compute nodes working on pieces of the data simultaneously_.

#### How it works:

1. **Code Distribution**: The _Leader Node compiles code and sends it to individual Compute Nodes_.
2. **Data Slices**: **Each Compute Node** is **divided** into **Slices**. A slice is **_a portion of the node's memory and disk_**.
3. **Parallel Execution**: Each slice works on its own chunk of data in parallel.
4. **Aggregation**: Results are sent back to the Leader Node for final aggregation.

```
+------------+    (1) Send Code     +-------------+
| Leader Node| -------------------> | Compute Node|
+------------+                      |  [Slice 1]  | (Executes on Part A)
      ^                             |  [Slice 2]  | (Executes on Part B)
      |                             +-------------+
      | (2) Return Results
```

- **Benefit**: Doubling the number of nodes roughly doubles performance (Linear Scaling).

### C. Compression

Redshift automatically compresses columns to save space and reduce I/O.

---

## 3. Redshift Spectrum

Query data that sits directly in **Amazon S3** without loading it into Redshift tables.

- **UseCase**: You have Exabytes of historical logs in S3. You don't want to pay to store them in Redshift disks.
- **How**: Define an "external table" pointing to S3.
- **Performance**: Much slower than local Redshift storage, but cheap and limitless scale.

```
   [ Redshift Cluster ]----SQL----> [ Spectrum Layer ]----Read----> [ S3 Bucket ]
```

---

## 4. Redshift Serverless

Run and scale analytics without having to provision or manage data warehouse clusters.

### Key Features

- **Auto-Scaling**: Automatically provisions and scales capacity in seconds to meet workload demand.
- **Pay-per-Use**: You pay only for the compute capacity used for the duration of the workload (measured in RPU - Redshift Processing Units).
- **Simplicity**: No need to choose instance types or node counts.
- **Use Cases**: Variable or unpredictable workloads, dev/test environments, or Ad-hoc business analytics.

## 5. Resizing Clusters

### Elastic Resize (Fast)

- add or remove nodes in **minutes**.
- Redshift adds nodes and redistributes data in the background.
- Cluster is unavailable for a short period (minutes).

### Classic Resize (Slow)

- Use when changing instance type (e.g., dense storage to dense compute).
- Creates a brand new cluster and copies data.
- Takes **hours** or days.

---

## 6. Backup & DR

- **Snapshots**: Asynchronous backup to S3.
- **Automated**: Every 8 hours or every 5GB of data change. Retention 1-35 days.
- **Cross-Region Replication**: You can configure Redshift to copy snapshots to another region for Disaster Recovery (DR).

---

## 7. Exam Cheat Sheet

- **OLAP / Analytics**: Key words "Analytics", "Data Warehouse", "BI" -> **Redshift**.
- **Columnar**: "Optimized for aggregation" -> **Redshift**.
- **Spectrum**: "Query S3 data with SQL without loading it" -> **Redshift Spectrum**.
- **Not for OLTP**: If the app requires high-speed inserts/updates (transactional) -> Use **RDS** or **Aurora**, NOT Redshift.
- **Vacuum**: Command to reclaim space after deleting rows (Redshift doesn't free space instantly) and resort data.
- **Distribution Styles**:
  - **Key**: Distribute based on ID (good for joins).
  - **Even**: Round-robin (good for uniform load).
  - **All**: Copy entire table to every node (good for small reference tables).
