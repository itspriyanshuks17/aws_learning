# ☁️ Stateless Applications

Building **Stateless** applications is the key to achieving infinite scalability in the cloud.

## 📋 Table of Contents

1. [Stateless vs Stateful](#1-stateless-vs-stateful)
2. [Why Stateless?](#2-why-stateless)
3. [Managing State in the Cloud](#3-managing-state-in-the-cloud)
4. [Architecture Diagram](#4-architecture-diagram)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Stateless vs Stateful

- **Stateful**: The server retains user data (session, shopping cart) locally on its disk or memory. If the user disconnects and reconnects to a _different_ server, their session is lost.
- **Stateless**: The server retains **NO** user data locally. Every request contains all necessary info (or points to external storage). Any server can handle any request.

---

## 2. Why Stateless?

- **Horizontal Scalability**: You can add 1000 new servers (EC2 instances) instantly because they don't need to synchronize memory.
- **Fault Tolerance**: If a server crashes, no user data is lost. The Load Balancer just sends traffic to a healthy server.
- **Cost Efficiency**: You can use Spot Instances freely, as termination doesn't result in data loss.

---

## 3. Managing State in the Cloud

If the server doesn't hold the state, where does it go?

| State Type       | AWS Service                       | Example                            |
| :--------------- | :-------------------------------- | :--------------------------------- |
| **Session Data** | **ElastiCache (Redis/Memcached)** | Shopping carts, login tokens.      |
| **User Data**    | **DynamoDB / RDS**                | User profiles, order history.      |
| **Shared Files** | **EFS / S3**                      | Uploaded photos, shared documents. |

---

## 4. Architecture Diagram

**Stateless Architecture**
Client connects to ANY server. State is external.

```text
[ Client ]
    |
    v
[ Application Load Balancer ]
    |           |           |
    v           v           v
[ EC2 ]     [ EC2 ]     [ EC2 ]  (Stateless Web Tier)
    |           |           |
    +-----------+-----------+
                |
        [ ElastiCache ]  <-- (Shopping Cart / Session)
                |
        [  DynamoDB   ]  <-- (User Profile)
```

**Stateful Architecture (Avoid)**
Client MUST connect to specific server ("Sticky Sessions").

```text
[ Client ]
    |
    v
[ Load Balancer (Sticky) ]
    |
    v
[ EC2 (A) ]  <-- Client A's Session is ONLY here.
                 If EC2 (A) dies, Session is lost.
```

---

## 5. Exam Cheat Sheet

- **Scalability**: "Application cannot scale because it relies on local sessions" -> **Offload session to ElastiCache or DynamoDB**.
- **Sticky Sessions**: "Load balancer using sticky sessions causing uneven traffic" -> **Disable sticky sessions and make app stateless**.
- **Video Processing**: "Need to process video uploads" -> Upload to **S3** (Stateless storage), trigger **Lambda** (Stateless compute).
