# 📈 Scalability & Auto Scaling

Scalability is the ability of an application to accommodate growth in usage. In AWS, this is achieved primarily through **Auto Scaling Groups (ASG)**.

## 📋 Table of Contents

1. [Scaling Concepts](#1-scaling-concepts)
2. [Scaling Strategies](#2-scaling-strategies)
3. [AWS Auto Scaling Groups (ASG)](#3-aws-auto-scaling-groups-asg)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Scaling Concepts

### Vertical vs Horizontal

| Feature      | Vertical Scaling (Scale Up)                    | Horizontal Scaling (Scale Out)                    |
| :----------- | :--------------------------------------------- | :------------------------------------------------ |
| **Concept**  | Adding power to an existing machine (CPU/RAM). | Adding more machines to the pool.                 |
| **Downtime** | Usually requires a restart to upgrade size.    | **Zero downtime**. Engines are added dynamically. |
| **Limit**    | Hard limit (Hardware capacity).                | **Infinite** (Cloud capacity).                    |
| **Use Case** | Databases (RDS), Legacy Monoliths.             | Web Apps, Microservices, Distributed Systems.     |

#### Architecture Diagrams

**Vertical Scaling (Scale Up)**
Moving from `t2.micro` to `t2.large`.

```text
[  Instance  ]      Use Case:
|  t2.micro  |      Legacy Apps, SQL Databases
+------------+
      |
( Stop & Resize )
      v
[  INSTANCE  ]
|  t2.large  |
+------------+
```

**Horizontal Scaling (Scale Out)**
Adding more Identical Instances (ASG).

```text
       [ Load Balancer ]
        /      |      \
       /       |       \
+-------+  +-------+  +-------+
| EC2 A |  | EC2 B |  | EC2 C |  Use Case:
+-------+  +-------+  +-------+  Web Apps, APIs
```

### Virtual Machine Scale Sets (Azure Term)

- **AWS Equivalent**: **Auto Scaling Groups (ASG)**.
- They both serve the same purpose: automatically managing a collection of identical VMs.

---

## 2. Scaling Strategies

How do we decide _when_ to scale?

### 1. Manual Scaling (Direct Scaling)

- **Definition**: You manually adjust the **Desired Capacity** of the Auto Scaling Group.
- **Action**: Manually updating the ASG setting from `2` to `5` instances.
- **Use Case**: Known events where you want immediate control (e.g., "We are releasing a feature right now and want to warm up capacity").
- **CLI Example**: `aws autoscaling set-desired-capacity --auto-scaling-group-name my-asg --desired-capacity 5`

### 2. Dynamic Scaling (Reactive)

    - **Target Tracking**: "Keep CPU at 50%". (Simplest & Recommended).
    - **Step Scaling**: "If CPU > 70%, add 2 units. If > 85%, add 4 units."
    - **Simple Scaling**: "If CPU > 70%, add 1 unit."

3.  **Scheduled Scaling**: Scale based on time.
    - _Example_: "Every Monday at 9 AM, scale to 10 instances."
4.  **Predictive Scaling**: Uses Machine Learning to predict traffic based on history.

---

## 3. AWS Auto Scaling Groups (ASG)

An ASG contains a collection of EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management.

- **Launch Template**: Defines "What" to launch (AMI, Instance Type, Security Group, User Data).
- **Scaling Policies**: Defines "When" to launch/terminate.
- **Self-Healing**: ASG constantly checks instance health. If an EC2 fails health checks, **ASG terminates it and launches a new one**.

### Key Metrics for Scaling

- **CPU Utilization**: Average CPU load across the fleet.
- **Request Count**: Number of requests per Target (ALB).
- **Network I/O**: Amount of bandwidth used.
- **Custom Metrics**: RAM usage (via CloudWatch Agent) or Application custom logic.

---

## 4. Exam Cheat Sheet

- **High Availability**: "Ensure at least 2 instances are running across 2 AZs" -> **ASG with Min Capacity = 2**.
- **Scaling based on Memory**: "Scale based on RAM utilization" -> **Custom CloudWatch Metric** (Mem is not default).
- **Target Tracking**: "Simplest way to scale based on load" -> **Target Tracking Scaling Policy**.
- **Cooldwon Period**: "Instances are launching/terminating too quickly (flapping)" -> **Increase Cooldown Period**.
