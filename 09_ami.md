# 🧩 AWS AMI (Amazon Machine Image)

## 📘 Overview
An **Amazon Machine Image (AMI)** is a **pre-configured template** that contains the information required to **launch an EC2 instance**.  
It includes the **operating system, application server, and applications** necessary to start your instance.

Think of an AMI as a **“blueprint”** for your EC2 instances — defining what software and configuration they’ll have when launched.

---

## ⚙️ Components of an AMI
1. **Root Volume Template**  
   - Contains the **OS**, **application**, and **configuration files**.  
   - For example: Amazon Linux, Ubuntu, or Windows Server.

2. **Launch Permissions**  
   - Controls who can use the AMI to launch instances.  
   - Can be:
     - **Private** (only your account)
     - **Public** (anyone can use)
     - **Shared** (specific AWS accounts)

3. **Block Device Mapping**  
   - Specifies **EBS volumes** to attach to the instance at launch.  
   - Includes:
     - Boot volume (root)
     - Additional data volumes

---

## 🧱 Types of AMIs
| Type | Description | Example Use Case |
|------|--------------|------------------|
| **Public AMIs** | Provided by AWS or community; free to use | Amazon Linux, Ubuntu |
| **Private AMIs** | Custom AMIs created by users | Enterprise-specific OS setup |
| **Marketplace AMIs** | Pre-configured commercial software images | WordPress, SAP, Fortinet |
| **Shared AMIs** | AMIs shared with other AWS accounts | Development collaboration |

---

## 🧰 Creating a Custom AMI
You can create your own AMI from an existing instance to preserve its configuration.

### ✅ Steps:
1. Launch and configure an **EC2 instance**.
2. Install necessary **software and updates**.
3. From the **EC2 Console**, choose:
```

Actions → Image and templates → Create image

````
4. AWS takes an **EBS snapshot** of the root volume and creates the **AMI**.
5. The AMI appears in **Images → AMIs** (available in the same region).

---

## 🔁 AMI Lifecycle
```text
    [ Launch Instance ]
             |
      +--------------+
      |  EC2 Instance |
      +-------+------+
              |
      [ Create Image (AMI) ]
              |
       +---------------+
       |   AMI Stored  |
       |   in Region   |
       +---------------+
              |
      [ EBS Snapshot (Backup) ]
              |
       +---------------+
       |  S3 Storage   |
       +---------------+
````

---

## 🌍 AMI and Regions

* AMIs are **region-specific**.
* You can **copy** an AMI to another region for global deployment.
  Example:

  ```
  aws ec2 copy-image --source-image-id ami-12345678 --source-region us-east-1 --region ap-south-1 --name "MyCopiedAMI"
  ```

---

## 🧠 Use Cases

* Quickly launch multiple **identical EC2 instances**.
* Maintain **standardized server setups**.
* Enable **auto-scaling** with consistent configurations.
* Simplify **disaster recovery** by using saved AMIs.

---

## 🪣 AMI vs. Snapshot

| Feature    | AMI                             | EBS Snapshot            |
| ---------- | ------------------------------- | ----------------------- |
| Purpose    | Blueprint for EC2               | Backup of a volume      |
| Includes   | OS + configurations + app setup | Raw data of a volume    |
| Storage    | S3 (internally managed)         | S3 (internally managed) |
| Used For   | Launching new instances         | Restoring volume data   |
| Dependency | Built using snapshots           | Used to create AMIs     |

---

## 🧩 Relationship Between AMI, EC2 & EBS

```text
   +---------------------+
   |     Amazon S3       |
   | (Stores snapshots)  |
   +----------+----------+
              |
       [ EBS Snapshot ]
              |
       +------+------+
       |     AMI     | --> Template for EC2
       +------+------+
              |
       [ Launch Instance ]
              |
       +------+------+
       |   EC2 Instance  |
       +-----------------+
```

---

## 🛡️ Best Practices

* Always **tag** AMIs (e.g., Name, Project, Version).
* Regularly **deregister unused AMIs** to save costs.
* Use **AMI versioning** for updates and rollback.
* Encrypt AMIs using **KMS** when handling sensitive data.
* Automate AMI creation using **AWS Lambda + EventBridge**.

---

## 💬 Example AWS CLI Commands

### List available AMIs

```bash
aws ec2 describe-images --owners self --query 'Images[*].[ImageId,Name,CreationDate]' --output table
```

### Create AMI from instance

```bash
aws ec2 create-image --instance-id i-0abcd1234ef5678gh --name "MyAppImage"
```

### Deregister AMI

```bash
aws ec2 deregister-image --image-id ami-0123456789abcdef
```

---

## 🧾 Summary

| Concept          | Description                                       |
| ---------------- | ------------------------------------------------- |
| **AMI**          | A pre-configured template to launch EC2 instances |
| **Stored In**    | Amazon S3 (managed by AWS)                        |
| **Created From** | Existing EC2 instance or snapshot                 |
| **Used For**     | Standardization, scaling, and recovery            |
| **Region Scope** | Region-specific but can be copied                 |

---
