# ❄️ AWS Snow Family (Data Transfer & Edge Computing Devices)

## 🧠 Overview

The **AWS Snow Family** is a collection of **physical, rugged devices** designed to **collect, process, and transfer large amounts of data** between **on-premises environments and AWS Cloud**, especially where **network connectivity is limited or unavailable**.

These devices help move **terabytes to petabytes** of data securely into **Amazon S3** or other AWS storage services.

---

## ⚙️ Why Snow Family?

| Challenge | Snow Family Solution |
|------------|----------------------|
| Slow internet-based upload to S3 | Physical data migration devices |
| Remote locations without network access | Offline data transfer |
| Harsh environments (ships, mines, field sites) | Rugged, portable edge devices |
| Need to run compute workloads at edge | On-device EC2, Lambda, or ML models |

---

## 🧩 Snow Family Members

The AWS Snow Family includes:

| Device | Capacity | Use Case | Compute Capability |
|---------|-----------|-----------|--------------------|
| **AWS Snowcone** | Up to 8 TB (SSD) or 14 TB (HDD) | Edge data collection, IoT, small-scale transfers | Yes (2 vCPUs, 4 GB RAM) |
| **AWS Snowball Edge Storage Optimized** | 80 TB usable | Large-scale data migration, storage | Yes (52 vCPUs, 208 GB RAM) |
| **AWS Snowball Edge Compute Optimized** | 42 TB usable | Edge computing (AI/ML, analytics) | Yes (104 vCPUs, 416 GB RAM + GPU option) |
| **AWS Snowmobile** | 100 PB per truck | Extremely large-scale data center migration | No (data-only transfer) |

---

## 🧭 Snow Family Device Types — Detailed Breakdown

### 🧊 1. AWS Snowcone
- **Smallest and lightest** member (weighs ~2.1 kg).  
- Used for **edge data collection**, **IoT**, **disconnected operations**.  
- **Connectivity:** Wi-Fi or Ethernet.  
- **Storage:** 8 TB SSD or 14 TB HDD.  
- **Compute:** Runs **AWS IoT Greengrass** and **EC2 instances**.

**Ideal for:**  
Remote sensors, vehicles, oil rigs, ships, field research.

---

### 🧱 2. AWS Snowball Edge
There are two variants:

#### a) **Snowball Edge Storage Optimized**
- 80 TB of usable storage.
- Used mainly for **data migration to AWS** (especially S3 or Glacier).
- Can run **EC2 AMIs** for local processing before upload.

#### b) **Snowball Edge Compute Optimized**
- 42 TB usable storage.
- **High compute power (104 vCPUs, 416 GB RAM)**.
- **Optional GPU** for **AI/ML inference** or **video analytics** at the edge.

**Ideal for:**  
Industrial IoT, smart cities, remote AI inference, real-time analytics.

---

### 🚛 3. AWS Snowmobile
- **Massive-scale data transfer device** — essentially a **45-foot rugged shipping container** transported by a **semi-truck**.
- Capacity: **up to 100 PB per Snowmobile**.
- Used for **complete data center migrations** to AWS.

**Ideal for:**  
Enterprises moving entire data centers or archives (like banks, media studios, or research labs).

---

## 🔄 Data Transfer Workflow

```

                ┌──────────────────────────────┐
                │    On-premises environment   │
                └───────────┬──────────────────┘
                            │
                            ▼
                    +------------------+
                    | AWS Snow Device  |
                    | (Snowcone,       |
                    |  Snowball, etc.) |
                    +------------------+
                            │
                            ▼
                Shipped back to AWS Data Center
                            │
                            ▼
                    +------------------+
                    |   AWS Import     |
                    | (into Amazon S3) |
                    +------------------+

````

✅ After AWS receives the device:
- Data is **uploaded into your S3 bucket**.  
- Then the device is **securely wiped** using **NIST standards**.

---

## 🔐 Security in Snow Family

| Security Feature | Description |
|------------------|--------------|
| **Hardware encryption (AES-256)** | All data encrypted automatically. |
| **AWS Key Management Service (KMS)** | Customer-managed encryption keys. |
| **Tamper-resistant enclosure** | Prevents unauthorized physical access. |
| **Chain-of-custody tracking** | Monitored via AWS Console and shipping partner. |
| **Automatic wipe after upload** | Device erased after successful import. |

---

## 💻 Step-by-Step: Using Snowball Edge (Console)

### 1️⃣ Create a Snowball Job
1. Sign in to the **AWS Management Console**.
2. Navigate to **AWS Snow Family** → **Create job**.
3. Choose **Import into Amazon S3** (or Export from S3).
4. Configure:
   - **Job type**: Import/Export
   - **Device type**: Snowball Edge Storage/Compute Optimized
   - **S3 bucket**: Destination for data upload
5. Specify **encryption key (KMS)**.
6. Provide **shipping details**.

### 2️⃣ Receive and Connect Device
- AWS ships the Snow device to your location.
- Connect via **Ethernet** and **AWS OpsHub** software.

### 3️⃣ Transfer Data
- Install **AWS OpsHub** or use **Snowball Client CLI**.
- Copy files:
  ```bash
  snowball cp /data mySnowballBucket --recursive
````

### 4️⃣ Ship Back to AWS

* AWS imports data into your S3 bucket automatically.
* You’ll be notified when the transfer completes.

---

## 🧮 AWS CLI Commands

```bash
# List Snow jobs
aws snowball list-jobs

# Describe a specific job
aws snowball describe-job --job-id <job-id>

# Create a new Snowball import job
aws snowball create-job \
  --job-type IMPORT \
  --resources '{"S3Resources":[{"BucketArn":"arn:aws:s3:::mybucket"}]}' \
  --address-id <address-id> \
  --kms-key-arn <kms-key-arn>
```

---

## 🧠 Edge Compute Capabilities

| Device                    | Compute Capabilities          | Example Use Case     |
| ------------------------- | ----------------------------- | -------------------- |
| **Snowcone**              | Run IoT Greengrass, small EC2 | IoT data filtering   |
| **Snowball Edge Compute** | EC2, Lambda, ML models        | Edge video analytics |
| **Snowmobile**            | None                          | Data migration only  |

---

## 🧩 Integration with Amazon S3

Snow devices integrate directly with **Amazon S3**, enabling:

* Bulk upload of datasets to S3.
* Export of large datasets from S3.
* Local data collection → shipped → automatically uploaded into S3.
* Optional processing before upload using **AWS Lambda or EC2** on-device.

---

## 🧭 Use Cases

| Category                    | Example                                                |
| --------------------------- | ------------------------------------------------------ |
| **Data Migration**          | Moving petabytes of data from local data centers to S3 |
| **Edge Computing**          | Running ML models or analytics near data source        |
| **Disaster Recovery**       | Collect and transfer site backups to S3                |
| **Remote Operations**       | Mining, oil rigs, research expeditions                 |
| **Air-Gapped Environments** | Secure data movement without internet                  |

---

## 🧠 Architecture: Snowball to S3 Workflow

```
                +------------------+
                |  On-prem Server  |
                +--------+---------+
                         |
              (Local copy using Snowball Client)
                         |
                         ▼
                +------------------+
                | AWS Snowball Edge |
                +--------+---------+
                         |
            Ship to AWS via Courier
                         |
                         ▼
              +------------------------+
              | AWS Data Center (S3)   |
              |   Data Imported → S3   |
              +------------------------+
```

---

## 📦 Pricing Overview

| Component            | Description                          |
| -------------------- | ------------------------------------ |
| **Per Job Fee**      | Fixed cost per Snow device job       |
| **Data Transfer In** | Free into AWS                        |
| **Data Export**      | Charged for export                   |
| **Compute Usage**    | EC2/Lambda on device billed per hour |
| **Shipping**         | Included (with AWS-prepaid label)    |

---

## ⚠️ Limitations

| Limitation                   | Description                                              |
| ---------------------------- | -------------------------------------------------------- |
| **Time-sensitive**           | Must return device within 10 days to avoid extra charges |
| **Data size cap**            | Limited to device capacity                               |
| **Not real-time**            | Offline transfer; not continuous sync                    |
| **Requires manual handling** | Physical shipping needed                                 |

---

## 💡 Best Practices

✅ Use **Snowball for >10 TB** data transfers.
✅ Use **Snowcone** for portable edge collection.
✅ Encrypt data using **KMS keys**.
✅ Use **OpsHub GUI** for easier operations.
✅ Combine with **AWS DataSync** for continuous sync after import.
✅ For huge migrations, prefer **Snowmobile** (100 PB+).

---

## 🧾 Summary

| Feature               | Snowcone             | Snowball Edge             | Snowmobile        |
| --------------------- | -------------------- | ------------------------- | ----------------- |
| **Capacity**          | 8–14 TB              | 42–80 TB                  | 100 PB            |
| **Compute**           | Basic (2 vCPU)       | Advanced (up to 104 vCPU) | None              |
| **Use Case**          | Edge data collection | Migration, Edge AI        | Massive migration |
| **Internet Required** | No                   | No                        | No                |
| **Integration**       | S3, EC2, Lambda      | S3, EC2, Lambda           | S3                |
| **Security**          | AES-256 + KMS        | AES-256 + KMS             | AES-256 + KMS     |
| **Transport**         | Courier              | Courier                   | Truck             |

---

✅ **In Summary:**

> The **AWS Snow Family** enables **secure, scalable, and cost-effective offline data transfer and edge computing**, seamlessly integrating with **Amazon S3** for hybrid and disconnected workloads — ensuring **data mobility even without internet connectivity**.


