# ☸️ Amazon EKS - Deep Dive

Amazon EKS (Elastic Kubernetes Service) is a managed service that makes it easy to run Kubernetes on AWS without installing or operating your own Kubernetes Control Plane.

## 📋 Table of Contents

1. [What is Kubernetes (K8s)?](#1-what-is-kubernetes-k8s)
2. [EKS Architecture](#2-eks-architecture)
3. [EKS Nodes (Data Plane)](#3-eks-nodes-data-plane)
4. [EKS vs ECS](#4-eks-vs-ecs)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. What is Kubernetes (K8s)?

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications.

- **Agnostic**: Works on AWS, Azure, Google Cloud, or On-Premise.
- **Standard**: It is the industry standard for container orchestration.

---

## 2. EKS Architecture

EKS separates the **Control Plane** (The Brain) from the **Data Plane** (The Muscle).

### A. Managed Control Plane (The Brain)

- **Managed by AWS**: AWS runs the Master Nodes (API Server, etcd, Scheduler) across multiple AZs.
- **No Access**: You cannot SSH into master nodes. You talk to them via the `kubectl` CLI.
- **Cost**: You pay ~$0.10/hour per cluster.

### B. Data Plane (The Muscle)

- Where your containers (Pods) actually run.
- **Managed by You**: You choose how to run the worker nodes (EC2 or Fargate).

### Architecture Diagram

```
       [ Managed Control Plane ]           [ Data Plane (Your VPC) ]
      (AWS Account - Hidden VPC)          (Your Account - Your VPC)
     +---------------------------+       +---------------------------+
     |   API Server   etcd       | <---> |  [ Node ]   [ Node ]      |
     |   Scheduler    Controller |       |  (Worker)   (Worker)      |
     +---------------------------+       +---------------------------+
```

---

## 3. EKS Nodes (Data Plane)

There are three ways to launch compute for your cluster:

1.  **Managed Node Groups**:
    - **Simplest**. AWS creates and manages the EC2 instances for you (Auto Scaling Groups).
    - You can still SSH if configured, but patching is automated.
2.  **Self-Managed Nodes**:
    - **Hardest**. You create EC2 instances, install `kubelet`, and join them to the cluster manually.
    - Use case: Specific OS requirements or pre-existing reserved instances.
3.  **AWS Fargate (Serverless)**:
    - **No Nodes**. Each Pod runs as a standalone Fargate task.
    - **Pricing**: Pay per Pod (vCPU/RAM).

---

## 4. EKS vs ECS

| Feature         | Amazon ECS                             | Amazon EKS                                     |
| :-------------- | :------------------------------------- | :--------------------------------------------- |
| **Simple?**     | **Yes**. AWS native, easiest to start. | **No**. Steep learning curve.                  |
| **Portability** | AWS Only. Hard to move to Azure/GCP.   | **High**. Run K8s anywhere (Cloud or On-Prem). |
| **Tooling**     | AWS Tools (CLI, CloudFormation).       | K8s Tools (kubectl, Helm, Charts).             |
| **Control**     | Standard AWS controls.                 | Granular control over scheduling/networking.   |

---

## 5. Exam Cheat Sheet

- **Cloud Agnostic**: "Migrate from on-premise Kubernetes to Cloud" -> **EKS**.
- **Open Source Tooling**: "Use existing Helm charts and kubectl scripts" -> **EKS**.
- **EKS Distro**: "Run the exact same Kubernetes version on-premise as in EKS" -> **EKS Distro**.
- **EKS Anywhere**: "Create and operate Kubernetes clusters on your own infrastructure" -> **EKS Anywhere**.
- **Fargate Profile**: Define which pods run on Fargate vs EC2 using a "Fargate Profile".
