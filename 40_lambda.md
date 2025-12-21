# ⚡ AWS Lambda - Deep Dive

AWS Lambda is a serverless, event-driven compute service that lets you run code for virtually any type of application or backend service without provisioning or managing servers. It is the core of **FaaS (Function as a Service)** on AWS.

## 📋 Table of Contents

1. [What is Serverless & FaaS?](#1-what-is-serverless--faas)
2. [EC2 vs Lambda (The Comparison)](#2-ec2-vs-lambda-the-comparison)
3. [Event-Driven Architecture & Integrations](#3-event-driven-architecture--integrations)
4. [Configuration & Limits](#4-configuration--limits)
5. [Pricing Model](#5-pricing-model)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. What is Serverless & FaaS?

- **Serverless**: A cloud-native development model that allows developers to build and run applications without having to manage servers.
- **FaaS (Function as a Service)**: A category of serverless cloud computing where you develop, run, and manage application functionalities as discrete functions.
  - **Unit of Scale**: The "Function".
  - **Stateless**: Each function execution is independent and stateless (use DynamoDB/S3/ElastiCache for state).

---

## 2. EC2 vs Lambda (The Comparison)

| Feature        | Amazon EC2 (Virtual Machine)                                    | AWS Lambda (Serverless FaaS)                                     |
| :------------- | :-------------------------------------------------------------- | :--------------------------------------------------------------- |
| **Management** | **High**. You manage OS, patching, security, scaling groups.    | **None**. AWS manages everything (OS, runtimes, scaling).        |
| **Scaling**    | **Auto Scaling Group**. Takes minutes to add new instances.     | **Instant**. Scales from 0 to 1000s of requests in milliseconds. |
| **Pricing**    | Pay per **Hour/Second** the instance is running (even if idle). | Pay per **Request** & **Duration**. Zero cost when idle.         |
| **Time Limit** | **No limit**. Can run 24/7.                                     | **15 Minutes MAX**. Designed for short-lived tasks.              |
| **Disk Space** | EBS Volumes (Persistent, expandable).                           | Ephemeral (`/tmp`) storage (512MB - 10GB).                       |
| **State**      | Can be stateful (store files locally).                          | **Stateless**. Must use external storage (S3/DynamoDB).          |
| **Use Case**   | Long-running processes, monolithic apps, hosting databases.     | Event-driven tasks, APIs, data processing, cron jobs.            |

---

## 3. Event-Driven Architecture & Integrations

Lambda is designed to be the "glue" of the AWS Cloud. It integrates seamlessly with other services.

### Key Integrations

1.  **API Gateway**: Expose your Lambda function as a **REST** or **WebSocket** API.
    - _Use Case_: Severless Backend for Web/Mobile Apps.
2.  **Amazon S3**: Trigger Lambda when a file is uploaded.
    - _Use Case_: Generate thumbnails, process logs, parse CSV files.
3.  **Amazon DynamoDB**: Trigger Lambda when data is added/modified (DynamoDB Streams).
    - _Use Case_: Real-time data sync, analytics, audit trails.
4.  **Amazon SNS (Simple Notification Service)**: Trigger Lambda from a notification topic.
    - _Use Case_: Send emails, SMS, or process alerts.
5.  **Amazon SQS (Simple Queue Service)**: Process messages from a queue.
    - _Use Case_: Decoupled microservices, buffering heavy workloads.
6.  **Amazon Kinesis**: Process real-time streaming data.
    - _Use Case_: Clickstream analysis, log ingestion.
7.  **Amazon EventBridge**: Trigger Lambda on a schedule (Cron) or default AWS events.
    - _Use Case_: Automated backups, "State Change" alerts (e.g., EC2 instance stopped).

### Workflow Diagram (Event Driven)

```
[ Event Source ]  --->  [ AWS Lambda ]  --->  [ Destination ]
(e.g., S3 Upload)       (Process File)        (Save to DB)
```

---

## 4. Configuration & Limits

### Key Configuration

- **Memory**: 128 MB to 10 GB. (Allocating more Memory also allocates more CPU).
- **Timeout**: Default 3s. Max **15 Minutes** (900s).
- **Concurrency**:
  - **Reserved Concurrency**: Guarantee a certain number of instances.
  - **Provisioned Concurrency**: Pre-warm instances to avoid Cold Starts.

### Cold Starts

When a function runs for the first time, AWS initializes a micro-VM. This takes time (Cold Start).

- **Mitigation**: Use Provisioned Concurrency or Keep-Alive pings (EventBridge Rule).

---

## 5. Pricing Model

1.  **Requests**: First 1 Million requests/month are **FREE**. ($0.20 per 1M thereafter).
2.  **Duration**: Charge per millisecond of execution time x Memory size.
    - **Compute Savings Plan**: Can save up to 17% on duration costs.

---

## 6. Exam Cheat Sheet

- **Long Running Jobs**: "Job takes > 15 mins" -> **NOT Lambda**. Use **AWS Batch** or **Step Functions**.
- **Disk Space Error**: "No space left on device" -> Check `/tmp` directory limit (Default 512MB, Max 10GB).
- **Scalability**: "Handle unexpected traffic spikes immediately" -> **Lambda** (scales faster than EC2 ASG).
- **Decoupling**: "Process orders asynchronously" -> **API Gateway -> SQS -> Lambda**.
- **DLQ**: Always configure a **Dead Letter Queue (DLQ)** for asynchronous invocations to handle failures.
