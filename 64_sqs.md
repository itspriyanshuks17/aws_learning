# 📨 Amazon SQS (Simple Queue Service)

Amazon SQS is a fully managed message queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Standard vs FIFO Queues](#2-standard-vs-fifo-queues)
3. [Key Configurations](#3-key-configurations)
4. [Dead Letter Queue (DLQ)](#4-dead-letter-queue-dlq)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

- **Producer**: Sends messages to the SQS queue.
- **Consumer**: Polls (requests) messages from the SQS queue, processes them, and deletes them.
- **De-coupling**: If the consumer crashes, messages persist in the queue until the consumer recovers.

```text
[ Producer (Web App) ] --(SendMessage)--> [ SQS Queue ] --(ReceiveMessage)--> [ Consumer (EC2) ]
                                                                                   |
                                                                              (DeleteMessage)
                                                                                   |
                                                                                   v
                                                                             [ Processed ]
```

---

## 2. Standard vs FIFO Queues

| Feature        | Standard Queue                                       | FIFO Queue (First-In-First-Out)            |
| :------------- | :--------------------------------------------------- | :----------------------------------------- |
| **Ordering**   | **Best-effort** (Messages may arrive out of order).  | **Strictly preserved** (Exact order).      |
| **Duplicates** | **At-least-once** (Rarely, a message happens twice). | **Exactly-once** processing.               |
| **Throughput** | Unlimited.                                           | Limited (3,000 msg/sec with batching).     |
| **Name**       | Any name (e.g., `my-queue`).                         | Must end in `.fifo` (e.g., `orders.fifo`). |

---

## 3. Key Configurations

### Visibility Timeout

- **Definition**: The time a message is "invisible" to other consumers after being picked up by one consumer.
- **Default**: 30 seconds.
- **Scenario**: If processing takes 5 minutes, increase this timeout. If not, the message reappears, and another consumer processes it (Duplicate!).

### Long Polling

- **Definition**: The consumer waits (up to 20s) for a message to arrive if the queue is empty.
- **Benefit**: Reduces cost (fewer empty API calls) and latency.
- **Enable**: Set `ReceiveMessageWaitTimeSeconds` > 0.

---

## 4. Dead Letter Queue (DLQ)

If a message fails to process multiple times (e.g., bad format, bug in code), SQS moves it to a **Dead Letter Queue**.

- **Redrive Policy**: Configures _when_ to move it (e.g., after 5 failed attempts).
- **Purpose**: Prevents a "poison pill" message from blocking the queue and wasting resources.

---

## 5. Exam Cheat Sheet

- **Order Matters**: "Banking transactions needing exact order" -> **FIFO Queue**.
- **Performance**: "Highest possible throughput, order doesn't matter" -> **Standard Queue**.
- **Duplicate Processing**: "Job processed twice" -> Check **Visibility Timeout** (it expired before job finished) or use **FIFO**.
- **Scaling**: "Auto Scaling Group based on load" -> Scale based on **Queue Length (ApproximateNumberOfMessagesVisible)**.
