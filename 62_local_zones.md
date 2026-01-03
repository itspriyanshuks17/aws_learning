# 🏙️ AWS Local Zones - Deep Dive

AWS Local Zones place compute, storage, database, and other select AWS services **closer to large population, industry, and IT centers**.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Architecture & Connectivity](#2-architecture--connectivity)
3. [Use Cases](#3-use-cases)
4. [Enabling Local Zones](#4-enabling-local-zones)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Concepts

- **Extension of a Region**: A Local Zone is an extension of an AWS Region (e.g., `us-west-2-lax-1a` is a Local Zone in Los Angeles, attached to Oregon Region).
- **Infrastructure**: AWS-managed data center in a specific city (unlike Outposts which is YOUR data center).
- **Services**: EC2, EBS, VPC, EKS, ECS, ALB, and Direct Connect.

---

## 2. Architecture & Connectivity

Local Zones are connected to the parent region via AWS's private high-bandwidth network.

- **Child-Parent Relationship**: The Control Plane remains in the Parent Region.
- **VPC Extension**: You can extend your existing VPC from the Region into the Local Zone.

```text
       [ Parent Region ] <----(High Bandwidth)----+
      (Oregon - us-west-2)                        |
            |                                     |
   (Control Plane / S3)                           |
            |                                     |
            v                                     v
    [ AWS Local Zone ] <----(Low Latency)----> [ End User ]
    (Los Angeles - LAX)                        (Gamer in LA)
    (EC2 / EBS / ALB)
```

---

## 3. Use Cases

1.  **Media & Entertainment**: Video rendering workstations for artists in Los Angeles (using EC2 G4 instances).
2.  **Real-Time Gaming**: Multiplayer game servers hosted in typically "non-AWS" cities like Houston or Miami.
3.  **Hybrid Cloud Migration**: Low-latency connection to a nearby on-premise data center.

---

## 4. Enabling Local Zones

Local Zones are **disabled by default** (unlike AZs).

1.  Go to EC2 Console -> Settings.
2.  Enable "Zone Groups" (e.g., `us-west-2-lax-1` for Los Angeles).
3.  Create a Subnet in your VPC and map it to that Local Zone.

---

## 5. Exam Cheat Sheet

- **City-Level Latency**: "Application needs single-digit millisecond latency for users in Chicago" -> **Local Zones**.
- **Not On-Prem**: If the question asks for on-premise, it's **Outposts**. If it asks for a specific metro area/city, it's **Local Zones**.
- **Subset of Services**: Not all AWS services are available (e.g., usually no S3, no RDS - you connect back to parent region for those).
