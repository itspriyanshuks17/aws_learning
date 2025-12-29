# 🌐 AWS Global Infrastructure

Understanding the **AWS Global Infrastructure** is the first step in architecting on the cloud. It defines **where** your data lives, **how** it is protected from disasters, and **how fast** it reaches your users.

## 📋 Table of Contents

1. [Regions](#1-regions)
2. [Availability Zones (AZs)](#2-availability-zones-azs)
3. [Edge Locations (Points of Presence)](#3-edge-locations-points-of-presence)
4. [GovCloud &amp; China Regions](#4-govcloud--china-regions)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Regions

A **Region** is a **physical location** in the world where AWS clusters data centers.

- **Examples**: `us-east-1` (N. Virginia), `eu-west-1` (Ireland), `ap-south-1` (Mumbai).
- **Isolation**: Every region is physically isolated from and independent of every other region.
- **Data Sovereignty**: Data **never** leaves a region unless you explicitly copy it.

### How to choose a Region?

1. **Compliance**: Legal requirements (e.g., "Data must live in Germany").
2. **Proximity**: Latency to your users (Users in India -> Use Mumbai Region).
3. **Services**: Not all services are available in all regions (e.g., Bedrock might be in us-east-1 first).
4. **Cost**: Resources cost different amounts in different regions (e.g., Brazil is often more expensive than US).

---

## 2. Availability Zones (AZs)

Each Region has **multiple (minimum 3)** Availability Zones.

- **Definition**: An AZ is **one or more discrete data centers** with redundant power, networking, and connectivity.
- **Separation**: AZs are separated by kilometers (to prevent shared disasters like fires/floods) but linked by ultra-low latency fiber.
- **High Availability**: Deploying across multiple AZs = **Resilience**.

```text
       [ AWS Region (e.g., us-east-1) ]
      /               |                \
     /                |                 \
+--------+       +--------+         +--------+
|  AZ A  | <---> |  AZ B  | <-----> |  AZ C  |
| (DC 1) |       | (DC 2) |         | (DC 3) |
+--------+       +--------+         +--------+
    ^                 ^                  ^
    |                 |                  |
    +----(Low Latency Fiber Link)--------+
```

### Fault Domains

If AZ A goes down (power outage), AZ B and AZ C continue working. Your application should be **Multi-AZ** to survive this.

---

## 3. Edge Locations (Points of Presence)

These are data centers **separate** from Regions/AZs, configured specifically to deliver content **fast** to users.

- **Count**: 400+ globally (much more than Regions).
- **Services**: Used by **CloudFront** (CDN), **Route 53** (DNS), **Shield** (DDoS Protection), and **WAF** (Firewall).

### 1. Edge Locations vs Regional Edge Caches

- **Edge Locations**: The "front door" closest to users. Caches popular content.
- **Regional Edge Caches**: Sit between Edge Locations and the Origin. Larger cache width. Used when content falls out of the Edge Local cache.

```text
[ User ]
   |
   v
[ Edge Location (400+) ] --(Miss)--> [ Regional Edge Cache ] --(Miss)--> [ Region (Origin) ]
   |                                          |                                   |
(Return Cached) <-----------------------------+                                   |
   ^                                                                              |
   +------------------------------------------------------------------------------+
```

### Other Local Infrastructure

- **AWS Local Zones**: Extend AWS Compute/Storage to a specific city (e.g., Los Angeles) for ultra-low latency.
- **AWS Wavelength**: AWS infrastructure installed inside **5G Network Providers** (Verizon, Vodafone) for mobile edge computing.
- **AWS Outposts**: AWS racks installed in **your own on-premise data center**.

---

## 4. GovCloud & China Regions

Special regions with strict access controls.

1. **US GovCloud**:
   - For customers capable of hosting **controlled unclassified information**.
   - Operated by US Citizens only.
2. **AWS China**:
   - Operated by local partners (Sinnet in Beijing, NWCD in Ningxia) to comply with Chinese regulations.
   - AWS Accounts are totally separate (Global AWS ID does not work here).

---

## 5. Exam Cheat Sheet

- **High Availability**: "Design for failure" -> Deploy across **Multiple Availability Zones (Multi-AZ)**, NOT just multiple Edge Locations.
- **Disaster Recovery**: "Region-wide outage protection" -> Replicate data to a **different Region**.
- **Low Latency**: "Serve static content fast" -> **CloudFront (Edge Locations)**.
- **Ultra-Low Latency**: "Gaming/Trading app in a specific city" -> **Local Zones**.
- **Data Residency**: "Legal requirement to keep data in France" -> Select the **Paris Region**.
- **Scope**:
  - **IAM**: Global Service.
  - **Route 53**: Global Service.
  - **S3**: Global Console, but Buckets are _Regional_.
  - **EC2**: Regional Service.
