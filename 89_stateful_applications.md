# 💾 Stateful Applications

While modern cloud development favors statelessness, **Stateful Applications** are still critical, especially for databases, legacy systems, and real-time gaming.

## 📋 Table of Contents

1. [What is a Stateful Application?](#1-what-is-a-stateful-application)
2. [Managing State: Sticky Sessions](#2-managing-state-sticky-sessions)
3. [Common Use Cases](#3-common-use-cases)
4. [Architecture Diagram](#4-architecture-diagram)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. What is a Stateful Application?

A stateful application **retains user data (context) on the specific server** processing the request.

- **Local Storage**: Data is stored in the instance's RAM or attached EBS volume.
- **Bonded Connection**: The user _must_ keep talking to the _same_ server for their session to be valid.
- **Scaling Challenge**: You cannot simply terminate an instance without losing data.

---

## 2. Managing State: Sticky Sessions

To scale a stateful web app, you use **Sticky Sessions** (Session Affinity) on the Application Load Balancer (ALB).

- **How it works**: The ALB sets a cookie (duration-based) on the client.
- **Routing**: All subsequent requests from that client are routed to the **exact same EC2 instance**.
- **Risk**: If that EC2 instance fails, the user's session (cart, game state) is lost.

---

## 3. Common Use Cases

1.  **Databases**: RDS (MySQL, PostgreSQL) are inherently stateful. They persist data to disk.
2.  **Legacy Apps**: Older monolithic apps that store session data in the web server's memory.
3.  **Real-Time Gaming**: Multiplayer game servers where the memory holds the entire game world state.

---

## 4. Architecture Diagram

**Sticky Sessions (Stateful Web)**
ALB locks User A to Instance A.

```text
       [ User A ]            [ User B ]
           |                     |
           v                     v
    +-----------------------------------+
    |   Application Load Balancer (ALB) |
    |      (Sticky Sessions Enabled)    |
    +-----------------------------------+
           |                     |
           v                     v
+-------------------+   +-------------------+
|  EC2 Instance A   |   |  EC2 Instance B   |
| (Holds A's Cart)  |   | (Holds B's Cart)  |
+-------------------+   +-------------------+
```

---

## 5. Exam Cheat Sheet

- **Session Affinity**: "App stores session data locally and users are getting logged out" -> **Enable Sticky Sessions (Session Affinity)** on CLB/ALB.
- **Horizontal Scaling Limit**: "Stateful app is receiving uneven traffic" -> Sticky sessions can cause **imbalanced load** (one server getting all heavy users).
- **Databases**: Are the primary example of stateful workloads that require replication (Multi-AZ) for high availability, rather than just simple auto-scaling.
