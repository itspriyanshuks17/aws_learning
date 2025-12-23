# 🌱 AWS Elastic Beanstalk - Deep Dive

Elastic Beanstalk is a **Platform as a Service (PaaS)**. It **allows developers** to **deploy code without worrying about configuring the underlying infrastructure** (EC2, Load Balancer, Auto Scaling).

You **just upload your code** (Java, .NET, PHP, Node.js, Python, Ruby, Go, or Docker), and **Elastic Beanstalk handles the deployment** (capacity provisioning, load balancing, auto-scaling, and health monitoring).

## 📋 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Environment Types](#2-environment-types)
3. [Architecture Models](#3-architecture-models)
4. [Deployment Policies (Critical)](#4-deployment-policies-critical)
5. [Configuration (.ebextensions)](#5-configuration-ebextensions)
6. [Exam Cheat Sheet](#6-exam-cheat-sheet)

---

## 1. Core Concepts

- **Application**: A **logical collection of Elastic Beanstalk components** (e.g., "MyECommerceApp").
- **Application Version**: A **specific**, **labeled iteration of deployable code** (e.g., "v1.0", "v1.1").
- **Environment**: A **collection of AWS resources running an application version** (e.g., "Production", "Staging").
- **Platform**: The **language stack** (e.g., Python 3.8 running on Amazon Linux 2).
  - **Go**
  - **Java SE** & **Java with Tomcat**
  - **.NET** on Windows Server with IIS
  - **Node.js**
  - **PHP**
  - **Python**
  - **Ruby**
  - **Packer Builder**
  - **Docker** (See details below)

### Docker on Elastic Beanstalk

Elastic Beanstalk provides specific support for Docker workloads:

1. **Single Container Docker**:
   - Runs **one** container per EC2 instance.
   - You provide a `Dockerfile` (Beanstalk builds it) or a `Dockerrun.aws.json` (pointing to an image in ECR/DockerHub).
   - _Use Case_: Simple microservices or monolithic apps containerized for portability.
2. **Multi-Container Docker**:
   - Runs **multiple** containers per EC2 instance.
   - Uses **Amazon ECS** (Elastic Container Service) under the hood to coordinate containers.
   - Defined by `Dockerrun.aws.json` (v2), similar to `docker-compose`.
   - _Use Case_: Application + Nginx Proxy + Log collector sidecar on the same host.
3. **Preconfigured Docker** (GlassFish, Go, Python, etc.):
   - AWS provides managed Docker images for specific languages.
   - You just upload your **source code** (e.g., `.war` file for Java), and Beanstalk runs it inside the pre-made container.
   - _Use Case_: You want the benefits of Docker isolation but don't want to write a Dockerfile.

### How it works

Under the hood, Elastic Beanstalk uses **CloudFormation** to provision:

- **EC2 Instances** (in an ASG)
- **Load Balancer** (ALB/CLB)
- **Security Groups**
- **RDS** (Optional, but usually better to manage separately)

---

## 2. Environment Types

| Type                       | Description                                                                      | Use Case                         |
| :------------------------- | :------------------------------------------------------------------------------- | :------------------------------- |
| **Web Server Environment** | Handles HTTP requests from the Internet. Uses an**ALB** and **Public IP**.       | Standard Websites, APIs.         |
| **Worker Environment**     | Processes background tasks (SQS messages). No Load Balancer, no Internet access. | Video processing, Email sending. |

---

---

## 3. Architecture Models

Elastic Beanstalk offers distinct architecture models based on operational needs:

### 1. Single Instance Deployment

- **Good for**: Development, Test environments.
- **Architecture**: One EC2 instance + Elastic IP. No Load Balancer.
- **Cost**: Lowest (saves money on ALB).
- **Scalability**: None (Vertical scaling only).

### 2. LB + ASG (High Availability)

- **Good for**: **Production**, Pre-Production Web Applications.
- **Architecture**: Application Load Balancer (ALB) + Auto Scaling Group (ASG).
- **Scalability**: Automatic Horizontal Scaling (add/remove instances based on CPU).
- **Availability**: High (Multi-AZ).

### 3. ASG Only (Worker Tier)

- **Good for**: Non-Web Apps (Background Workers, Cron Jobs).
- **Architecture**: Auto Scaling Group (ASG) listening to an **SQS Queue**. No Load Balancer.
- **Workflow**: Web Tier pushes generic tasks to SQS -> Worker Tier pulls tasks and processes them.

---

## 4. Deployment Policies (Critical)

How do you update your application with zero downtime? Used for **Web Server** environments.

| Policy                            | Downtime? | Cost Penalty? | Rollback Speed | Description                                                                                               |
| :-------------------------------- | :-------- | :------------ | :------------- | :-------------------------------------------------------------------------------------------------------- |
| **All at Once**                   | **YES**   | None          | Fast           | Deploys to ALL instances simultaneously. The app is down during restart. Fastest but risky.               |
| **Rolling**                       | No        | None          | Slow           | Updates a few instances at a time (e.g., bucket size 20%). Capacity is reduced during deploy.             |
| **Rolling with Additional Batch** | No        | **Low**       | Slow           | Launches new instances to handle load, then updates. Capacity is maintained (High Availability).          |
| **Immutable**                     | No        | **High**      | **Fastest**    | Launches a full**NEW ASG** with new instances. Deeply tests new version before switching traffic. Safest. |
| **Traffic Splitting**             | No        | High          | Fast           | Canary testing. Sends X% (e.g., 10%) of traffic to new version for Y minutes.                             |

---

## 5. Configuration (.ebextensions)

To configure the environment (e.g., install a yum package, run a script, set environment variables), you use **.config** files in the `.ebextensions/` folder.

```yaml
# .ebextensions/01_setup.config
packages:
  yum:
    python3-devel: []

commands:
  01_install_requirements:
    command: "pip install -r requirements.txt"
```

---

## 6. Exam Cheat Sheet

- **Deployment**: "Need to deploy with no downtime and quick rollback" -> **Immutable**.
- **Deployment**: "Need zero downtime but cheapest option" -> **Rolling**.
- **Database**: "Decouple RDS from Beanstalk to prevent accidental deletion" -> Create RDS **externally** and pass connection string as Env Vars.
- **Worker**: "Offload long-running tasks from web tier" -> Use a **Worker Environment** with **SQS**.
- **Customization**: "Need to install system dependencies" -> use **.ebextensions**.
