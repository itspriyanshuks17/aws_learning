# 🌍 Cloud Deployment Models

## 📋 Table of Contents

1. [Deployment Models](#1-deployment-models)
2. [Exam Cheat Sheet](#2-exam-cheat-sheet)

---

## 1. Deployment Models

These models define **where** the infrastructure is located and **who** has access to it.

1.  **Public Cloud**: Resources are owned and operated by a third-party provider (AWS, Azure, GCP) and delivered over the internet.

    - **Pros**: No CapEx, high scalability.
    - **Cons**: Less control over security/hardware.

2.  **Private Cloud**: Resources are used exclusively by a single business or organization. Can be on-premise or hosted.

    - **Pros**: Complete control, security compliance.
    - **Cons**: High cost, maintenance responsibility.

3.  **Hybrid Cloud**: A combination of public and private clouds, connected by technology (e.g., AWS Direct Connect).

    - **Use Case**: Keep sensitive DB on-prem (Private) but run web app on AWS (Public).

4.  **Multi-Cloud**: Using multiple public cloud providers (e.g., AWS + Azure + Google Cloud) simultaneously.

    - **Pros**: Avoid vendor lock-in, use "best of breed" services from each provider.
    - **Cons**: Complex management.

5.  **Community Cloud**: Infrastructure shared by several organizations with common concerns (e.g., standards, security requirements).
    - **Use Case**: Banks sharing a secure financial cloud or government agencies using GovCloud.

---

## 2. Exam Cheat Sheet

- **Private**: "Strict security requirements requiring dedicated hardware" -> **Private Cloud** (or Dedicated Hosts).
- **Hybrid**: "Extend on-premise data center to cloud" -> **Hybrid Cloud**.
- **Community**: "Shared by multiple organizations with same regulatory needs" -> **Community Cloud**.
- **Multi-Cloud**: "Distribute workload across AWS and Azure" -> **Multi-Cloud**.
