# 🌐 Practical 2: Create & Configure VPC with Public and Private Subnets

## 🎯 Objective
Create a VPC with public and private subnets, configure routing, and test connectivity between instances.

## 📋 Prerequisites
- AWS account with appropriate permissions
- Basic understanding of networking concepts
- SSH key pair for EC2 access

---

## 🏗️ Step A: AWS VPC Setup (Simplified)

### 1. Launch VPC Wizard

1. **Navigate to VPC Console**
   - Open AWS Console → VPC → VPC Dashboard
   - Click **Launch VPC Wizard**

2. **Choose Configuration**
   - Select: **VPC with Public and Private Subnets**
   - This creates a complete networking setup automatically

### 2. Configure IP Addresses

```
Network Architecture:
├── VPC CIDR: 10.0.0.0/16 (65,536 addresses)
├── Public Subnet: 10.0.1.0/24 (256 addresses)
└── Private Subnet: 10.0.2.0/24 (256 addresses)
```

**CIDR Explanation:**
- `/16` gives ~65,536 addresses for the entire VPC
- `/24` gives 256 addresses for each subnet
- First 4 and last 1 IP addresses are reserved by AWS

### 3. Internet Gateway (IGW)

**Automatic Configuration:**
- Automatically attached by wizard to public subnet
- **Purpose:** Allows internet traffic to reach your public subnet EC2 instances
- **Route:** Public subnet route table points `0.0.0.0/0` to IGW

### 4. NAT Gateway

**Configuration:**
- Create NAT Gateway in public subnet
- **Purpose:** Private subnet EC2 can access internet (updates, downloads) without being directly accessible
- **Route:** Private subnet route table points `0.0.0.0/0` to NAT Gateway

---

## 🖥️ Step B: Launch EC2 Instances

### Public EC2 Instance

1. **Launch Configuration**
   - Navigate to EC2 → Launch Instance
   - Choose Amazon Linux 2 AMI
   - Instance type: `t2.micro` (free tier)

2. **Network Settings**
   - VPC: Select your created VPC
   - Subnet: **Public Subnet** (`10.0.1.0/24`)
   - Auto-assign Public IP: **Enable**
   - Security Group: Allow SSH (port 22) from your IP

3. **Key Pair**
   - Select existing key pair or create new one
   - Download `.pem` file if creating new

### Private EC2 Instance

1. **Launch Configuration**
   - Same AMI and instance type as public instance

2. **Network Settings**
   - VPC: Select your created VPC
   - Subnet: **Private Subnet** (`10.0.2.0/24`)
   - Auto-assign Public IP: **Disable**
   - Security Group: Allow SSH (port 22) from public subnet CIDR (`10.0.1.0/24`)

---

## 🧪 Step C: Test Connectivity

### 1. Connect to Public EC2

```bash
# From your local machine
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<public-ec2-public-ip>
```

### 2. Connect to Private EC2 (via Public EC2)

```bash
# From public EC2 instance
ssh ec2-user@<private-ec2-private-ip>
```

**Note:** You'll need to copy your private key to the public instance or use SSH agent forwarding.

### 3. Test Internet Access from Private EC2

```bash
# From private EC2 instance
curl http://ifconfig.me
# Should return the NAT Gateway's public IP

# Test package updates
sudo yum update -y
# Should work via NAT Gateway
```

---

## ✅ Step D: Verification Checklist

### Route Tables Verification

1. **Public Subnet Route Table**
   ```
   Destination    Target
   10.0.0.0/16   Local
   0.0.0.0/0     IGW (igw-xxxxxxxx)
   ```

2. **Private Subnet Route Table**
   ```
   Destination    Target
   10.0.0.0/16   Local
   0.0.0.0/0     NAT Gateway (nat-xxxxxxxx)
   ```

### Connectivity Tests

- ✅ Public EC2 reachable from your laptop via SSH
- ✅ Private EC2 reachable from public EC2 via SSH
- ✅ Private EC2 can access internet through NAT Gateway
- ✅ Private EC2 cannot be reached directly from internet

---

## 🔧 Troubleshooting Guide

### Common Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| Can't SSH to public EC2 | Connection timeout | Check security group allows SSH from your IP |
| Can't SSH to private EC2 | Connection refused | Verify security group allows SSH from public subnet |
| Private EC2 no internet | curl fails | Check NAT Gateway status and route table |
| Wrong subnet assignment | Instance in wrong network | Verify subnet selection during launch |

### Security Group Rules

**Public EC2 Security Group:**
```
Inbound Rules:
- SSH (22) from Your-IP/32
- HTTP (80) from 0.0.0.0/0 (if web server)
- HTTPS (443) from 0.0.0.0/0 (if web server)

Outbound Rules:
- All traffic to 0.0.0.0/0
```

**Private EC2 Security Group:**
```
Inbound Rules:
- SSH (22) from 10.0.1.0/24 (public subnet)
- Application ports from 10.0.1.0/24 (as needed)

Outbound Rules:
- All traffic to 0.0.0.0/0
```

---

## 📊 Architecture Diagram

```
Internet
    |
    ▼
┌─────────────────────────────────────────┐
│              VPC (10.0.0.0/16)          │
│                                         │
│  ┌─────────────────┐ ┌─────────────────┐│
│  │ Public Subnet   │ │ Private Subnet  ││
│  │ (10.0.1.0/24)   │ │ (10.0.2.0/24)   ││
│  │                 │ │                 ││
│  │ ┌─────────────┐ │ │ ┌─────────────┐ ││
│  │ │ Public EC2  │ │ │ │ Private EC2 │ ││
│  │ │ (Web Server)│ │ │ │ (Database)  │ ││
│  │ └─────────────┘ │ │ └─────────────┘ ││
│  │                 │ │                 ││
│  │ ┌─────────────┐ │ │                 ││
│  │ │ NAT Gateway │ │ │                 ││
│  │ └─────────────┘ │ │                 ││
│  └─────────────────┘ └─────────────────┘│
│           │                             │
│           ▼                             │
│  ┌─────────────────┐                    │
│  │ Internet Gateway│                    │
│  └─────────────────┘                    │
└─────────────────────────────────────────┘
```

---

## 🎓 Key Learning Points

1. **Network Segmentation**
   - Public subnets for internet-facing resources
   - Private subnets for internal resources

2. **Routing Concepts**
   - Route tables control traffic flow
   - Internet Gateway enables internet access
   - NAT Gateway provides outbound internet for private resources

3. **Security Best Practices**
   - Principle of least privilege in security groups
   - Bastion host pattern for private resource access
   - Network ACLs for additional subnet-level security

---

## 📚 Additional Resources

- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/)
- [VPC Security Best Practices](https://aws.amazon.com/vpc/security/)
- [NAT Gateway Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)