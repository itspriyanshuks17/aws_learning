# 📨 Amazon SQS (Simple Queue Service)

Amazon SQS is a f**ully managed message queuing service** that enables you to **decouple and scale microservices**, distributed systems, and serverless applications.

## 📋 Table of Contents

1. [Core Concepts & Decoupling](#1-core-concepts--decoupling)
2. [SQS Between Application Tiers](#2-sqs-between-application-tiers)
3. [Standard vs FIFO Queues](#3-standard-vs-fifo-queues)
4. [Key Configurations](#4-key-configurations)
5. [Dead Letter Queue (DLQ)](#5-dead-letter-queue-dlq)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Core Concepts & Decoupling

### What is Decoupling?

**Decoupling** means separating the components of a system so they can essentially run and scale **independently**.

- **Coupled System**: If Component A sends data to Component B, and B is down, Component A fails or waits forever.
- **Decoupled System**: Component A sends data to a "buffer" (SQS). It doesn't care if B is running or not.

- **Producer**: Sends messages to the SQS queue.
- **Consumer**: Polls (requests) messages from the SQS queue, processes them, and deletes them.

```text
[ Producer ] --(Msg)--> [ SQS Queue ] --(Poll)--> [ Consumer ]
```

---

## 2. SQS Between Application Tiers

A common pattern is to decouple the **Web Tier** (Frontend) from the **Processing Tier** (Backend).

### Scenario: Video Processing Site

1.  **Web Tier**: Users upload videos. The web server saves the video to S3 and sends a message to SQS: "Process Video ID 123".
2.  **SQS Queue**: Holds the message safely. It acts as a buffer.
3.  **Processing Tier**: EC2 instances poll the queue. They pick up the message, process the video, and delete the message.

**Benefits**:

- **Scalability**: If 1,000 users upload at once, the Web Tier handles it instantly. The Queue fills up. The Processing Tier works at its own pace (e.g., 5 videos at a time).
- **Architecture**: You can use Auto Scaling Groups (ASG) on the Processing Tier to scale based on the "Number of Messages in Queue".

```text
[ Web Server (Tier 1) ] -----> [ SQS Queue ] -----> [ Backend App (Tier 2) ]
(Accepts Uploads Fast)       (Buffers Requests)      (Processes Slowly)
```

## ![1767513348258](image/64_sqs/1767513348258.png)

## 3. Standard vs FIFO Queues

| Feature        | Standard Queue                                       | FIFO Queue (First-In-First-Out)            |
| :------------- | :--------------------------------------------------- | :----------------------------------------- |
| **Ordering**   | **Best-effort** (Messages may arrive out of order).  | **Strictly preserved** (Exact order).      |
| **Duplicates** | **At-least-once** (Rarely, a message happens twice). | **Exactly-once** processing.               |
| **Throughput** | Unlimited.                                           | Limited (3,000 msg/sec with batching).     |
| **Name**       | Any name (e.g.,`my-queue`).                          | Must end in `.fifo` (e.g., `orders.fifo`). |

---

## 4. Key Configurations

### Visibility Timeout

- **Definition**: The time a message is "invisible" to other consumers after being picked up by one consumer.
- **Default**: 30 seconds.
- **Scenario**: If processing takes 5 minutes, increase this timeout. If not, the message reappears, and another consumer processes it (Duplicate!).

### Long Polling

- **Definition**: The consumer waits (up to 20s) for a message to arrive if the queue is empty.
- **Benefit**: Reduces cost (fewer empty API calls) and latency.
- **Enable**: Set `ReceiveMessageWaitTimeSeconds` > 0.

---

## 5. Dead Letter Queue (DLQ)

If a message fails to process multiple times (e.g., bad format, bug in code), SQS moves it to a **Dead Letter Queue**.

- **Redrive Policy**: Configures _when_ to move it (e.g., after 5 failed attempts).
- **Purpose**: Prevents a "poison pill" message from blocking the queue and wasting resources.

---

## 6. Exam Cheat Sheet

- **Order Matters**: "Banking transactions needing exact order" -> **FIFO Queue**.
- **Performance**: "Highest possible throughput, order doesn't matter" -> **Standard Queue**.
- **Duplicate Processing**: "Job processed twice" -> Check **Visibility Timeout** (it expired before job finished) or use **FIFO**.
- **Scaling**: "Auto Scaling Group based on load" -> Scale based on **Queue Length (ApproximateNumberOfMessagesVisible)**.
