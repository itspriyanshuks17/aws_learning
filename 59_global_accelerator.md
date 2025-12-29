# 🚀 AWS Global Accelerator - Deep Dive

AWS Global Accelerator is a networking service that improves the availability, performance, and security of your applications using the **AWS global network**.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [How It Works (Unicast vs Anycast)](#2-how-it-works-unicast-vs-anycast)
3. [Traffic Flow & Performance](#3-traffic-flow--performance)
4. [Client IP Preservation](#4-client-ip-preservation)
5. [Comparison: Global Accelerator vs CloudFront](#5-comparison-global-accelerator-vs-cloudfront)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Core Concepts

- **Static IPs**: Provides **two static Anycast IP addresses** that act as a fixed entry point to your application per region.
- **Global Layout**: Uses the AWS global network (fiber optic backbone) instead of the public internet.
- **Endpoints**: Supports ALBs, NLBs, EC2 instances, and Elastic IPs.
- **Failover**: Automatically re-routes traffic to healthy endpoints in seconds.

---

## 2. How It Works (Unicast vs Anycast)

### Unicast IP (Traditional)

One IP address = One Server.
If users are in India and the server is in the USA, data hops across many public ISPs.

- **Problem**: High latency, jitter, packet loss.

### Anycast IP (Global Accelerator)

One IP address = **Multiple Servers** globally.
Server A and Server B both announce the same IP. The user is routed to the **physically closest** entry point.

```text
       (Anycast IP: 1.2.3.4)
           /           \
      [ User A ]      [ User B ]
      (India)          (USA)
         |               |
         v               v
 [ Edge Mumbai ]    [ Edge Virginia ]
         |               |
  (AWS Backbone)    (AWS Backbone)
         \               /
          \             /
           v           v
        [ Application in USA ]
```

---

## 3. Traffic Flow & Performance

1.  **Entry**: User connects to the closest **Edge Location** using the Anycast IP.
2.  **Transit**: Traffic rides the **private AWS global network** (optimized, no jitter).
3.  **Exit**: Traffic hits the endpoint (ALB/EC2) in the destination Region.

- **Benefit**: Bypasses congested public internet. ~60% latency improvement.
- **Intelligent Routing**: If the application in Region A fails, GA routes traffic to Region B instantly (faster than DNS updates).

---

## 4. Client IP Preservation

- **ALB**: Client IP is preserved in `X-Forwarded-For` header.
- **NLB**: Client IP **IS** preserved (if configured) directly.
- **EC2**: Client IP **IS** preserved.

- **Security**: Shield Standard is enabled by default.

---

## 5. Comparison: Global Accelerator vs CloudFront

| Feature          | CloudFront                       | Global Accelerator                      |
| :--------------- | :------------------------------- | :-------------------------------------- |
| **Primary Goal** | **Caching** content at the Edge. | **Proxying** packets over AWS Backbone. |
| **Protocol**     | **HTTP / HTTPS** mostly.         | **TCP / UDP** (Gaming, IoT, Voice).     |
| **IP Addresses** | Dynamic (DNS).                   | **Static** (2 Anycast IPs).             |
| **Caching**      | Yes (Images, Videos).            | **No** (It's a tunnel).                 |
| **Use Case**     | S3 Static Websites, APIs.        | Non-HTTP apps, Constant IP requirement. |

---

## 6. Exam Cheat Sheet

- **Static IP Requirement**: "App needs a fixed IP whitelisted by clients firewall" -> **Global Accelerator**.
- **UDP Traffic**: "Gaming application using UDP" -> **Global Accelerator**.
- **Blue/Green**: "Shift traffic between Regions instantly" -> **Global Accelerator** (Traffic Dials).
- **Not DNS**: "Avoid DNS caching issues" -> **Global Accelerator** (IPs don't change).
