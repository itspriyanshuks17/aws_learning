# 🧭 AWS Route Tables

A **Route Table** in AWS defines how **network traffic is directed** within your **VPC (Virtual Private Cloud)**.  
It acts like a **map** that tells each subnet **where to send the traffic** based on destination IP addresses.

---

## 📖 Concept Overview

Each **subnet** in a VPC is associated with **exactly one Route Table** that controls the flow of outbound and inbound traffic.

- The **destination** specifies a range of IP addresses (CIDR block).
- The **target** specifies where the traffic should go (e.g., Internet Gateway, NAT Gateway, Peering Connection, etc.).

---

## 🧱 Structure of a Route Table

| Field | Description |
|--------|-------------|
| **Destination** | CIDR block representing the IP range for the route. |
| **Target** | The network gateway or resource where traffic is directed. |
| **Status** | Active/inactive (automatically managed by AWS). |
| **Propagated** | Whether the route is automatically added by a VPN or Direct Connect. |

---

## 🧩 Example of a Route Table

| Destination | Target | Purpose |
|--------------|---------|----------|
| `10.0.0.0/16` | local | Enables internal communication within VPC. |
| `0.0.0.0/0` | igw-123abc | Routes all Internet-bound traffic via Internet Gateway. |
| `10.1.0.0/16` | pcx-789xyz | Sends traffic to a peered VPC. |
| `0.0.0.0/0` | nat-567def | Private subnet’s Internet access through NAT Gateway. |

---

## 🧮 Types of Route Tables

### 1️⃣ **Main Route Table**
- Automatically created with the VPC.
- All subnets are associated with it by default.
- Typically used for **private routing** (no Internet access).

### 2️⃣ **Custom Route Table**
- User-created for **public or special-purpose subnets**.
- Allows routing to external networks like Internet Gateway or VPN.

| Comparison | Main Route Table | Custom Route Table |
|-------------|------------------|--------------------|
| **Created By** | AWS (by default) | User |
| **Associated Subnets** | All subnets by default | Manually associated |
| **Use Case** | Internal traffic | Internet-facing subnets |

---

## 🌐 Public vs Private Route Tables

| Type | Route Example | Description |
|------|----------------|-------------|
| **Public Route Table** | `0.0.0.0/0 → Internet Gateway` | Used by public subnets for Internet access. |
| **Private Route Table** | `0.0.0.0/0 → NAT Gateway` | Used by private subnets to access Internet **without** being exposed. |

---

## 🧩 Routing Targets in AWS

| Target Type | Example | Description |
|--------------|----------|--------------|
| **local** | 10.0.0.0/16 | Enables communication within the same VPC. |
| **igw-xxxx** | Internet Gateway | Internet access for public subnets. |
| **nat-xxxx** | NAT Gateway | Outbound Internet access for private subnets. |
| **pcx-xxxx** | VPC Peering Connection | Connects VPCs for private communication. |
| **vgw-xxxx** | Virtual Private Gateway | VPN connection to on-prem data center. |
| **tgw-xxxx** | Transit Gateway | Connects multiple VPCs and networks. |
| **vpce-xxxx** | VPC Endpoint | Private connection to AWS services. |

---

## 🧩 Route Table Association

- Each **subnet** must be associated with one (and only one) route table.
- Multiple subnets **can share** the same route table.
- If you don’t explicitly associate a subnet with a route table, it automatically uses the **main route table**.

```bash
# Example: Associate a subnet with a custom route table
aws ec2 associate-route-table \
  --route-table-id rtb-0a1b2c3d4e5f6g7h \
  --subnet-id subnet-12345678
````

---

## ⚙️ Workflow Example

### Scenario:

You have a **VPC (10.0.0.0/16)** with:

* Public Subnet: `10.0.1.0/24`
* Private Subnet: `10.0.2.0/24`

#### 🧩 Route Tables:

**1️⃣ Public Route Table**

| Destination | Target     | Purpose                    |
| ----------- | ---------- | -------------------------- |
| 10.0.0.0/16 | local      | Internal VPC communication |
| 0.0.0.0/0   | igw-1a2b3c | Internet access            |

**2️⃣ Private Route Table**

| Destination | Target     | Purpose                         |
| ----------- | ---------- | ------------------------------- |
| 10.0.0.0/16 | local      | Internal VPC communication      |
| 0.0.0.0/0   | nat-4d5e6f | Internet access via NAT Gateway |

---

## 🧠 ASCII Architecture Diagram

```
                        +---------------------------+
                        |         Internet          |
                        +---------------------------+
                                    |
                             [ Internet Gateway ]
                                    |
                          +--------------------+
                          |  Public Route Table|
                          +--------------------+
                          | 10.0.0.0/16 → local|
                          | 0.0.0.0/0 → IGW    |
                          +---------+----------+
                                    |
                             +--------------+
                             | Public Subnet|
                             +--------------+
                                    |
                              [ EC2 Web Server ]
                                    |
                          +--------------------+
                          | Private Route Table|
                          +--------------------+
                          | 10.0.0.0/16 → local|
                          | 0.0.0.0/0 → NAT GW |
                          +---------+----------+
                                    |
                             +--------------+
                             | Private Subnet|
                             +--------------+
                                    |
                            [ EC2 DB Server ]
```

---

## 🔒 Security Integration

Route Tables work **in conjunction with**:

* **Security Groups** (instance-level rules)
* **Network ACLs** (subnet-level rules)

**Example:**
Even if a route allows Internet access (`0.0.0.0/0 → IGW`),
traffic will be **blocked** unless Security Group or NACL rules also allow it.

---

## 🧾 Best Practices

✅ Use **separate route tables** for public and private subnets.
✅ Keep routes **minimal** and **specific** to avoid misrouting.
✅ Always include the **local route** (`10.0.0.0/16 → local`) — AWS adds it automatically.
✅ For production, use **NAT Gateway** over NAT Instance for fault tolerance.
✅ Enable **VPC Flow Logs** to monitor route-level traffic.
✅ Document route table associations for future troubleshooting.

---

## 🧰 AWS CLI Commands

```bash
# Create a route table
aws ec2 create-route-table --vpc-id vpc-12345678

# Add a route to Internet Gateway
aws ec2 create-route \
  --route-table-id rtb-987654321 \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-abcdef123

# View all route tables
aws ec2 describe-route-tables

# Delete a route table
aws ec2 delete-route-table --route-table-id rtb-987654321
```

---

## 💡 Summary

| Concept          | Description                                           |
| ---------------- | ----------------------------------------------------- |
| **Purpose**      | Defines how traffic moves inside and outside the VPC  |
| **Main Table**   | Default routing for subnets not explicitly associated |
| **Custom Table** | Used for specialized routing (public/private)         |
| **Targets**      | IGW, NAT, VGW, TGW, Peering, etc.                     |
| **Association**  | One route table per subnet                            |
| **Integration**  | Works with Security Groups & NACLs                    |
| **Monitoring**   | VPC Flow Logs for traffic visibility                  |

---

✅ **In Summary:**
Route Tables are the **core of AWS VPC networking**, ensuring that packets reach the right destination efficiently and securely.
They enable **fine-grained traffic control**, separating public-facing resources from private infrastructure while maintaining internal communication.

