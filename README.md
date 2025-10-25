# 🚀 AWS Learning Guide

A comprehensive, hands-on guide to Amazon Web Services (AWS) fundamentals covering core services, security, and best practices. This repository contains detailed documentation, practical examples, and real-world scenarios to help you master AWS from beginner to intermediate level.

## 📚 Table of Contents

### 🔐 Core Services
- **[01. IAM - Identity & Access Management](01_iam.md)**
  - User management, roles, policies, and permissions
  - Multi-factor authentication (MFA) setup
  - Best practices for secure access control

- **[02. S3 - Simple Storage Service](02_s3.md)**
  - Bucket creation, object storage, and lifecycle policies
  - Static website hosting and CDN integration
  - Security configurations and access controls

- **[03. EC2 - Elastic Compute Cloud](03_ec2.md)**
  - Virtual server deployment and management
  - SSH access, key pairs, and remote connections
  - Instance lifecycle and cost optimization

### ⚙️ EC2 Deep Dive
- **[04. Instance Types](04_instance_types.md)**
  - Choosing the right instance for your workload
  - Performance characteristics and use cases
  - Cost comparison and optimization strategies

- **[05. Security Groups](05_security_groups.md)**
  - Network-level security and firewall rules
  - Inbound/outbound traffic configuration
  - Common security patterns and troubleshooting

- **[06. Ports Configuration](06_ports.md)**
  - Essential port configurations for web services
  - SSH, HTTP, HTTPS, and custom application ports
  - Security considerations and best practices

### 💾 Storage & Images
- **[07. EBS - Elastic Block Store](07_ebs.md)**
  - Persistent storage for EC2 instances
  - Volume types, performance, and encryption
  - Backup and disaster recovery strategies

- **[08. Versioning & Snapshots](08_versioning_snapshot.md)**
  - Data protection through versioning
  - Automated backup strategies
  - Point-in-time recovery procedures

- **[09. AMI - Amazon Machine Images](09_ami.md)**
  - Creating custom server images
  - Image sharing and marketplace usage
  - Version control for infrastructure

### 🔧 Operations
- **[10. Cleanup Scripts](10_cleanup_script.md)**
  - Automated resource cleanup procedures
  - Security hardening before AMI creation
  - Cost optimization through proper resource management

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

**🎉 Ready to start your AWS journey? Begin with [01. IAM - Identity & Access Management](01_iam.md)!**

*Last updated: October 2025 | AWS Free Tier compatible*