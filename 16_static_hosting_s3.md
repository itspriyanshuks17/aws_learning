# 🌐 Static Website Hosting using Amazon S3

Amazon **S3 (Simple Storage Service)** can be used to **host static websites** such as portfolios, blogs, or documentation sites — without needing any servers (like EC2 or Nginx).  
It provides **scalable**, **serverless**, and **cost-effective** website hosting accessible from anywhere in the world.

---

## 🧠 Concept Overview

A **static website** contains fixed content — HTML, CSS, JavaScript, and images.  
S3 can directly serve these files to users over HTTP or HTTPS.

✅ **Dynamic content (like PHP, Node.js, or Python)** is **not supported** — for that, use AWS Amplify, API Gateway + Lambda, or EC2.

---

## ⚙️ How It Works

1. You **create an S3 bucket** to store your website files.  
2. You **enable static website hosting** in bucket properties.  
3. You **set the index and error documents** (e.g., `index.html`, `error.html`).  
4. You **make the files publicly readable** using a bucket policy.  
5. Access via S3 endpoint:
```

http://<bucket-name>.s3-website-<region>.amazonaws.com

````

---

## 🧱 Bucket Requirements

| Requirement | Description |
|--------------|--------------|
| **Bucket Name** | Must be globally unique and (if using a custom domain) match the domain name. |
| **Public Access** | Disable “Block all public access” for visibility. |
| **Permissions** | Apply a read-only bucket policy for `s3:GetObject`. |
| **Files** | Include at least an `index.html` file. |
| **Region** | Choose one near your users for faster access. |

---

## 🧩 Step-by-Step Setup (Console Method)

### 🪣 Step 1 — Create an S3 Bucket

1. Go to **S3 Console** → [https://s3.console.aws.amazon.com/s3](https://s3.console.aws.amazon.com/s3)
2. Click **“Create bucket”**.
3. Enter **Bucket name** (e.g., `my-static-site-demo`).
4. Select your preferred **Region** (e.g., `us-east-1`).
5. **Uncheck** ✅ “Block all public access”.
6. Confirm “I acknowledge that the bucket will be public”.
7. Click **Create bucket**.

---

### 📤 Step 2 — Upload Website Files

1. Open the bucket → Click **“Upload”**.  
2. Add your files:
- `index.html`
- `error.html`
- `assets/` folder (if any).
3. Click **Upload** → **Done**.

---

### 🌐 Step 3 — Enable Static Website Hosting

1. In the bucket → Go to **Properties** tab.  
2. Scroll down to **Static website hosting**.  
3. Select **“Enable”**.  
4. Choose **“Host a static website”**.  
5. Enter:
- **Index document:** `index.html`
- **Error document:** `error.html`
6. Save changes.  
7. Copy the **Website endpoint URL** — this is your site’s public address.

---

### 🔒 Step 4 — Set Public Read Permissions

1. Go to **Permissions → Bucket policy**.  
2. Add the following JSON policy:

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
````

3. Click **Save changes**.

---

### 🌍 Step 5 — Access Your Website

Visit the **S3 Website Endpoint** shown in the **Properties → Static website hosting** section:

```
http://my-static-site-demo.s3-website-us-east-1.amazonaws.com
```

Your website should load successfully! 🎉

---

## 💻 AWS CLI Steps (Alternative)

```bash
# 1. Create a bucket
aws s3api create-bucket \
  --bucket my-static-site-demo \
  --region us-east-1 \
  --create-bucket-configuration LocationConstraint=us-east-1

# 2. Upload files
aws s3 cp ./site s3://my-static-site-demo/ --recursive

# 3. Enable static website hosting
aws s3 website s3://my-static-site-demo/ \
  --index-document index.html \
  --error-document error.html

# 4. Add bucket policy
aws s3api put-bucket-policy \
  --bucket my-static-site-demo \
  --policy file://bucket-policy.json
```

---

## 🧭 Workflow Diagram

```
                   +---------------------------+
                   |      Internet Users       |
                   +-------------+-------------+
                                 |
                         [ HTTP / HTTPS ]
                                 |
                   +---------------------------+
                   |   Amazon S3 Bucket         |
                   |  (Static Website Hosting)  |
                   +-------------+-------------+
                                 |
                +------------------------------------+
                | Files: index.html, error.html, CSS |
                +------------------------------------+
                                 |
                 +------------------------------------+
                 | Optional: CloudFront + Route 53    |
                 | (HTTPS, CDN caching, custom domain)|
                 +------------------------------------+
```

---

## 🌍 Hosting with Custom Domain (Optional)

You can host your website using a **custom domain** like `www.example.com`.

### Steps:

1. Create an S3 bucket named `www.example.com`.
2. Enable static website hosting as before.
3. Create a **CloudFront Distribution**:

   * Origin: Your S3 bucket
   * Viewer Protocol Policy: Redirect HTTP → HTTPS
4. In **Route 53**, create an **Alias record (A)** pointing your domain to the CloudFront distribution.
5. Use **AWS Certificate Manager (ACM)** to issue an **SSL/TLS certificate** for HTTPS.

---

## 🔐 Security Recommendations

| Feature                    | Purpose                                                |
| -------------------------- | ------------------------------------------------------ |
| **S3 Block Public Access** | Prevent accidental exposure; only disable when needed. |
| **CloudFront + OAC**       | Securely serve content without making bucket public.   |
| **IAM Policies**           | Restrict who can modify website content.               |
| **Versioning**             | Keep backups and rollback versions.                    |
| **Access Logs**            | Enable logging for audit & monitoring.                 |

---

## 💰 Cost Considerations

| Component         | Description                                    |
| ----------------- | ---------------------------------------------- |
| **Storage**       | Pay for GB/month stored.                       |
| **Requests**      | GET, PUT, DELETE requests billed separately.   |
| **Data Transfer** | Free to CloudFront; charges apply to Internet. |

💡 *Tip:* Use **CloudFront** to reduce data transfer cost and improve speed.

---

## 🧰 AWS CLI Summary

```bash
# Create Bucket
aws s3api create-bucket --bucket my-static-site-demo --region us-east-1

# Enable website hosting
aws s3 website s3://my-static-site-demo/ --index-document index.html --error-document error.html

# Get website configuration
aws s3api get-bucket-website --bucket my-static-site-demo

# Sync site updates
aws s3 sync ./website s3://my-static-site-demo/
```

---

## 💡 Best Practices

✅ Keep all files in a `/site` or `/public` folder locally.
✅ Use **CloudFront + ACM certificate** for HTTPS.
✅ Use **Route 53** for custom DNS and domain routing.
✅ Enable **Versioning** for rollback.
✅ Store **logs** in a separate S3 bucket.
✅ Use **Lifecycle rules** to move older assets to Glacier for cost savings.

---

## 🧾 Summary

| Feature                | Description                           |
| ---------------------- | ------------------------------------- |
| **Hosting Type**       | Static (HTML, CSS, JS only)           |
| **Access Method**      | S3 Website Endpoint or CloudFront     |
| **Security**           | Bucket Policy, IAM, or CloudFront OAC |
| **Domain Integration** | Route 53 + CloudFront                 |
| **Scalability**        | Fully managed and serverless          |
| **Cost**               | Pay only for storage + data transfer  |

---

✅ **In Summary:**
Amazon S3 Static Website Hosting is a **serverless, highly available, and cost-efficient** solution for deploying static websites quickly — ideal for portfolios, documentation, or landing pages.

