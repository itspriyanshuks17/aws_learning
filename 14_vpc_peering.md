# 🌐 VPC Peering - Deep Dive & Lab

VPC Peering is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 or IPv6 addresses.  
Instances in either VPC can communicate with each other as if they are within the same network.

![VPC Peering Architecture](image/14_vpc_peering/architecture.png)
*(Note: High-resolution architecture diagram coming soon)*

---

## 📋 Checklist (Quick View)

- [ ] VPC-A CIDR: 10.0.0.0/16
- [ ] Public Subnet A: 10.0.1.0/24
- [ ] Private Subnet A: 10.0.2.0/24
- [ ] VPC-B CIDR: 10.1.0.0/16
- [ ] Public Subnet B: 10.1.1.0/24
- [ ] Private Subnet B: 10.1.2.0/24
- [ ] Internet Gateways: IGW-A and IGW-B
- [ ] Route Tables: RT-Public-A, RT-Private-A, RT-Public-B, RT-Private-B
- [ ] NAT Gateway (optional) for private subnets
- [ ] VPC Peering connection between VPC-A and VPC-B
- [ ] EC2 instances in public subnets for testing

---

## 🏗️ Step 1 — Create VPC A (10.0.0.0/16)

1. Sign in to the AWS Management Console (https://console.aws.amazon.com) using your lab/student AWS account.
2. From the top Services menu, search for and select 'VPC' to open the VPC Dashboard.
3. In the left menu, click 'Your VPCs'.
4. Click the blue 'Create VPC' button.
5. Choose the 'VPC only' option (we will add subnets separately).
6. Fill the form: 
   - Name tag = 'VPC-A'
   - IPv4 CIDR block = '10.0.0.0/16'
   - Leave IPv6 CIDR block unchecked
   - Tenancy = Default
7. Click 'Create VPC'. A success message appears and your VPC is created. Note the VPC ID (e.g., vpc-0a1b2c3d).

✔️ **Tip:** Keep the VPC ID handy — you'll use it when creating subnets and route tables.

---

## 🛣️ Step 2 — Create Route Tables for VPC-A

1. In the VPC console left menu, click 'Route Tables'.
2. Click 'Create route table'. For the first route table:
   - Name tag = 'RT-Public-A'
   - VPC = select 'VPC-A'
   - Click 'Create route table'
3. Create a second route table:
   - Name tag = 'RT-Private-A'
   - VPC = 'VPC-A'
   - Click 'Create route table'
4. You now have two route tables for VPC-A. RT-Public-A will have a route to an Internet Gateway (added later). RT-Private-A will be used for private subnets (no IGW route).

---

## 🏠 Step 3 — Create Subnets for VPC-A

1. In the VPC left menu, click 'Subnets'.
2. Click 'Create subnet'.
3. Select VPC: 'VPC-A'. For Availability Zone choose any (e.g., us-east-1a).
4. Create Public Subnet A:
   - Name tag = 'Public-Subnet-A'
   - IPv4 CIDR block = '10.0.1.0/24'
   - Click 'Add new subnet' if required and then 'Create subnet'
5. Create Private Subnet A: Repeat 'Create subnet' with:
   - Name tag = 'Private-Subnet-A'
   - IPv4 CIDR block = '10.0.2.0/24'
6. After creation, verify both subnets appear and they are associated with VPC-A.

✔️ **Note:** By default subnets do not have route table associations changed — we will associate them next.

---

## 🔗 Step 4 — Associate Route Tables with Subnets (VPC-A)

1. Go to 'Route Tables' and select 'RT-Public-A'.
2. Open the 'Subnet associations' tab and click 'Edit subnet associations'.
3. Check the box for 'Public-Subnet-A' and Save. RT-Public-A is now used by the public subnet.
4. Select 'RT-Private-A' and edit subnet associations to select 'Private-Subnet-A'. Save.

---

## 🌐 Step 5 — Create and Attach Internet Gateway (VPC-A)

1. In the VPC console left menu, click 'Internet Gateways'.
2. Click 'Create internet gateway'. Set Name tag = 'IGW-A'. Click 'Create internet gateway'.
3. Select the newly created IGW-A, click 'Actions' → 'Attach to VPC' → choose 'VPC-A' → 'Attach internet gateway'.
4. Now IGW-A is attached to VPC-A.
5. Edit RT-Public-A routes to add Internet access:
   - Select RT-Public-A → Routes tab → Edit routes → Add route
   - Destination = 0.0.0.0/0
   - Target = IGW-A
   - Save routes

---

## 🏗️ Step 6 — Create VPC B (10.1.0.0/16) and its components

1. In VPC console, click 'Create VPC':
   - Name tag = 'VPC-B'
   - IPv4 CIDR block = '10.1.0.0/16'
   - Click Create VPC
2. Create route tables: 'RT-Public-B' and 'RT-Private-B' (both under VPC-B).
3. Create subnets: 'Public-Subnet-B' (10.1.1.0/24) and 'Private-Subnet-B' (10.1.2.0/24).
4. Create and attach Internet Gateway: 'IGW-B' → Attach to VPC-B.
5. Edit RT-Public-B routes: add route 0.0.0.0/0 → IGW-B and associate Public-Subnet-B with RT-Public-B; associate Private-Subnet-B with RT-Private-B.

✔️ **Tip:** Ensure CIDR blocks (10.0.0.0/16 and 10.1.0.0/16) do not overlap.

---

## 🚪 Step 7 — (Optional) Create NAT Gateway for Private Subnet Internet Egress

1. In the VPC left menu, click 'NAT Gateways'.
2. Click 'Create NAT gateway'. For Subnet choose 'Public-Subnet-A' (NAT must be in a public subnet).
3. Allocate a new Elastic IP (click 'Allocate Elastic IP').
4. Click 'Create NAT gateway' and wait until its status becomes 'Available' (usually a minute).
5. Edit RT-Private-A route table:
   - Routes → Edit routes → Add route
   - Destination = 0.0.0.0/0
   - Target = NAT Gateway (nat-xxxx)
   - Save
6. Repeat NAT creation for VPC-B if you want private subnets there to have internet access.

---

## 🖥️ Step 8 — Launch EC2 Instances for Testing

1. Open the AWS Console main menu and select 'EC2' service.
2. Click 'Instances' → 'Launch instances'.
3. **Step 1:** Choose an AMI. Select 'Amazon Linux 2 AMI (HVM)' (free tier eligible).
4. **Step 2:** Choose Instance Type. Select 't2.micro' (free tier) or 't3.micro'. Click 'Next'.
5. **Step 3:** Configure Instance:
   - Under 'Network' select 'VPC-A'
   - 'Subnet' select 'Public-Subnet-A'
   - Ensure 'Auto-assign Public IP' = Enable
   - Leave defaults for other fields
6. **Step 4:** Add Storage. Keep default (8 GiB). Click 'Next'.
7. **Step 5:** Add Tags. Click 'Add Tag' → Key = Name ; Value = EC2-VPC-A. Click Next.
8. **Step 6:** Configure Security Group. Create a new security group 'SG-EC2-Public-A':
   - Add inbound rules:
     - SSH (TCP 22) from YOUR_IP/32 (for lab)
     - HTTP (TCP 80) from 0.0.0.0/0 (optional)
     - ICMP (All ICMP) from 10.1.0.0/16 (to allow ping from VPC-B)
9. **Step 7:** Review and Launch. Choose or create a Key Pair for SSH access. Click 'Launch Instances'.
10. Repeat the same steps to launch EC2 in VPC-B:
    - Network: VPC-B
    - Subnet: Public-Subnet-B
    - Name tag = EC2-VPC-B
    - Security group inbound ICMP from 10.0.0.0/16

⚠️ **Security Note:** For classroom labs, restrict SSH access to your instructor or lab IP (YOUR_IP/32) instead of opening SSH to the world.

---

## 🔗 Step 9 — Create VPC Peering Connection (VPC-A ↔ VPC-B)

1. In the VPC console left menu, click 'Peering Connections'.
2. Click 'Create Peering Connection'.
3. Name tag = 'Peering-A-B'.
4. For 'Requester VPC', choose 'VPC-A'. For 'Accepter VPC', choose 'VPC-B'. (If cross-account, enter Account ID and peer VPC ID.)
5. Click 'Create Peering Connection'. The status shows 'Pending Acceptance' or 'Active' if same account.
6. If 'Pending Acceptance', select the peering connection and click 'Actions' → 'Accept Request'. Once accepted, status becomes 'Active'.

---

## 🛣️ Step 10 — Update Route Tables to Use the Peering Connection

1. Go to 'Route Tables' and select RT-Public-A (or RT-Private-A if private instances should access peer VPC).
2. Open 'Routes' → 'Edit routes' → 'Add route'.
3. Destination = '10.1.0.0/16' (CIDR of VPC-B). Target = choose 'Peering Connection' and select 'Peering-A-B'. Save routes.
4. Now select RT-Public-B (or RT-Private-B) and add route:
   - Destination = '10.0.0.0/16'
   - Target = 'Peering-A-B'
   - Save
5. **Important:** If you want only private subnets to talk across peering, add those routes to RT-Private-A and RT-Private-B instead of public RTs.

---

## 🛡️ Step 11 — Security Group Rules for Cross-VPC Communication

1. Go to EC2 → Security Groups.
2. Select the security group used by EC2-VPC-A (SG-EC2-Public-A). Click 'Edit inbound rules'.
3. Add an inbound rule to allow ICMP (All ICMP) or specific ports from VPC-B CIDR (10.1.0.0/16).
   - For example: Type=All ICMP, Source=10.1.0.0/16. Save rules.
4. Repeat for EC2-VPC-B security group: allow ICMP or required application ports from 10.0.0.0/16.
5. If you used security group references (recommended) you can allow traffic from the other instance's security group ID instead of CIDR.

---

## 🧪 Step 12 — Test Connectivity Between EC2 Instances

1. From your laptop, SSH into EC2-VPC-A using its public IP and your key pair:
   ```bash
   ssh -i path/to/key.pem ec2-user@<PUBLIC_IP>
   ```
2. From EC2-VPC-A, test ping to EC2-VPC-B private IP:
   ```bash
   ping <PRIVATE_IP_VPC_B>
   ```
   (ICMP must be allowed in SG)
3. If ping fails, check:
   - (a) Peering status is 'Active'
   - (b) Route tables contain routes for the remote CIDR pointing to the peering connection
   - (c) Security groups allow ICMP and required ports
   - (d) NACLs are not blocking traffic
4. For application test: From EC2-VPC-A, try:
   ```bash
   curl http://<PRIVATE_IP_VPC_B>:<PORT>
   ```
   if you have an app running.
5. Once tests pass in both directions, your VPC Peering setup is verified.

---

## 🔧 Troubleshooting Checklist

- [ ] **Peering connection status is not Active** → Accept the peering request
- [ ] **Routes missing in route tables** → Add route pointing to peering connection
- [ ] **Security group rules blocking traffic** → Open the required ports/ICMP from peer CIDR
- [ ] **NACLs blocking traffic** → Ensure both inbound and outbound rules allow the traffic
- [ ] **Overlapping CIDR blocks** → Peering cannot route if CIDRs overlap

---

## 💡 Final Tips

• **Peering is non-transitive:** A↔B and B↔C does NOT imply A↔C. Use Transit Gateway for many VPCs.

• **Enable DNS resolution over peering** if you need private DNS names across VPCs:
  Select peering → Actions → Edit DNS settings → Allow DNS resolution from remote VPC (do on both sides).

• **Use Security Group references** (allow sg-ids) for better security than CIDR rules.

• **Clean up resources** (NAT, EC2, IGW, Peering) after lab to avoid unexpected costs.

---

## 📊 Architecture Diagram

```
VPC-A (10.0.0.0/16)          VPC-B (10.1.0.0/16)
├── Public Subnet A           ├── Public Subnet B
│   └── EC2-VPC-A            │   └── EC2-VPC-B
├── Private Subnet A          ├── Private Subnet B
├── IGW-A                     ├── IGW-B
└── NAT Gateway (optional)    └── NAT Gateway (optional)
            \                 /
             \               /
              VPC Peering Connection
```

---

## ✅ Summary

This lab demonstrates:
- Creating multiple VPCs with proper CIDR planning
- Configuring public/private subnets and route tables
- Setting up Internet and NAT Gateways
- Establishing VPC Peering for cross-VPC communication
- Testing connectivity and troubleshooting common issues

**Next Steps:** Explore Transit Gateway for connecting multiple VPCs at scale.