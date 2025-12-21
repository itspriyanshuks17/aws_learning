# 🗄️ AWS Database Services - Deep Dive Notes

This guide provides comprehensive notes on AWS Database services, essential for the Solutions Architect Associate (SAA-C03) exam and real-world implementation.

## 📋 Table of Contents

1. [Introduction to AWS Databases](#1-introduction-to-aws-databases)
2. [Amazon RDS (Relational Database Service)](#2-amazon-rds-relational-database-service)
3. [Amazon Aurora](#3-amazon-aurora)
4. [Amazon DynamoDB (NoSQL)](#4-amazon-dynamodb-nosql)
5. [Amazon ElastiCache (In-Memory)](#5-amazon-elasticache-in-memory)
6. [Amazon Redshift (Data Warehousing)](#6-amazon-redshift-data-warehousing)
7. [Other Database Services](#7-other-database-services)
8. [Database Security & Migration](#8-database-security--migration)

---

## 1. Introduction to AWS Databases

Selecting the right database is a critical architectural decision. AWS offers purpose-built databases for every data model.

### Database Categories

- **Relational (SQL)**: Structured data, strict schema, complex joins, ACID compliance. (RDS, Aurora, Redshift)
- **Key-Value (NoSQL)**: High throughput, low latency, flexible schema. (DynamoDB)
- **In-Memory**: Microsecond latency, caching, session management. (ElastiCache)
- **Document**: JSON-like data, flexible schema. (DocumentDB)
- **Graph**: Complex relationships, social networks. (Neptune)
- **Time Series**: IoT, Application metrics. (Timestream)
- **Ledger**: Financial, transparent, immutable, cryptographically verifiable. (QLDB)

---

## 2. Amazon RDS (Relational Database Service)

Managed service that makes it easy to set up, operate, and scale a relational database in the cloud.

### Supported Engines

- PostgreSQL
- MySQL
- MariaDB
- Oracle
- Microsoft SQL Server
- Amazon Aurora (MySQL/PostgreSQL compatible)

### Features & Architecture

- **Managed Service**: AWS handles OS patching, DB provisioning, and backups. You managed the app optimization.
- **Storage**: Uses EBS (Elastic Block Store) volumes.
  - **General Purpose SSD (gp2/gp3)**: Cost-effective, suitable for most workloads.
  - **Provisioned IOPS SSD (io1/io2)**: For high-performance, I/O intensive workloads.
- **Auto-Scaling Storage**: You can enable this to allow RDS to increase storage dynamically.

### Deployments Options

#### 1. Multi-AZ (High Availability)

- **Purpose**: Disaster Recovery (DR) and High Availability (HA). NOT for performance scaling.
- **Mechanism**: Synchronous replication to a standby instance in a different Availability Zone (AZ).
- **Failover**: Automatic DNS failover if the primary goes down. App endpoint remains the same.

#### 2. Read Replicas (Performance)

- **Purpose**: Scale read workload.
- **Mechanism**: Asynchronous replication from the primary.
- **Details**:
  - Can create up to 5 read replicas (15 for Aurora).
  - Can be **Cross-Region**, **Cross-AZ**, or same AZ.
  - Can be promoted to a standalone database.
  - Applications must update connection string to read from replicas.

### Security

- **Encryption at Rest**: AWS KMS (AES-256). Must be defined at launch time.
- **Encryption in Transit**: SSL/TLS.
- **IAM Authentication**: Use IAM roles/users to authenticate instead of database passwords (supported for MySQL/PostgreSQL).

### RDS Proxy

- Fully managed, highly available database proxy.
- **Pools and shares connections** to the database to improve scalability.
- Reduces failover time by up to 66%.
- Great for **Lambda** functions (prevents "too many connections" error).

---

## 3. Amazon Aurora

AWS-built, cloud-native relational database. "Speed and availability of high-end commercial databases with the simplicity and cost-effectiveness of open source databases."

### Key Differences from RDS

- **Performance**: 5x throughput of MySQL, 3x throughput of PostgreSQL.
- **Storage Architecture**:
  - Data is stored in 10 GB chunks.
  - Scales automatically up to 128 TB.
  - **Replication**: 6 copies of your data across 3 AZs.
  - **Self-healing**: Automatically detects and repairs bad blocks.
- **Cost**: Costs ~20% more than RDS but is more efficient.

### Endpoints

- **Cluster Endpoint**: Points to the writer instance.
- **Reader Endpoint**: Load balances connections across all read replicas.
- **Custom Endpoint**: For specific workloads (e.g., directing analytics queries to specific larger replicas).

### Advanced Features

- **Aurora Serverless**: Automatically starts up, shuts down, and scales capacity based on application demand. Ideal for infrequent/unpredictable workloads.
- **Aurora Global Database**:
  - Cross-region replication takes < 1 second.
  - Use for disaster recovery or improved local read performance.
- **Backtracking**: Restore data to any point in time without creating a new DB instance (MySQL only).
- **Cloning**: Create a new cluster from an existing one faster than restoring a snapshot (uses copy-on-write).

---

## 4. Amazon DynamoDB (NoSQL)

Fast, flexible NoSQL database service for single-digit millisecond latency at any scale.

### Core Components

- **Tables**: Collection of data.
- **Items**: Rows in the table (max 400KB size).
- **Attributes**: Columns (can be nested).
- **Primary Key** (Required):
  1.  **Partition Key (HASH)**: Determines data distribution. Must be unique unless Sort Key is used.
  2.  **Partition Key + Sort Key (HASH + RANGE)**: Unique combination. Allows sorting of data with same Partition Key.

### Capacity Modes

1.  **Provisioned Mode (Default)**:
    - You specify Read Capacity Units (RCU) and Write Capacity Units (WCU).
    - Use auto-scaling to adjust significantly.
    - Best for: Predictable workloads.
2.  **On-Demand Mode**:
    - Pay per request.
    - Best for: Unpredictable, spiky workloads or new applications.
    - ~2.5x more expensive per request than provisioned.

### Secondary Indexes

Allow you to query on attributes other than the Primary Key.

- **Local Secondary Index (LSI)**: Alternate Sort Key. Must be created at table creation. Same Partition Key as base table.
- **Global Secondary Index (GSI)**: Brand new Partition Key and Sort Key. Can be created anytime.

### Advanced Features

- **DAX (DynamoDB Accelerator)**: Fully managed in-memory cache. Reduces latency from milliseconds to microseconds. No app code changes needed.
- **DynamoDB Streams**: Ordered stream of item modifications (INSERT, UPDATE, DELETE). Used for triggering Lambda functions on change.
- **Global Tables**: Multi-Region, Multi-Master database. Replication latency < 1 second.
- **TTL (Time To Live)**: Automatically delete items after a specific timestamp (expiry) at no extra cost. Good for session data.
- **Transactions**: ACID transactions across multiple items/tables.

---

## 5. Amazon ElastiCache (In-Memory)

Managed In-memory data store, compatible with Redis or Memcached.

### Comparison: Redis vs Memcached

| Feature               | Redis                                     | Memcached                                        |
| :-------------------- | :---------------------------------------- | :----------------------------------------------- |
| **Data Types**        | Strings, Hashes, Lists, Sets, Sorted Sets | Simple String/Object                             |
| **High Availability** | Replication, Multi-AZ, Automatic Failover | No (Multi-node for partitioning only)            |
| **Persistence**       | Yes (AOF / RDB)                           | No (Purely in-memory)                            |
| **Backup/Restore**    | Yes                                       | No                                               |
| **Use Case**          | Leaderboards, Complex caching, Pub/Sub    | Simple Multithreaded Cache, Scaling horizontally |

### Caching Strategies

- **Lazy Loading**:
  - App checks cache -> Miss -> Query DB -> Write to Cache.
  - **Pros**: Only requested data is cached.
  - **Cons**: Cache miss penalty (latency), Stale data.
- **Write-Through**:
  - App writes to DB and Cache simultaneously.
  - **Pros**: Data is always consistent and fresh.
  - **Cons**: Write latency is higher, Cache churn (storage of unused data).

---

## 6. Amazon Redshift (Data Warehousing)

Petabyte-scale data warehouse.

- **OLAP (Online Analytical Processing)** vs. OLTP (RDS).
- **Columnar Storage**: Stores data by columns instead of rows. Drastically creates faster reads for aggregation queries (SUM, AVG).
- **Compression**: automatically compresses columns to save space.
- **Redshift Spectrum**: Query data sitting in S3 directly without loading into Redshift.
- **Concurrency Scaling**: Automatically adds cluster capacity to handle burst query traffic.

---

## 7. Other Database Services

- **Amazon Neptune**: Graph database. Uses: Social feeds, recommendation engines, fraud detection. Queries: Gremlin, SPARQL.
- **Amazon DocumentDB**: MongoDB compatible. Uses: JSON data, flexible schema.
- **Amazon QLDB (Quantum Ledger Database)**: Immutable, cryptographically verifiable ledger. Uses: Supply chain, banking transactions (where history cannot be corrupted).
- **Amazon Timestream**: Time-series database. Uses: IoT sensor data, application metrics. Serverless.

---

## 8. Database Security & Migration

### Database Security

- **IAM / Security Groups**: Control access to the DB instance network.
- **KMS**: Encryption at rest.
- **SSL/TLS**: Encryption in flight.
- **Audit**: Enable CloudWatch Logs for DB logs (General, Slow Query, Error logs).

### AWS DMS (Database Migration Service)

- Migrate databases to AWS securely.
- **Source database remains available** during migration.
- **Supports Heterogeneous**: Oracle -> Aurora MySQL (Requires **SCT - Schema Conversion Tool**).
- **Supports Homogeneous**: Oracle -> Oracle.
- **Continuous Replication**: Can be used for ongoing replication (Data sync).

---

## 🎯 Exam Tips (SAA-C03)

1.  **High Availability vs. Read Scaling**:
    - If question asks for "Disaster Recovery" or "failover" -> **Multi-AZ**.
    - If question asks for "Improve performance" or "offload read traffic" -> **Read Replicas**.
    - If question asks for "Global reads" -> **Global Database** or **Cross-Region Read Replica**.
2.  **Aurora**: Always choose Aurora if "High Performance", "Serverless DB", or "Auto-scaling storage" is mentioned with Relational requirements.
3.  **DynamoDB**: Look for keywords "Key-Value", "Flexible Schema", "High throughput", "Millisecond latency", "JSON".
4.  **DAX**: If DynamoDB is too slow (need microseconds), add DAX.
5.  **ElastiCache**: If RDS is read-heavy, put ElastiCache in front (Lazy Loading).
6.  **Redshift**: If question mentions "Analytics", "OLAP", "Columnar", "Aggregation".
