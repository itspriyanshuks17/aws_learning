# ☁️ Cloud Service Models & Shared Responsibility

## 📋 Table of Contents

1. [What is Cloud Computing?](#1-what-is-cloud-computing)
2. [Service Models (IaaS, PaaS, SaaS)](#2-service-models-iaas-paas-saas)
3. [Shared Responsibility Model](#3-shared-responsibility-model)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. What is Cloud Computing?

Cloud computing is the on-demand delivery of IT resources (compute, storage, database) over the Internet with **pay-as-you-go** pricing. Instead of buying, owning, and maintaining physical data centers, you rent technology services from a cloud provider like AWS.

---

## 2. Service Models (IaaS, PaaS, SaaS)

These models define the level of control and responsibility you have versus the cloud provider.

### A. IaaS (Infrastructure as a Service)

You manage the server (OS), network, and data. AWS manages the hardware.

- **Analogy**: Renting a car (you drive, you fill gas, you choose route).
- **Examples**: **Amazon EC2**, EBS.
- **Best For**: Admins who need full control over the OS and software stack.

### B. PaaS (Platform as a Service)

You manage the data and application code. AWS manages the OS, patching, and hardware.

- **Analogy**: Taking a taxi (driver takes you there, you just sit back).
- **Examples**: **Elastic Beanstalk**, **AWS Lambda**, RDS.
- **Best For**: Developers who want to focus on code, not server management.

### C. SaaS (Software as a Service)

You just use the software. AWS/Vendor manages everything.

- **Analogy**: Taking a bus (fixed route, shared with others).
- **Examples**: **Gmail**, **Salesforce**, Dropbox, Amazon QuickSight.
- **Best For**: End users who need a complete product.

```text
|    On-Premises    |       IaaS        |       PaaS        |       SaaS        |
| :---------------: | :---------------: | :---------------: | :---------------: |
|   Applications    |   Applications    |   Applications    |                   |
|       Data        |       Data        |       Data        |                   |
|      Runtime      |      Runtime      |                   |                   |
|    Middleware     |    Middleware     |                   |    Managed by     |
|        OS         |        OS         |    Managed by     |      Vendor       |
|  Virtualization   |    Managed by     |      Vendor       |                   |
|      Servers      |      Vendor       |                   |                   |
|      Storage      |                   |                   |                   |
|    Networking     |                   |                   |                   |
```

---

## 3. Shared Responsibility Model

Security and Compliance is a shared responsibility between AWS and the Customer.

- **AWS Responsibility (Security OF the Cloud)**:

  - Protecting the infrastructure (hardware, software, networking, facilities).
  - Managed Services (S3, DynamoDB, RDS patching).

- **Customer Responsibility (Security IN the Cloud)**:
  - Guest OS (patching EC2).
  - Firewall configuration (Security Groups).
  - IAM (User access, MFA).
  - Data Encryption.

---

## 4. Exam Cheat Sheet

- **Control**: "Max control over OS" -> **IaaS** (EC2).
- **Speed**: "Focus on code, not server management" -> **PaaS** (Elastic Beanstalk/Lambda).
- **IaaS Example**: EC2.
- **PaaS Example**: Elastic Beanstalk, RDS.
- **SaaS Example**: QuickSight, Amazon Connect.
- **Shared Responsibility**: You are responsible for **OS Patching** (on EC2) and **Data Encryption**. AWS is responsible for **Physical Security**.
