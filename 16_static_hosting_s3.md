# 🌐 Static Website Hosting using Amazon S3

Amazon **S3 (Simple Storage Service)** can be used to **host static websites** such as portfolios, blogs, landing pages, or documentation sites — without any web server (like EC2 or Nginx).  
It provides **serverless, scalable, and highly available** hosting with global accessibility.

---

## 🧠 Concept Overview

**Static Website** = HTML + CSS + JavaScript + Images  
( No dynamic server-side code like PHP, Python, or Node.js )

When you enable static website hosting, **S3 acts as a web server** that directly serves your static content over the Internet.

---

## ⚙️ How It Works

1. You **create an S3 bucket** with your website files (HTML, CSS, JS, images, etc.).
2. You **enable static website hosting** and specify:
   - **Index document** (e.g., `index.html`)
   - **Error document** (e.g., `error.html`)
3. You **configure bucket permissions** to make content **publicly accessible**.
4. You **access your website** using the S3 website endpoint:

```bash

http://<bucket-name>.s3-website-<region>.amazonaws.com

```

---

## 📂 Bucket Requirements

| Requirement | Description |
|--------------|--------------|
| **Bucket Name** | Must match the domain name (for custom domain hosting). |
| **Region** | Choose region close to your target users for faster access. |
| **Objects** | Upload website assets (HTML, CSS, JS, images). |
| **Public Access** | Disable “Block Public Access” setting for website visibility. |
| **Permissions** | Attach a bucket policy allowing public read (GET) requests. |

---

## 🧩 Step-by-Step Setup

### 1️⃣ Create S3 Bucket

```bash
aws s3api create-bucket \
--bucket my-static-site-demo \
--region us-east-1 \
--create-bucket-configuration LocationConstraint=us-east-1
````

### 2️⃣ Upload Website Files

```bash
aws s3 cp index.html s3://my-static-site-demo/
aws s3 cp error.html s3://my-static-site-demo/
aws s3 cp --recursive ./assets s3://my-static-site-demo/assets/
```

### 3️⃣ Enable Static Website Hosting

```bash
aws s3 website s3://my-static-site-demo/ \
  --index-document index.html \
  --error-document error.html
```

### 4️⃣ Configure Bucket Policy (Public Read)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::my-static-site-demo/*"]
    }
  ]
}
```

Apply policy:

```bash
aws s3api put-bucket-policy \
  --bucket my-static-site-demo \
  --policy file://bucket-policy.json
```

### 5️⃣ Access Your Website

Open the S3 website endpoint in your browser:

```
http://my-static-site-demo.s3-website-us-east-1.amazonaws.com
```

---

## 🧭 Workflow Diagram

```
                   +---------------------------+
                   |     Internet / Users      |
                   +-------------+-------------+
                                 |
                         [ HTTP / HTTPS ]
                                 |
                   +---------------------------+
                   |    Amazon S3 Bucket       |
                   |  (Static Website Hosting) |
                   +-------------+-------------+
                                 |
             +----------------------------------------+
             | Files: index.html, error.html, /assets |
             +----------------------------------------+
                                 |
                  +-------------------------------+
                  |  Optional: CloudFront CDN      |
                  |  (Caching + HTTPS via ACM)     |
                  +-------------------------------+
                                 |
                      [ Faster, Secure Global Access ]
```

---

## 🌍 Optional: Use a Custom Domain (via Route 53 + CloudFront)

You can link your **custom domain** (e.g., `www.example.com`) to the S3 static website.

### Steps:

1. Register domain in **Route 53** or another registrar.
2. Create an **Alias record** (A record) pointing to **CloudFront distribution**.
3. Configure **CloudFront** to use:

   * **Origin:** S3 bucket
   * **Viewer Protocol:** Redirect HTTP → HTTPS
4. Attach an **SSL/TLS certificate** from **AWS Certificate Manager (ACM)**.

---

## 🔒 Security & Access Control

| Mechanism                                  | Description                                                                     |
| ------------------------------------------ | ------------------------------------------------------------------------------- |
| **Bucket Policy**                          | Grants public or restricted access to S3 objects.                               |
| **IAM Roles**                              | Used for internal programmatic access instead of public access.                 |
| **CloudFront OAC (Origin Access Control)** | Secure S3 access behind CloudFront (recommended over public access).            |
| **S3 Block Public Access**                 | Global toggle to restrict public access (must be disabled for website hosting). |

---

## 🧮 Cost Considerations

* **Free Tier:** 5 GB storage + 20,000 GET + 2,000 PUT requests/month.
* **Pricing Factors:**

  * Storage size (per GB/month)
  * Data transfer (out to Internet)
  * Requests (GET, PUT, DELETE)

💡 *Tip:* Use **CloudFront CDN** to reduce data transfer costs and latency.

---

## 🧰 AWS CLI Commands Summary

```bash
# Create and configure bucket
aws s3api create-bucket --bucket my-static-site-demo --region us-east-1
aws s3 website s3://my-static-site-demo/ --index-document index.html --error-document error.html

# Upload files
aws s3 cp ./site s3://my-static-site-demo/ --recursive

# Make objects public
aws s3api put-bucket-policy --bucket my-static-site-demo --policy file://bucket-policy.json

# Get website endpoint
aws s3api get-bucket-website --bucket my-static-site-demo
```

---

## 💡 Best Practices

✅ Use **CloudFront + OAC** for secure, HTTPS-enabled hosting.
✅ Enable **S3 Versioning** for rollback capability.
✅ Enable **S3 Access Logs** for audit and monitoring.
✅ Use **least privilege IAM policies** when granting access.
✅ Store assets under `/assets/` for better organization.
✅ Set up **Lifecycle Rules** for cost optimization (e.g., move old files to Glacier).

---

## 🧾 Summary

| Feature                | Description                        |
| ---------------------- | ---------------------------------- |
| **Hosting Type**       | Static (no server-side scripting)  |
| **Access Method**      | S3 Website Endpoint or CloudFront  |
| **Security**           | Bucket Policy, IAM, CloudFront OAC |
| **Domain Integration** | Route 53 + CloudFront              |
| **Scalability**        | Automatic, unlimited requests      |
| **Cost Efficiency**    | Pay only for storage & requests    |

---

✅ **In Summary:**
Amazon S3 Static Website Hosting is a **serverless, low-cost, and globally scalable** solution to deploy static websites in minutes — perfect for personal portfolios, documentation, and corporate landing pages.

