# 🚦 Amazon Route 53 - Deep Dive

Amazon Route 53 is a highly available and scalable **cloud Domain Name System (DNS) web service**. It translates human readable names (`google.com`) into numeric IP addresses (`192.0.2.1`).

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Records & TTL](#2-records--ttl)
3. [Routing Policies (The Heart of Route 53)](#3-routing-policies-the-heart-of-route-53)
4. [Health Checks](#4-health-checks)
5. [Hosted Zones (Public vs Private)](#5-hosted-zones-public-vs-private)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Core Concepts

- **DNS (Domain Name System)**: The phonebook of the internet.
- **Domain Registrar**: Route 53 can register domains (you buy `mycoolsite.com` from AWS).
- **Highly Available**: SLA of **100% availability** (The only AWS service with 100%).
- **Authoritative DNS**: Route 53 has the final say on where your domain points.

---

## 2. Records & TTL

### Record Types

- **A**: Maps hostname to **IPv4** (e.g., `1.2.3.4`).
- **AAAA**: Maps hostname to **IPv6**.
- **CNAME**: Maps hostname to **another hostname** (e.g., `m.example.com` -> `mobile.example.com`).
  - _Limit_: Cannot create CNAME for the Root Domain (Apex) like `example.com`.
- **Alias**: AWS Specific. Maps hostname to **AWS Resource** (ALB, CloudFront, S3).
  - _Benefit_: Works for Root Domain (`example.com`). Free of charge. Dynamic (updates automatically if ALB IP changes).

### TTL (Time To Live)

The caching period for DNS query results.

- **High TTL (24hrs)**: Less traffic to Route 53 (cheaper), but changes take 24hrs to propagate.
- **Low TTL (60s)**: More traffic (expensive), but changes happen fast.

---

## 3. Routing Policies (The Heart of Route 53)

Route 53 doesn't just return an IP; it decides _which_ IP to return based on logic.

### 1. Simple Routing

- **Use Case**: Single resource (e.g., one web server).
- **Behavior**: Returns IP address. No health checks. Multi-value answer is possible (random order).

```text
[ User ] --(Query)--> [ Route 53 ] --(A Record)--> [ 10.0.0.1 ]
```

### 2. Weighted Routing

- **Use Case**: Canary testing, Blue/Green deployment, split traffic.
- **Behavior**: Control % of requests that go to each resource.

```text
                     /--(80%)--> [ V1 (Old) ]
[ Route 53 ] --(Weight)--<
                     \--(20%)--> [ V2 (New) ]
```

### 3. Latency Routing

- **Use Case**: Global users strictly needing best performance.
- **Behavior**: AWS checks network latency and routes user to the **closest** (fastest) region.

```text
[ User in Japan ] --> [ Route 53 ] --> [ Tokyo Region ] (10ms)
                                  \--> [ US-East Region ] (150ms)
```

### 4. Failover Routing (Active-Passive)

- **Use Case**: Disaster Recovery (DR).
- **Behavior**: Health Check monitors Primary. If Primary fails, Route 53 updates DNS to point to Secondary.

```text
[ Route 53 ] --(Check)--> [ Primary (Active) ]
     |
  (Fail?)
     |
     v
[ Secondary (DR Site) ]
```

### 5. Geolocation Routing

- **Use Case**: Legal compliance ("German data stays in Germany"), Language localization.
- **Behavior**: Routing based on **User's Location** (Country, Continent).

### 6. Geoproximity Routing (Traffic Flow)

- **Use Case**: Shift traffic between regions based on a "Bias" value.
- **Behavior**: "Expand" the reach of a region by increasing bias. Visualized in "Traffic Flow" mode.

### 7. Multivalue Answer

- **Use Case**: Simple Load Balancing (Client-side).
- **Behavior**: Returns multiple healthy IPs. Random selection by client.

---

## 4. Health Checks

Route 53 Health Checks monitor endpoints (often public IPs) or CloudWatch Alarms.

1.  **Monitor an Endpoint**: Checks HTTP/HTTPS/TCP.
2.  **Calculated**: Combine multiple checks (AND/OR).
3.  **CloudWatch Alarm**: Check internal metrics (e.g., DynamoDB throttles).

- **Integration**: Health Checks are **required** for Failover Routing.

---

## 5. Hosted Zones (Public vs Private)

A **Hosted Zone** is a container for records for a specific domain.

- **Public Hosted Zone**: Accessible from the internet. Routes public traffic (e.g., `google.com`).
- **Private Hosted Zone**: Accessible **ONLY inside your VPC**.
  - _Use Case_: Internal URLs like `db.prod.internal`.
  - _Security_: DNS resolution never leaves private network.

```text
[ EC2 in VPC ] --(Query: db.internal)--> [ Private Hosted Zone ] --(Reply: 10.0.1.5)--> [ EC2 ]
```

---

## 6. Exam Cheat Sheet

- **Alias vs CNAME**: "Need to point root domain (`example.com`) to ALB" -> Use **Alias Record** (CNAME fails at root).
- **Failover**: "Automatic switch to S3 Static Website if Primary is down" -> **Failover Routing** + **Health Check**.
- **Performance**: "Route users to region with lowest network delay" -> **Latency Routing**.
- **Geography**: "Restrict content to US users only" -> **Geolocation Routing**.
- **Private DNS**: "Hostname resolving only within VPC" -> **Private Hosted Zone**.
