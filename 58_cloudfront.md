# ⚡ Amazon CloudFront - Deep Dive

Amazon CloudFront is a fast **Content Delivery Network (CDN)** service that securely delivers data, videos, applications, and APIs to customers globally with low latency, high transfer speeds, within a developer-friendly environment.

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Origins & Behaviors](#2-origins--behaviors)
3. [Caching & Invalidations](#3-caching--invalidations)
4. [Security (OAI/OAC & WAF)](#4-security-oaioac--waf)
5. [Advanced Features (Functions vs Lambda@Edge)](#5-advanced-features-functions-vs-lambdaedge)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Core Concepts

- **Edge Location**: A location where content is cached (distinct from an AWS Region). There are 400+ Edge Locations globally.
- **Origin**: The source of your files (S3, EC2, ALB, or on-premise server).
- **Distribution**: The CloudFront configuration (contains the domain name `d1234.cloudfront.net`).

### Workflow

```text
      [ Client ]
          |
(GET /beach.jpg?size=300x300)
(Host: www.example.com)
(User-Agent: Mozilla/4.0...)
          |
          v
 [ CloudFront Edge Location ] <--(Local Cache)--
          |
          +---(Cache Miss?)---> [ Forward Request ]
                                       |
                                       v
                                [ Origin Server ]
                                (S3 or HTTP/EC2)
```

---

## 2. Origins & Behaviors

### Origins

Origins are where CloudFront goes if it doesn't have the file.

1.  **S3 Bucket**: For distributing static files (images, CSS, JS).
2.  **Custom Origin**: HTTP Server (EC2, ALB, On-prem).
3.  **Origin Group**: High Availability. If Primary Origin fails, failover to Secondary Origin.

#### CloudFront with S3 Origin (S3 as an Origin)

When S3 is your origin, you typically want to restrict access so users can only view content via CloudFront (using OAC), not directly via the S3 URL.

```text
       [ User ]
          |
    (GET /logo.png) (HTTPS)
          |
          v
 [ CloudFront Distribution ] --(Signed Request w/ OAC)--> [ S3 Bucket (Private) ]
                                                            ^
  (Direct Access Blocked)                                   |
           X------------------------------------------------+
```

### Behaviors

Behaviors allow you to route different URL paths to different origins.

- Path Pattern: `/images/*` -> routes to S3 Bucket.
- Path Pattern: `/api/*` -> routes to Application Load Balancer.
- Default (\*): Catch-all for everything else.

---

## 3. Caching & Invalidations

### Cache Control

How long does an item stay at the edge?

1.  **Cache-Control Header**: Set by the origin (e.g., `max-age=3600`).
2.  **CloudFront Default TTL**: Used if origin doesn't send headers.

### Cache Key

What makes a request "unique"? By default, only the URL.

- **Query Strings**: Can be included (`?color=red` vs `?color=blue` implies different cache versions).
- **Headers**: Cache based on `Accept-Language` or `Device-Type`.
- **Cookies**: Cache based on session cookies.

### Invalidations

If you update `image.jpg` on S3, users still see the old cached version at the Edge.

- **Invalidation Request**: Forces CloudFront to clear the cache for specific files (`/images/*`).
- **Cost**: First 1,000 requests/month are free; paid after that.
- **Better Strategy**: Use **Versioning** (e.g., `image_v2.jpg`) to avoid invalidations entirely.

---

## 4. Security (OAI/OAC & WAF)

### 1. S3 Security (OAI / OAC)

How do you ensure users only access files via CloudFront and not directly via S3 URL?

- **Origin Access Identity (OAI)**: Legacy method.
- **Origin Access Control (OAC)**: Modern, secure method. Supports SSE-KMS.
- **Policy**: You update S3 Bucket Policy to "Allow read ONLY from CloudFront OAC".

```text
[ User ] --(HTTPS)--> [ CloudFront ] --(Signed Request)--> [ S3 Bucket ]
   |                                                            ^
   +---(Direct HTTP Access Blocked)-----------------------------+
```

### 2. Field-Level Encryption

Encrypts sensitive data (like Credit Card #) at the Edge, so only your backend application has the key to decrypt it.

### 3. Signed URLs / Signed Cookies

- **Use Case**: Paid content / Premium Video access.
- **Signed URL**: Access to **one file** (e.g., one movie).
- **Signed Cookie**: Access to **multiple files** (e.g., streaming a whole series).

---

## 5. Advanced Features (Functions vs Lambda@Edge)

Run code at the edge to modify requests/responses.

| Feature      | CloudFront Functions                               | Lambda@Edge                                   |
| :----------- | :------------------------------------------------- | :-------------------------------------------- |
| **Language** | JavaScript (ECMAScript 5.1).                       | Node.js / Python.                             |
| **Runtime**  | Sub-millisecond. High scale.                       | Up to 5-10 seconds.                           |
| **Use Case** | Header manipulation, URL rewrites, JWT validation. | Complex logic, Network calls to external DBs. |
| **Cost**     | 1/6th the price of Lambda@Edge.                    | More expensive.                               |

---

## 6. Comparisons & S3 Transfer Acceleration

### CloudFront vs S3 Cross-Region Replication (CRR)

| Feature            | CloudFront (CDN)                                 | S3 Cross-Region Replication (CRR)                            |
| :----------------- | :----------------------------------------------- | :----------------------------------------------------------- |
| **Purpose**        | **Cache** content closing to users globally.     | **Replicate** entire data for DR or Compliance.              |
| **Data Freshness** | Cached for **TTL** (can be stale for hours/day). | Updated in **near real-time**.                               |
| **Content Type**   | Great for **Static Content** (Images/Video).     | Great for **Dynamic Content** at low latency in few regions. |
| **Updates**        | Read-Only at Edge.                               | Read-Only at destination.                                    |
| **Location**       | **400+ Edge Locations** (Everywhere).            | Specific **Target Regions** (e.g., US -> Sydney).            |

### S3 Transfer Acceleration

How do you upload a large file (10GB) from Australia to a bucket in the USA quickly?
Instead of using the slow public internet, you upload to the **closest Edge Location**, and it travels over the **AWS fast private network**.

- **Speed**: Increases transfer speed by 50-500%.
- **Cost**: Additional cost for acceleration.
- **Test**: Use the [Speed Comparison Tool](https://s3-accelerate-speedtest.s3-accelerate.amazonaws.com/en/accelerate-speed-comparsion.html).

```text
                  [ Fast Private AWS Network ]
                /                              \
[ User in ] --> [ Edge Location ] -------------> [ S3 Bucket ]
[ Australia]    [ (Australia) ]                  [  (USA)    ]
```

---

## 7. Exam Cheat Sheet

- **S3 Security**: "Prevent users from accessing S3 directly" -> **OAC (Origin Access Control)**.
- **Private Content**: "Serve paid video content to premium members" -> **Signed URLs** (1 file) or **Signed Cookies** (many files).
- **Geo-Restriction**: "Block users from a sanctioned country" -> **CloudFront Geo Restriction** (Whitelist/Blacklist).
- **Performance**: "Users uploading large files" -> Use **S3 Transfer Acceleration** (uses Edge Locations).
- **Dynamic Content**: "Route dynamic API calls to ALB" -> Use CloudFront with **ALB as separate Origin** (Behavior `/api/*`).
