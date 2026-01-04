# 🐰 Amazon MQ - Deep Dive

Amazon MQ is a **managed message broker service** for Apache ActiveMQ and RabbitMQ.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Why use Amazon MQ over SQS/SNS?](#2-why-use-amazon-mq-over-sqssns)
3. [Architecture & Availability](#3-architecture--availability)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Core Concepts

- **Message Broker**: A server that translates messages between formal messaging protocols.
- **Protocols**: Supports standard industry protocols like:
  - **MQTT** (IoT)
  - **AMQP** (Advanced Message Queuing Protocol)
  - **STOMP**
  - **OpenWire**
- **Engines**: Supports **Apache ActiveMQ** and **RabbitMQ**.

---

## 2. Why use Amazon MQ over SQS/SNS?

| Feature       | Amazon SQS / SNS                | Amazon MQ                                              |
| :------------ | :------------------------------ | :----------------------------------------------------- |
| **Type**      | Cloud-Native (AWS Proprietary). | Open Source Standard.                                  |
| **Scaling**   | Infinite (Serverless).          | Limited by Provisioned Instance (e.g., `mq.m5.large`). |
| **Protocols** | HTTPS (API).                    | MQTT, AMQP, STOMP, WSS.                                |
| **Best For**  | **New** Cloud Applications.     | **Migrating** existing on-prem apps (Lift & Shift).    |

**Scenario**: You have an on-premise application running on ActiveMQ. You want to migrate to AWS.

- **Option A**: Rewrite the code to use SQS/SNS URLs (Takes months).
- **Option B (Winner)**: Use Amazon MQ. No code changes needed. Just point the app to the new Amazon MQ endpoint.

---

## 3. Architecture & Availability

Amazon MQ runs on actual EC2 instances (managed by AWS).

- **Single Instance**: Good for dev/test. Availability Zone (AZ) failure = Downtime.
- **Active-Standby HA**:
  - Two instances in **different AZs**.
  - Shared Storage (EFS) for ActiveMQ.
  - If Active fails, Standby takes over.

```text
       [ App ]
          |
     (Failover URL)
        /   \
       v     v
[ Active ] [ Standby ]  <-- (Different AZs)
    \       /
     \     /
   [ EFS Storage ]
```

---

## 4. Exam Cheat Sheet

- **Migration**: "Migrating existing app using MQTT/AMQP to AWS without code changes" -> **Amazon MQ**.
- **Protocols**: "Need support for MQTT, WebSocket, or Stomp" -> **Amazon MQ** (SQS/SNS are HTTP only).
- **High Availability**: "Multi-AZ setup for Amazon MQ" -> **Active-Standby Broker**.
- **Cloud Native**: If building a _new_ app, prefer **SQS/SNS** for scalability. If migrating _legacy_, use **Amazon MQ**.
