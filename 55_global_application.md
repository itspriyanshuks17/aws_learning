# 🌍 AWS Global Application Architecture

Building a **Global Application** means serving users around the world with **low latency** and **high availability**. AWS provides specific services to cache content closer to users and route traffic across the AWS global network.

## 📋 Table of Contents

1. [Amazon Route 53 (Global DNS)](#1-amazon-route-53-global-dns)
2. [Amazon CloudFront (CDN)](#2-amazon-cloudfront-cdn)
3. [AWS Global Accelerator](#3-aws-global-accelerator)
4. [S3 Cross-Region Replication (CRR)](#4-s3-cross-region-replication-crr)
5. [Global Deployment Architectures](#5-global-deployment-architectures)
6. [Comparison: CloudFront vs Global Accelerator](#6-comparison-cloudfront-vs-global-accelerator)
7. [Exam Cheat Sheet](#7-exam-cheat-sheet)

---

## 1. Amazon Route 53 (Global DNS)

Route 53 is a **highly available and scalable DNS web service**. It translates names (`www.example.com`) to IP addresses (`192.0.2.1`).

### Routing Policies

Route 53 is "smart"—it doesn't just return an IP; it decides _which_ IP to return based on policies.

1.  **Simple**: Round-robin (random). No health checks.
2.  **Weighted**: Split traffic (e.g., 80% to V1, 20% to V2) for canary testing.
3.  **Latency**: Route user to the **fastest** region (lowest latency).
4.  **Failover**: Active-Passive. If Primary is unhealthy, route to Disaster Recovery (DR).
5.  **Geolocation**: Route based on user's location (e.g., France users -> Paris Region).

```text
       (User in India)
             |
             v
      [ Route 53 ]
        /        \
   (Latency)   (Latency)
      /            \
     v              v
[ Mumbai Region ] [ N. Virginia Region ]
   (Active)          (Too Slow)
```

---

## 2. Amazon CloudFront (CDN)

CloudFront is a **Content Delivery Network (CDN)**. It routes specific content to **Edge Locations** (servers around the world) to cache it closer to the user.

- **Origins**: S3 Bucket, EC2 Instance, Application Load Balancer.
- **Edge Locations**: 400+ points of presence globally.
- **TTL (Time To Live)**: How long objects stay in cache.

### Architectural Flow

```text
[ User in London ] --(Request)--> [ Edge Location (London) ]
                                          |
                                     (Cache Miss?)
                                          |
                                          v
                                    [ Origin (S3 in US-East-1) ]
                                          |
                                     (Return & Cache)
                                          |
                                          v
                                  [ Edge Location (London) ] --(Response)--> [ User ]
```

---

## 3. AWS Global Accelerator

Global Accelerator improves availability and performance by directing traffic through the **AWS global network** infrastructure, bypassing the public internet which can be congested.

- **Anycast IP**: You get **2 static IP addresses** that work globally.
- **Performance**: Traffic enters the AWS network at the **closest Edge Location** and travels quickly over the AWS fiber backbone.
- **Protocol**: Great for **non-HTTP** (TCP/UDP) traffic (e.g., Gaming, MQTT, Voice).

```text
[ User ] --(Public Internet)--> [ Edge Location ] --(AWS Global Network)--> [ ALB in Region ]
```

---

## 4. S3 Cross-Region Replication (CRR)

For disaster recovery or compliance, you can duplicate data across regions.

- **Async**: Replication is asynchronous.
- **Versioning**: Must be enabled on Source and Destination buckets.
- **Use Case**: Minimize latency for global users accessing large files.

---

---

## 5. Global Deployment Architectures

When building global applications, you must balance **Availability**, **Latency**, and **Complexity**.

### A. Single Region, Single AZ

- **Concept**: App running on one EC2 instance in one AZ.
- **Pros**: Easiest to set up.
- **Cons**: **High Latency** for global users, **Low Availability** (if AZ fails, app fails).
- **Difficulty**: Low.

```text
[ Global User ] --(High Latency)--> [ Region A (AZ 1) ]
```

### B. Single Region, Multi AZ

- **Concept**: App running in multiple AZs behind an ALB.
- **Pros**: **High Availability** (survives AZ failure).
- **Cons**: Still **High Latency** for global users.
- **Difficulty**: Medium.

```text
                                     /-> [ AZ 1 (Instance) ]
[ Global User ] --(High Latency)--> [ ALB ]
                                     \-> [ AZ 2 (Instance) ]
```

### C. Multi-Region, Active-Passive

- **Concept**: Primary Region (Active) handles writes. Secondary Region (Passive) is for read-scalability or Disaster Recovery.
- **Reads**: Can be **Global** (Low Latency) using Read Replicas.
- **Writes**: Must go to Active Region (**High Latency** for distant users).
- **Difficulty**: High (Data Replication lag).

```text
[ User A ] --(Read)--> [ Region B (Passive) ]
     |
  (Write)
     |
     v
[ Region A (Active) ] --(Async Replication)--> [ Region B (Passive) ]
```

### D. Multi-Region, Active-Active

- **Concept**: All regions handle Reads and Writes (e.g., DynamoDB Global Tables).
- **Pros**: **Lowest Latency** for both Reads and Writes (users connect to nearest region).
- **Cons**: **Very Complex** conflict resolution usage.
- **Difficulty**: Very High.

```text
[ User A ] --(Read/Write)--> [ Region A (Active) ] <--> [ Region B (Active) ] <--(Read/Write)-- [ User B ]
```

---

## 6. Comparison: CloudFront vs Global Accelerator

| Feature          | CloudFront (CDN)                            | Global Accelerator                              |
| :--------------- | :------------------------------------------ | :---------------------------------------------- |
| **Primary Use**  | **Caching Content** (Images, Videos, HTML). | **Network Performance** (TCP/UDP acceleration). |
| **Protocol**     | Mostly **HTTP/HTTPS**.                      | **TCP/UDP** (and HTTP).                         |
| **IP Addresses** | Dynamic (DNS based).                        | **2 Static Anycast IPs**.                       |
| **Caching**      | **Yes** (at Edge).                          | **No** (Proxy only).                            |

---

## 7. Exam Cheat Sheet

- **Static IP**: "Need a fixed IP for a global application" -> **Global Accelerator** (Anycast IP).
- **Caching**: "Reduce latency for static assets (images/css)" -> **CloudFront**.
- **Latency Routing**: "Route user to nearest region based on network delay" -> **Route 53 Latency Policy**.
- **Disaster Recovery**: "Failover to a static site on S3 if ALB is down" -> **Route 53 Failover Policy**.
- **Security**: "Block SQL Injection/XSS attacks at the edge" -> Integrate **AWS WAF** (Web Application Firewall) with **CloudFront**.
