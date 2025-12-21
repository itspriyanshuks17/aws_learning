# ⏳ Amazon Timestream - Deep Dive

Amazon Timestream is a *fast, scalable, and serverless* **Time Series Database** service for IoT and operational applications. It makes it *easy to store and analyze trillions of events per day at 1/10th the cost of relational databases*.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Architecture (Storage Tiering)](#2-architecture-storage-tiering)
3. [Data Model](#3-data-model)
4. [Use Cases](#4-use-cases)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

A **Time Series Database** is optimized for measuring things that change over time.

- **Serverless**: Auto-scales to adjust capacity. No instances to manage.
- **Purpose-Built**: 1000x faster query performance than relational databases for time-series data.
- **Integration**: Built-in integration with IoT Core, Kinesis, and Telegraf.

---

## 2. Architecture (Storage Tiering)

Timestream automatically manages the lifecycle of data between two storage tiers to optimize cost and speed.

### A. Memory Store (Recent Data)

- **Purpose**: High-throughput writes and fast point-in-time queries.
- **Feature**: In-memory, optimized for speed.
- **Retention**: Configurable (e.g., store data here for 2 hours to 1 year).

### B. Magnetic Store (Historical Data)

- **Purpose**: Long-term storage for analytics and historical trends.
- **Feature**: Cost-effective storage tier.
- **Retention**: Configurable (e.g., store data here for 1 day to 200 years).

### Workflow Diagram

```
[ IoT Devices ] --> (Write 1000s events/sec) --> [ Memory Store ] (Fast, Expensive)
                                                        |
                                                  (Auto-Tiering Policy)
                                                        |
                                                        v
                                                 [ Magnetic Store ] (Slow, Cheap)
                                                        |
[ Analytics ] ----------------(Query)-------------------+
```

---

## 3. Data Model

Timestream uses a specialized data model to organize time-series data.

1. **Time**: The timestamp of the record.
2. **Dimensions**: Attributes that describe the data (Metadata).
   - _Example_: `DeviceID`, `Location`, `Region`.
3. **Measure**: The actual value being measured.
   - _Example_: `Temperature`, `Humidity`, `CPU_Utilization`.

### Example Record

| Timestamp           | Dimension: DeviceID | Dimension: Location | Measure: Temperature |
| :------------------ | :------------------ | :------------------ | :------------------- |
| 2023-10-27 10:00:00 | Sensor_01           | Database_Room       | 72.5                 |
| 2023-10-27 10:00:01 | Sensor_01           | Database_Room       | 72.6                 |

---

## 4. Use Cases

1. **IoT Applications**: Storing sensor readings from smart home devices or industrial machinery.
2. **DevOps Monitoring**: Tracking CPU, Memory, and Network usage metrics from thousands of servers.
3. **Application Telemetry**: Tracking clickstream data or user activity over time.

---

## 5. Exam Cheat Sheet

- **Time Series**: Keywords "Time Series", "IoT Sensor Data", "Metrics" -> **Timestream**.
- **Storage Tiering**: "Move data from recent high-speed storage to long-term cheap storage automatically" -> **Memory Store to Magnetic Store**.
- **Performance**: "1000x faster than RDS for time-series" -> **Timestream**.
- **Serverless**: Fully managed, auto-scaling.
