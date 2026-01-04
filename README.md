# 🚀 AWS Learning Guide

A comprehensive, hands-on guide to Amazon Web Services (AWS) fundamentals covering core services, security, and best practices. This repository contains detailed documentation, practical examples, and real-world scenarios to help you master AWS from beginner to intermediate level.

## 📚 Table of Contents

### 🔐 Core Services

- **[01. IAM - Identity &amp; Access Management](01_iam.md)**

  - **Definition**: AWS Identity and Access Management (IAM) securely manages access to AWS services and resources.
  - **Use Case**: Creating users and roles to control who can access your S3 buckets or EC2 instances.

  - User management, roles, policies, and permissions
  - Multi-factor authentication (MFA) setup
  - Best practices for secure access control

- **[02. S3 - Simple Storage Service](02_s3.md)**

  - **Definition**: An object storage service that offers industry-leading scalability, data availability, security, and performance.
  - **Use Case**: Storing backups, static websites, and data archives.

  - Bucket creation, object storage, and lifecycle policies
  - Static website hosting and CDN integration
  - Security configurations and access controls

- **[03. EC2 - Elastic Compute Cloud](03_ec2.md)**

  - **Definition**: A web service that provides secure, resizable compute capacity in the cloud.
  - **Use Case**: Hosting web applications, databases, and backend servers.

  - Virtual server deployment and management
  - SSH access, key pairs, and remote connections
  - Instance lifecycle and cost optimization

### ⚙️ EC2 Deep Dive

- **[04. Instance Types](04_instance_types.md)**

  - **Definition**: Varying combinations of CPU, memory, storage, and networking capacity for EC2 instances.
  - **Use Case**: Selecting CPU-optimized for compute jobs or Memory-optimized for caches.

  - Choosing the right instance for your workload
  - Performance characteristics and use cases
  - Cost comparison and optimization strategies

- **[05. Security Groups](05_security_groups.md)**

  - **Definition**: A virtual firewall for your EC2 instances to control incoming and outgoing traffic.
  - **Use Case**: Allowing SSH access only from your specific IP address.

  - Network-level security and firewall rules
  - Inbound/outbound traffic configuration
  - Common security patterns and troubleshooting

- **[06. Ports Configuration](06_ports.md)**

  - **Definition**: Identifying specific process endpoints on a network.
  - **Use Case**: Opening port 80 for HTTP traffic and 443 for HTTPS.

  - Essential port configurations for web services
  - SSH, HTTP, HTTPS, and custom application ports
  - Security considerations and best practices

### 💾 Storage & Images

- **[07. EBS - Elastic Block Store](07_ebs.md)**

  - **Definition**: High-performance block storage service designed for use with Amazon EC2.
  - **Use Case**: Primary storage for databases or file systems on EC2.

  - Persistent storage for EC2 instances
  - Volume types, performance, and encryption
  - Backup and disaster recovery strategies

- **[08. Versioning &amp; Snapshots](08_versioning_snapshot.md)**

  - **Definition**: Tools for data backup and recovery in S3 and EBS.
  - **Use Case**: Recovering accidentally deleted files or rolling back database state.

  - Data protection through versioning
  - Automated backup strategies
  - Point-in-time recovery procedures

- **[09. AMI - Amazon Machine Images](09_ami.md)**

  - **Definition**: A supported and maintained image provided by AWS that provides the information required to launch an instance.
  - **Use Case**: Launching multiple identical instances for horizontal scaling.

  - Creating custom server images
  - Image sharing and marketplace usage
  - Version control for infrastructure

### 🔧 Operations

- **[10. Cleanup Scripts](10_cleanup_script.md)**
  - **Definition**: Automation to remove unused resources.
  - **Use Case**: Removing dev resources at night to save cost and prevent lingering charges.
  - Automated resource cleanup procedures
  - Security hardening before AMI creation
  - Cost optimization through proper resource management

### 🗄️ Database Services

- **[20. All-in-One Database Guide](20_databases.md)**

  - **Definition**: A comprehensive overview of AWS database services.
  - **Use Case**: Choosing the right database engine (SQL vs NoSQL) for your specific workload.

  - Deep dive into RDS, Aurora, DynamoDB, ElastiCache, and Redshift
  - Comparison of SQL vs NoSQL services
  - Design patterns for performance and high availability

- **[21. Amazon Aurora Deep Dive](21_aurora.md)**

  - **Definition**: A customized, high-performance relational database built for the cloud (MySQL/PostgreSQL compatible).
  - **Use Case**: High-performance enterprise applications requiring auto-scaling storage and rapid failover.

  - Architecture: Storage vs Compute decoupling
  - Serverless, Global Database, and Cloning features
  - Exam tips for high-availability scenarios

- **[22. RDS Deployments &amp; Workflows](22_rds_deployments.md)**

  - **Definition**: Deployment strategies for Relational Database Service (RDS).
  - **Use Case**: Setting up Multi-AZ for high availability or Read Replicas for performance scaling.

  - Visual diagrams for Multi-AZ, Read Replicas, and Multi-Region
  - Understanding replication logic (Sync vs Async)
  - Deployment strategies for specific use cases

- **[23. Amazon ElastiCache Deep Dive](23_elasticache.md)**

  - **Definition**: Fully managed in-memory caching service supporting Redis and Memcached.
  - **Use Case**: Speeding up dynamic websites by caching user sessions and query results.

  - Redis vs Memcached comparison table
  - Caching strategies: Lazy Loading vs Write-Through
  - Architecture patterns for session management

- **[24. Amazon DynamoDB Deep Dive](24_dynamodb.md)**

  - **Definition**: Fast, flexible NoSQL database service for single-digit millisecond performance at any scale.
  - **Use Case**: Serverless applications, shopping carts, gaming leaderboards, and mobile backends.

  - Data Types (Scalar, Document, Set)
  - DAX for Microsecond latency
  - Global Tables for Multi-Region Active-Active architecture

- **[25. Amazon Redshift Deep Dive](25_redshift.md)**

  - **Definition**: Petabyte-scale data warehouse service.
  - **Use Case**: Running complex analytic queries against massive datasets (Business Intelligence).

  - Leader vs Compute Node Architecture
  - OLAP vs OLTP differences
  - Redshift Spectrum for S3 querying

- **[26. Amazon EMR (Elastic MapReduce)](26_emr.md)**

  - **Definition**: Cloud big data platform for running large-scale distributed data processing jobs.
  - **Use Case**: Running Apache Spark, Hive, or Presto jobs for log analysis and machine learning.

  - Architecture: Master, Core, and Task Nodes
  - Storage: HDFS vs EMRFS (S3)
  - Use cases: Hadoop, Spark, Big Data Processing

- **[27. Amazon Athena Deep Dive](27_athena.md)**

  - **Definition**: Interactive query service that makes it easy to analyze data in S3 using standard SQL.
  - **Use Case**: Ad-hoc querying of CSV/JSON logs stored in S3 without managing servers.

  - Serverless SQL querying on S3
  - Cost/Performance optimization (Parquet/ORC)
  - Federated Query overview

- **[28. Amazon QuickSight Deep Dive](28_quicksight.md)**

  - **Definition**: Scalable, serverless, embeddable, machine learning-powered business intelligence (BI) service.
  - **Use Case**: Creating and publishing interactive dashboards to visualize sales data.

  - SPICE In-memory Engine
  - Machine Learning Insights (Anomaly Detection)
  - Row-Level Security (RLS)

- **[29. Amazon Neptune Deep Dive](29_neptune.md)**

  - **Definition**: Fast, reliable, fully managed graph database service.
  - **Use Case**: Social networking feeds, recommendation engines, and fraud detection.

  - Graph Database fundamentals (Nodes, Edges)
  - Gremlin vs SPARQL Query Languages
  - Use cases: Social Networks, Fraud Detection

- **[30. Amazon Timestream Deep Dive](30_timestream.md)**

  - **Definition**: Fast, scalable, and serverless time series database service.
  - **Use Case**: Storing IoT sensor readings, DevOps metrics, and industrial telemetry.

  - Time Series Database architecture
  - Storage Tiering: Memory Store vs Magnetic Store
  - Use cases: IoT and DevOps monitoring

- **[31. Amazon QLDB Deep Dive](31_qldb.md)**

  - **Definition**: Fully managed ledger database that provides a transparent, immutable, and cryptographically verifiable transaction log.
  - **Use Case**: Tracking supply chain history, banking transactions, or vehicle records immutably.

  - Immutable Transaction Log (The Journal)
  - Cryptographically Verifiable
  - QLDB vs Managed Blockchain comparison

- **[32. Amazon Managed Blockchain Deep Dive](32_managed_blockchain.md)**

  - **Definition**: Fully managed service that makes it easy to create and manage scalable blockchain networks.
  - **Use Case**: Decentralized finance (DeFi) apps or supply chain transparency using Hyperledger Fabric or Ethereum.

  - Hyperledger Fabric vs Ethereum
  - Decentralized Trust & Consensus
  - Architecture: Members, Peers, and Ordering Service

- **[33. AWS Glue Deep Dive](33_glue.md)**

  - **Definition**: Serverless data integration service (ETL - Extract, Transform, Load).
  - **Use Case**: Preparing, cleaning, and transforming data for analytics and machine learning.

  - Serverless ETL (Extract, Transform, Load)
  - Data Catalog & Crawlers (Schema Discovery)
  - Workflow: Source -> Crawler -> Catalog -> Job -> Target

- **[34. AWS DMS Deep Dive](34_dms.md)**
  - **Definition**: Database Migration Service to migrate databases to AWS securely.
  - **Use Case**: Moving an on-premise Oracle database to Amazon Aurora with minimal downtime.
  - Homogenous vs Heterogenous Migrations
  - Schema Conversion Tool (SCT) necessity
  - Continuous Replication (CDC)

### 📦 Container Services

- **[35. Docker Fundamentals for AWS](35_docker.md)**

  - **Definition**: A platform for developing, shipping, and running applications in containers.
  - **Use Case**: Packaging applications and their dependencies to run consistently on any environment.

  - Virtual Machines vs Containers
  - Dockerfile, Image, and Container concepts
  - Amazon ECR (Elastic Container Registry) basics

- **[36. Amazon ECS Deep Dive](36_ecs.md)**

  - **Definition**: A fully managed container orchestration service.
  - **Use Case**: Running and scaling Docker containers for microservices.

  - Fargate vs EC2 Launch Types
  - Clusters, Services, and Task Definitions
  - Auto Scaling and Load Balancer integration

- **[37. AWS Fargate Deep Dive](37_fargate.md)**

  - **Definition**: A serverless compute engine for containers that works with ECS and EKS.
  - **Use Case**: Running containers without having to manage servers or clusters.

  - Serverless Compute for Containers
  - Task Isolation and Security (VM-level)
  - Fargate vs EC2 Launch Type pricing

- **[38. Amazon ECR Deep Dive](38_ecr.md)**

  - **Definition**: A fully managed Docker container registry.
  - **Use Case**: Storing, sharing, and deploying container images securely.

  - Public vs Private Repositories
  - Security Scanning (Basic vs Enhanced)
  - Lifecycle Policies (Cost Optimization)

- **[39. Amazon EKS Deep Dive](39_eks.md)**
  - **Definition**: a managed service to run Kubernetes on AWS.
  - **Use Case**: Running complex, scalable microservices architectures using standard Kubernetes.
  - Managed Kubernetes Service
  - Control Plane vs Data Plane (Nodes)
  - EKS Distro & EKS Anywhere

### Serverless Services

- **[40. AWS Lambda Deep Dive](40_lambda.md)**

  - **Definition**: A serverless compute service that lets you run code without provisioning or managing servers.
  - **Use Case**: Running code in response to events (e.g., file uploads) or building serverless backends.

  - Serverless Compute Basics
  - Triggers (API Gateway, S3, DynamoDB)
  - Execution Limits and Pricing

- **[41. AWS API Gateway Deep Dive](41_api_gateway.md)**

  - **Definition**: A fully managed service for creating, publishing, maintaining, monitoring, and securing APIs.
  - **Use Case**: Creating a REST API frontend for Lambda functions or other AWS services.

  - REST vs HTTP vs WebSocket APIs
  - Endpoint Types (Edge, Regional, Private)
  - Security (Cognito, IAM, Lambda Authorizer)

- **[42. AWS Batch Deep Dive](42_batch.md)**

  - **Definition**: Fully managed batch processing service.
  - **Use Case**: Running hundreds of thousands of computing jobs like financial risk analysis or media transcoding.

  - Batch Computing (Jobs, Queues, Environments)
  - Orchestrating Spot Instances
  - Batch vs Lambda for long-running jobs

- **[43. Amazon Lightsail Deep Dive](43_lightsail.md)**

  - **Definition**: An easy-to-use cloud platform that offers everything needed to build an application or website.
  - **Use Case**: Quickly launching a WordPress blog or a simple development environment.

  - Virtual Private Server (VPS) made easy
  - Fixed Monthly Pricing vs EC2
  - One-Click Apps (WordPress, LAMP)

- **[48. AWS Elastic Beanstalk Deep Dive](48_elastic_beanstalk.md)**

  - **Definition**: An easy-to-use service for deploying and scaling web applications and services.
  - **Use Case**: Deploying a Python web app without configuring the underlying OS or web server manually.

  - Platform as a Service (PaaS)
  - Deployment Policies (Rolling, Immutable)
  - Extensions (`.ebextensions`) and Configuration

  - One-Click Apps (WordPress, LAMP)

### Management & Developer Tools

- **[44. AWS CloudFormation Deep Dive](44_cloudformation.md)**

  - **Definition**: A service that gives developers and systems administrators an easy way to create and manage a collection of related AWS resources.
  - **Use Case**: Defining infrastructure as code (templates) to standardizing environments.

  - Infrastructure as Code (IaC)
  - Stacks, Change Sets, and Intrinsic Functions
  - Drift Detection (Syncing Manual Changes)

- **[45. AWS CDK Deep Dive](45_cdk.md)**

  - **Definition**: An open-source software development framework to define your cloud application resources using familiar programming languages.
  - **Use Case**: Defining infrastructure using Python/TypeScript logic constructs instead of YAML/JSON.

  - Cloud Development Kit (TypeScript/Python)
  - Constructs (L1, L2, L3 Patterns)
  - Workflow: Code -> `cdk synth` -> CloudFormation

- **[49. AWS CodeDeploy Deep Dive](49_codedeploy.md)**

  - **Definition**: A fully managed deployment service that automates software deployments to a variety of compute services.
  - **Use Case**: Automating code rollouts to EC2 instances or Lambda functions to minimize downtime.

  - Deployment Types (In-Place vs Blue/Green)
  - Application Lifecycle Hooks (`appspec.yml`)
  - Troubleshooting Deployments

- **[50. AWS CodeCommit Deep Dive](50_codecommit.md)**

  - **Definition**: A fully managed source control service that hosts secure Git-based repositories.
  - **Use Case**: Hosting private source code in a scalable, secure, and managed environment.

  - Private Git Repositories
  - Authentication (HTTPS Git Credentials vs SSH)
  - Cross-Account Access with IAM Roles

- **[51. AWS CodeBuild Deep Dive](51_codebuild.md)**

  - **Definition**: A fully managed continuous integration service that compiles source code, runs tests, and produces software packages.
  - **Use Case**: Running unit tests and building Docker images automatically on commit.

  - Fully Managed Build Service (CI)
  - `buildspec.yml` Configuration
  - Artifacts & Caching (S3/Local)

- **[52. AWS CodePipeline Deep Dive](52_codepipeline.md)**

  - **Definition**: A fully managed continuous delivery service that helps you automate your release pipelines.
  - **Use Case**: Orchestrating the workflow from source change -> build -> test -> deploy to production.

  - CI/CD Orchestration (Source -> Build -> Deploy)
  - Artifact Transmission via S3
  - Manual Approvals

- **[53. AWS CodeArtifact Deep Dive](53_codeartifact.md)**

  - **Definition**: A fully managed artifact repository service.
  - **Use Case**: Securely storing, publishing, and sharing software packages (npm, pip, maven) used in your software development process.

  - Managed Artifactory (npm, pip, maven)
  - Domains vs Repositories (De-duplication)
  - Upstream Caching (Proxy for public repos)

- **[54. AWS Systems Manager (SSM) Deep Dive](54_ssm.md)**
  - **Definition**: A secure, end-to-end management solution for your hybrid cloud environment.
  - **Use Case**: Patching fleets of instances, managing secrets, or connecting to instances without SSH keys.
  - SSM Session Manager (No Ports/SSH)
  - Parameter Store (Secrets/Config)
  - Run Command & Patch Manager

### 🔗 Cloud Integration

- **[63. Cloud Integration & Decoupling](63_cloud_integration.md)**
  - **Definition**: Patterns and services to decouple application components for scalability and reliability.
  - **Use Case**: Using queues (SQS) or pub/sub (SNS) to handle traffic spikes without crashing services.

### Global Infrastructure & Networking

- **[62. AWS Local Zones Deep Dive](62_local_zones.md)**

  - **Definition**: An infrastructure deployment that places compute and storage closer to large population and industry centers.
  - **Use Case**: Running latency-sensitive applications like video rendering or gaming in a specific city.

- **[61. AWS Wavelength Deep Dive](61_wavelength.md)**

  - **Definition**: An infrastructure offering optimized for mobile edge computing applications.
  - **Use Case**: Deploying ultra-low latency applications to 5G devices (e.g., AR/VR).

- **[60. AWS Outposts Deep Dive](60_outposts.md)**

  - **Definition**: A fully managed service that offers the same AWS infrastructure, AWS services, APIs, and tools to virtually any datacenter.
  - **Use Case**: Running applications that need low latency to on-premises systems or local data processing.

  - Hybrid Cloud (On-Premises Extension)
  - Racks vs Servers
  - Local Gateway & Connectivity

- **[59. AWS Global Accelerator Deep Dive](59_global_accelerator.md)**

  - **Definition**: A networking service that improves the performance of your users' traffic by up to 60% using the AWS global network.
  - **Use Case**: Improving global application availability and performance for UDP/TCP traffic (e.g., gaming).

  - Unicast vs Anycast IP
  - Traffic Dials & Endpoint Weighting
  - Client IP Preservation

- **[58. Amazon CloudFront Deep Dive](58_cloudfront.md)**

  - **Definition**: A fast content delivery network (CDN) service that securely delivers data, videos, applications, and APIs.
  - **Use Case**: Accelerating delivery of static website content (images, CSS, JS) to users globally.

  - Caching Strategies (TTL, Invalidations)
  - Security (OAI/OAC, Signed URLs)
  - CloudFront Functions vs Lambda@Edge

- **[57. Amazon Route 53 Deep Dive](57_route53.md)**

  - **Definition**: A highly available and scalable cloud Domain Name System (DNS) web service.
  - **Use Case**: Routing end users to your site reliably and performing health checks on your resources.

  - Routing Policies (Weighted, Latency, Failover)
  - Hosted Zones (Public vs Private)
  - Alias vs CNAME Records

- **[56. AWS Global Infrastructure Deep Dive](56_global_infrastructure.md)**

  - **Definition**: The physical locations (Regions, AZs, Edge Locations) where AWS data centers are clustered.
  - **Use Case**: Designing highly available, fault-tolerant, and compliant global architectures.

  - Regions vs Availability Zones (AZs)
  - Edge Locations & Points of Presence
  - Local Zones, Wavelength, and Outposts

- **[55. AWS Global Application Architecture](55_global_application.md)**
  - **Definition**: Architecture patterns for building multi-region, resilient applications.
  - **Use Case**: Designing standard Active-Passive or Active-Active disaster recovery strategies.
  - Route 53 (DNS Routing Policies)
  - CloudFront vs Global Accelerator
  - S3 Cross-Region Replication

### Architecture Patterns

- **[46. AWS 3-Tier Web Architecture](46_architecture_3tier.md)**
  - **Definition**: A modular client-server architecture that consists of a presentation tier, an application tier, and a data tier.
  - **Use Case**: Standard, secure pattern for hosting scalable web applications on AWS.
  - Web, App, and Data Layers
  - Security Groups Chaining
  - High Availability with Multi-AZ

### Developer Guides

- **[47. Common Developer Problems (Troubleshooting)](47_developer_problems.md)**
  - **Definition**: A guide to diagnosing and fixing common errors encountered during AWS development.
  - **Use Case**: Troubleshooting "Connection Refused" on EC2 or "403 Access Denied" on S3.
  - EC2 Connection Issues (SSH/HTTP)
  - S3 403 Errors & Lambda Timeouts
  - CloudFormation Rollbacks, CodeDeploy Hooks, & 502/504 Errors
  - Database Connections & ASG Thrashing

## 🎯 Structured Learning Path

### Phase 1: Foundation (Week 1-2)

1. **🔐 IAM Fundamentals**

   - Create your first IAM user
   - Set up MFA for enhanced security
   - Understand the principle of least privilege

2. **💾 S3 Basics**

   - Create and configure your first bucket
   - Upload files and set permissions
   - Enable versioning and lifecycle policies

### Phase 2: Compute Services (Week 3-4)

3. **⚙️ EC2 Essentials**

   - Launch your first EC2 instance
   - Connect via SSH and configure basic services
   - Understand instance states and billing

4. **🛡️ Security Configuration**

   - Configure security groups and NACLs
   - Set up proper port access
   - Implement security best practices

### Phase 3: Advanced Storage (Week 5-6)

5. **💿 EBS and Storage**

   - Attach additional storage to instances
   - Create and restore from snapshots
   - Implement backup strategies

6. **📸 AMI Management**

   - Create custom AMIs from configured instances
   - Share AMIs across accounts
   - Version control your infrastructure

### Phase 4: Operations (Week 7-8)

7. **🔧 Automation and Cleanup**
   - Implement automated cleanup procedures
   - Create deployment scripts
   - Monitor and optimize costs

## 🛠️ Prerequisites & Setup

### Required Knowledge

- **Basic Linux/Unix commands** (ls, cd, chmod, ssh)
- **Networking fundamentals** (IP addresses, ports, protocols)
- **Basic understanding of virtualization** concepts
- **Command line comfort** (Terminal/PowerShell)

### Required Accounts & Tools

- **AWS Free Tier Account** - [Sign up here](https://aws.amazon.com/free/)
- **AWS CLI** - [Installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- **SSH Client** (PuTTY for Windows, built-in for Mac/Linux)
- **Text Editor** (VS Code, Sublime, or similar)

### Initial Setup Checklist

- [ ] Create AWS account and verify email
- [ ] Set up billing alerts (recommended: $10 threshold)
- [ ] Install AWS CLI and configure credentials
- [ ] Create your first IAM user (don't use root account)
- [ ] Enable MFA on root and IAM accounts

## 📖 How to Use This Guide

### Document Structure

Each guide follows a consistent format:

- **🎯 Purpose** - Clear objectives and use cases
- **🧠 Key Concepts** - Essential terminology and theory
- **🛠️ Hands-on Labs** - Step-by-step practical exercises
- **⚠️ Common Pitfalls** - Mistakes to avoid
- **💡 Best Practices** - Industry-standard recommendations
- **🔍 Troubleshooting** - Common issues and solutions
- **📊 Cost Optimization** - Tips to minimize expenses

### Learning Approach

1. **Read the theory** - Understand concepts before implementation
2. **Follow labs step-by-step** - Hands-on practice is essential
3. **Experiment safely** - Use Free Tier resources for testing
4. **Document your progress** - Keep notes of configurations
5. **Clean up resources** - Avoid unexpected charges

## 🎓 Learning Objectives

By completing this guide, you will be able to:

### Security & Access Management

- ✅ Implement proper IAM policies and user management
- ✅ Configure multi-factor authentication
- ✅ Apply principle of least privilege
- ✅ Secure AWS resources using best practices

### Storage & Data Management

- ✅ Design and implement S3 storage solutions
- ✅ Configure EBS volumes for optimal performance
- ✅ Create and manage snapshots for backup/recovery
- ✅ Implement data lifecycle and retention policies

### Compute & Networking

- ✅ Deploy and manage EC2 instances effectively
- ✅ Configure security groups and network access
- ✅ Choose appropriate instance types for workloads
- ✅ Implement auto-scaling and load balancing concepts

### Operations & Automation

- ✅ Create and manage AMIs for consistent deployments
- ✅ Implement automated cleanup and maintenance scripts
- ✅ Monitor resource usage and optimize costs
- ✅ Troubleshoot common AWS issues

## 🧪 Hands-on Labs & Projects

### Beginner Projects

1. **Personal Website Hosting** - Deploy a static website using S3 and CloudFront
2. **Secure File Storage** - Create encrypted S3 buckets with proper access controls
3. **Web Server Setup** - Launch and configure a basic web server on EC2

### Intermediate Projects

4. **Multi-tier Application** - Deploy a web app with separate database server
5. **Backup Strategy Implementation** - Automated EBS snapshots and S3 lifecycle
6. **Custom AMI Pipeline** - Create standardized server images for deployment

### Advanced Challenges

7. **High Availability Setup** - Multi-AZ deployment with load balancing
8. **Disaster Recovery Plan** - Cross-region backup and recovery procedures
9. **Cost Optimization Audit** - Analyze and optimize existing AWS resources

## 🔗 Essential Resources

### Official AWS Documentation

- [AWS Free Tier](https://aws.amazon.com/free/) - Start with free resources
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) - Best practices
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/) - Command line tools
- [AWS Pricing Calculator](https://calculator.aws/) - Cost estimation

### Learning Resources

- [AWS Training and Certification](https://aws.amazon.com/training/) - Official courses
- [AWS Whitepapers](https://aws.amazon.com/whitepapers/) - In-depth technical guides
- [AWS Architecture Center](https://aws.amazon.com/architecture/) - Reference architectures
- [AWS Blog](https://aws.amazon.com/blogs/) - Latest updates and tutorials

### Community & Support

- [AWS Forums](https://forums.aws.amazon.com/) - Community discussions
- [AWS re:Post](https://repost.aws/) - Q&A platform
- [AWS Reddit Community](https://reddit.com/r/aws) - Informal discussions
- [Stack Overflow AWS Tag](https://stackoverflow.com/questions/tagged/amazon-web-services) - Technical questions

## ⚠️ Important Considerations

### Security Best Practices

- **Never share AWS credentials** in code or public repositories
- **Always use IAM users** instead of root account for daily operations
- **Enable MFA** on all accounts with console access
- **Regularly rotate access keys** and review permissions
- **Monitor billing** to detect unauthorized usage

### Cost Management

- **Set up billing alerts** before starting any labs
- **Use Free Tier resources** whenever possible
- **Clean up resources** immediately after completing exercises
- **Understand pricing models** before launching paid services
- **Monitor usage** through AWS Cost Explorer

### Free Tier Limits (12 months)

- **EC2**: 750 hours/month of t2.micro instances
- **S3**: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- **EBS**: 30GB of General Purpose SSD storage
- **Data Transfer**: 15GB outbound per month

## 🚨 Troubleshooting Guide

### Common Issues

**Connection Problems**

- SSH key permissions (chmod 400 keyfile.pem)
- Security group configuration
- Instance state verification

**Permission Errors**

- IAM policy attachments
- Resource-based policies
- Cross-account access issues

**Billing Surprises**

- Data transfer charges
- EBS snapshot storage
- Elastic IP addresses

### Getting Help

1. **Check AWS Service Health** - [status.aws.amazon.com](https://status.aws.amazon.com/)
2. **Review CloudTrail logs** - Audit API calls and changes
3. **Use AWS Support** - Basic support included with all accounts
4. **Community forums** - Often fastest for common issues

## 📊 Progress Tracking

### Completion Checklist

- [1] **IAM**: Created users, roles, and policies
- [2] **S3**: Configured buckets with proper security
- [3] **EC2**: Launched and managed instances
- [4] **Security Groups**: Configured network access
- [5] **EBS**: Attached storage and created snapshots
- [6] **AMI**: Created custom images
- [7] **Cleanup**: Implemented automation scripts
- [8] **Project**: Completed at least one end-to-end project

### Next Steps

After completing this guide, consider:

- **AWS Solutions Architect Associate** certification
- **Advanced services**: RDS, Lambda, CloudFormation
- **DevOps practices**: CI/CD with AWS CodePipeline
- **Monitoring**: CloudWatch and AWS X-Ray
- **Networking**: VPC, Route 53, and Load Balancers

---

## 📞 Support & Contributions

### Found an Issue?

- Create an issue in this repository
- Include detailed steps to reproduce
- Specify which guide section needs correction

### Want to Contribute?

- Fork this repository
- Add improvements or new content
- Submit a pull request with clear description

### Stay Updated

- ⭐ Star this repository for updates
- 👀 Watch for new content releases
- 🔄 Pull latest changes regularly

---

**🎉 Ready to start your AWS journey? Begin with [01. IAM - Identity &amp; Access Management](01_iam.md)!**

_Last updated: October 2025 | AWS Free Tier compatible_
