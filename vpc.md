# 🧩 AWS VPC (Virtual Private Cloud)

Amazon **Virtual Private Cloud (VPC)** allows you to **logically isolate a section of the AWS Cloud** where you can launch AWS resources (like EC2, RDS, ELB) in a **secure and controlled network environment**.

It’s your **own virtual data center** in AWS — fully customizable with subnets, IP ranges, route tables, firewalls, and gateways.

---

## 🧠 Overview

| Feature | Description |
|----------|--------------|
| **Service Type** | Networking & Security |
| **Scope** | Region-specific (each region can have multiple VPCs) |
| **Isolation** | Logical separation using private IP ranges (RFC 1918) |
| **Customization** | Define your own IP ranges, subnets, and routing |
| **Security** | Control inbound/outbound traffic with NACLs & Security Groups |

---

## 📦 Default vs Custom VPC

| Type | Description |
|------|--------------|
| **Default VPC** | Automatically created per region; comes with default subnets in each AZ, Internet access, route tables, and security groups. |
| **Custom VPC** | User-created; full control over subnets, routing, gateways, and access rules. Used in production environments. |

---

## 🧩 Core Components of a VPC

### 1️⃣ CIDR Block (Classless Inter-Domain Routing)
Defines the **IP address range** of your VPC.  
Example:  
- 10.0.0.0/16 → 65,536 IPs  
- Can be divided into smaller **subnets**.

### 2️⃣ Subnets
Subnets divide your VPC into **smaller network segments**.  
- **Public Subnet:** Connected to the Internet via an Internet Gateway (IGW).  
- **Private Subnet:** No direct Internet access; communicates internally or through NAT.  
- Each subnet is tied to **one Availability Zone**.

### 3️⃣ Route Tables
Define how network traffic is directed within the VPC.  
- Each subnet is associated with one route table.  
- Example routes:
  - `10.0.0.0/16 → local` (default internal communication)
  - `0.0.0.0/0 → igw-xxxxxxx` (Internet access)

### 4️⃣ Internet Gateway (IGW)
A horizontally scaled, redundant component that **enables Internet access** for instances in public subnets.

### 5️⃣ NAT Gateway / NAT Instance
Used by **private subnets** to access the Internet **without exposing** themselves publicly.

| Type | Description |
|------|--------------|
| **NAT Gateway** | Fully managed, scalable, high availability; preferred for production. |
| **NAT Instance** | EC2 instance configured for NAT; user-managed and less scalable. |

### 6️⃣ Security Groups (SG)
Act as **stateful firewalls** that control inbound/outbound traffic **at the instance level**.  
- Default: All outbound allowed; all inbound denied.  
- Example: Allow inbound SSH (22), HTTP (80), HTTPS (443).

### 7️⃣ Network Access Control Lists (NACLs)
Act as **stateless firewalls** at the **subnet level**.  
- Evaluated before Security Groups.  
- Each rule must be defined for both inbound and outbound traffic.

### 8️⃣ VPC Peering
Enables **communication between two VPCs** (same or different regions).  
- No transitive peering (A-B and B-C ≠ A-C).  
- Useful for multi-account or multi-region architectures.

### 9️⃣ VPC Endpoints
Allow **private connectivity to AWS services** (like S3, DynamoDB) **without using the public Internet**.

| Type | Description |
|------|--------------|
| **Interface Endpoint (ENI)** | Connects privately to services using PrivateLink. |
| **Gateway Endpoint** | Used for S3 and DynamoDB. |

### 🔟 DHCP Option Set, DNS, and Elastic IPs
- **DHCP Option Set:** Assign DNS servers, domain names.  
- **Elastic IPs:** Static public IPs for EC2 instances in public subnets.  
- **DNS Resolution:** Provided by Amazon DNS (Route 53 Resolver).

---

## ⚙️ VPC Architecture Diagram

```
                    [ Internet ]
                         |
                 +----------------+
                 | Internet Gateway|
                 +----------------+
                         |
           +-------------+-------------+
           |                           |
    [ Public Subnet ]           [ Private Subnet ]
     10.0.1.0/24                  10.0.2.0/24
           |                           |
     +------------+             +----------------+
     | EC2 (Web)  |             | EC2 (DB Server) |
     +------------+             +----------------+
           |                           |
  +-------------------+          +----------------+
  | Security Group    |          | Security Group |
  | (Allow 80,22,443) |          | (Allow MySQL)  |
  +-------------------+          +----------------+
           |                           |
     +------------+             +----------------+
     | Route Table|             | Route Table     |
     | -> IGW      |            | -> NAT Gateway  |
     +------------+             +----------------+
                         |
                  [ NAT Gateway ]
                         |
                 +----------------+
                 | Private Subnet  |
                 +----------------+
```


---

## 🧭 Example CIDR Allocation

| Component | CIDR Block | Description |
|------------|-------------|-------------|
| **VPC** | 10.0.0.0/16 | Main network |
| **Public Subnet (AZ1)** | 10.0.1.0/24 | Web servers |
| **Private Subnet (AZ1)** | 10.0.2.0/24 | App/DB servers |
| **Public Subnet (AZ2)** | 10.0.3.0/24 | Redundancy |
| **Private Subnet (AZ2)** | 10.0.4.0/24 | Redundancy |

---

## 🧱 High Availability, Fault Tolerance & Scalability in VPC

| Concept | Description | Example |
|----------|--------------|----------|
| **High Availability (HA)** | Deploy resources in **multiple AZs** to ensure uptime even if one AZ fails. | EC2 instances in 2+ AZs under an ELB. |
| **Fault Tolerance (FT)** | System continues to operate during failures using redundant resources. | NAT Gateway in multiple AZs. |
| **Scalability** | Add more subnets, NATs, or peering connections dynamically. | Auto Scaling EC2s within the VPC. |

---

## 🔐 Security in VPC

| Layer | Tool | Function |
|--------|------|-----------|
| **Instance** | Security Groups | Stateful control of inbound/outbound rules. |
| **Subnet** | NACLs | Stateless filtering at subnet boundary. |
| **VPC Edge** | IGW / NAT / VPN | Secure ingress/egress points. |
| **Service Access** | VPC Endpoints | Private connectivity to AWS services. |

**Additional Security Features:**
- VPC Flow Logs (monitor all traffic)
- AWS Network Firewall
- Traffic Mirroring for deep packet inspection
- AWS Shield & WAF for DDoS and web protection

---

## 🌐 Connectivity Options

| Type | Description |
|------|--------------|
| **VPC Peering** | Connects two VPCs using private IPs. |
| **Transit Gateway** | Central hub connecting multiple VPCs and on-prem networks. |
| **Site-to-Site VPN** | Securely connects on-premises data center to AWS. |
| **Direct Connect** | Dedicated private connection between on-prem and AWS. |

---

## 🧰 Common AWS CLI Commands

```bash
# Create a VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create a subnet
aws ec2 create-subnet --vpc-id vpc-xxxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a

# Create and attach an Internet Gateway
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --vpc-id vpc-xxxx --internet-gateway-id igw-xxxx

# Create route table and add routes
aws ec2 create-route-table --vpc-id vpc-xxxx
aws ec2 create-route --route-table-id rtb-xxxx --destination-cidr-block 0.0.0.0/0 --gateway-id igw-xxxx

# Enable DNS Hostnames
aws ec2 modify-vpc-attribute --vpc-id vpc-xxxx --enable-dns-hostnames "{\"Value\":true}"
````

---

## 🚀 Use Cases

* Hosting **multi-tier web applications**
* Creating **isolated environments** for dev/test/prod
* **Hybrid cloud connectivity** with VPN or Direct Connect
* **Secure communication** between microservices via PrivateLink
* **Disaster recovery** and cross-region failover

---

## 💡 Pro Tips

* Always use **multiple AZs** for production-grade fault tolerance.
* Use **NAT Gateway** instead of NAT Instance (for scalability & maintenance-free setup).
* Enable **VPC Flow Logs** for traffic visibility.
* Keep subnets **small and purpose-based** (e.g., Web, App, DB).
* Use **Security Groups for allow rules**, **NACLs for deny rules**.
* Consider **Transit Gateway** for large architectures (multi-VPC setups).

---

## 🧾 Summary Table

| Feature             | Description                                          |
| ------------------- | ---------------------------------------------------- |
| **Isolation**       | Logical separation of network resources              |
| **Security**        | Controlled using SGs, NACLs, and VPC Endpoints       |
| **Internet Access** | Via IGW (Public) or NAT (Private)                    |
| **Routing**         | Custom route tables define traffic paths             |
| **HA/FT**           | Multi-AZ deployments, redundant components           |
| **Scalability**     | Expandable with new subnets, routes, and peers       |
| **Integration**     | Works with EC2, RDS, ELB, Lambda, S3 (via endpoints) |

---

✅ **In Summary:**
Amazon VPC is the **foundation of AWS networking**, providing a **secure, scalable, and customizable** environment for deploying cloud resources. It enables **fine-grained control over traffic flow, isolation, and security**, making it essential for any modern cloud architecture.
