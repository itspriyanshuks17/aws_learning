# 🏗️ Monolith vs Microservices Architecture

Understanding the difference between **Monolithic** and **Microservices** architectures is fundamental to designing modern cloud applications.

## 📋 Table of Contents

1. [Monolithic Architecture](#1-monolithic-architecture)
2. [Microservices Architecture](#2-microservices-architecture)
3. [AWS Enablers for Microservices](#3-aws-enablers-for-microservices)
4. [Exam Cheat Sheet](#4-exam-cheat-sheet)

---

## 1. Monolithic Architecture

- **Definition**: An application where all components (UI, API, Database Access, Business Logic) are tightly coupled and run as a single service.
- **Pros**: Simple to deploy (one file), easier to test locally.
- **Cons**:
  - **Single Point of Failure**: If one component crashes, the whole app crashes.
  - **Scaling Difficulty**: You have to scale the _entire_ app, even if only one feature is under heavy load.
  - **Tech Stack Lock-in**: Hard to change languages or frameworks once built.

---

## 2. Microservices Architecture

- **Definition**: An application built as a collection of small, independent services that communicate over APIs (HTTP/REST, SQS).
- **Pros**:
  - **Fault Isolation**: If the "Billing Service" fails, the "User Profile" service still works.
  - **Independent Scaling**: Scale only the services that need it.
  - **Tech Freedom**: Comparison Service can be Python, while Payment Service is Java.
- **Cons**: Higher complexity in management, deployment, and monitoring.

---

## 3. AWS Enablers for Microservices

AWS provides the building blocks to essentially "force" you into a microservices pattern:

| Category              | AWS Service     | Role                                                          |
| :-------------------- | :-------------- | :------------------------------------------------------------ |
| **Compute**           | **ECS / EKS**   | Running containerized microservices.                          |
| **Compute**           | **Lambda**      | Running serverless functions (ultimate microservice).         |
| **API**               | **API Gateway** | The "Front Door" that routes traffic to correct microservice. |
| **Messaging**         | **SQS / SNS**   | Decoupling services so they don't break if one is slow.       |
| **Service Discovery** | **Cloud Map**   | Helping services find each other's IP addresses dynamically.  |

---

## 4. Exam Cheat Sheet

- **Decoupling**: "Components are tightly coupled and failing together" -> **Migrate to Microservices using SQS/SNS**.
- **Scalability**: "Need to scale the checkout process independently from the catalog" -> **Microservices**.
- **Complexity**: "Moving to microservices increases..." -> **Operational overhead (monitoring, tracing)**. Use **X-Ray** for tracing.
