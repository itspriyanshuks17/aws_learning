# AWS Practical Lab Guide - MidTerm

## Practical 1: Launch & Interact with a Cloud-Native SQL Database

**Objective**: Create a managed relational database, connect from a client, run basic SQL (create table/insert/select), and show backups & public/private connectivity.

**Prerequisites**:
- Cloud account (AWS or Azure)
- IAM user with console access
- Simple client (mysql/psql/Azure Data Studio)

### A. AWS RDS (MySQL/Postgres) – Step-by-Step

**Console Setup**:
1. Sign in → RDS → Databases → Create database → Standard create
2. Choose engine (MySQL or PostgreSQL) - *Refer to AWS Documentation*
3. Select: Free tier/db.t3.micro (if using free tier)
   - DB identifier: `lab-rds-db`
   - Master username: `labadmin`
   - Set password
4. **Networking**:
   - Place DB in VPC (use VPC from Lab 2 or Default VPC)
   - Choose Subnet group (private recommended)
   - Public accessibility = No for production; Yes for labs only
5. Configure VPC security group to allow port 3306/5432 from your lab machine IP
6. **Additional settings**:
   - Enable automated backups (1 day)
   - Set retention as demo
7. Create and wait until status = available

**Connect**:
- From EC2 jumpbox or local client (if public access enabled):

```bash
# MySQL
mysql -h <endpoint> -u labadmin -p

# Postgres
psql -h <endpoint> -U labadmin -d postgres
```

**Run SQL**:
```sql
CREATE TABLE students(id INT PRIMARY KEY, name VARCHAR(100));
INSERT INTO students VALUES (1,'Anita');
SELECT * FROM students;
```

**Verification**: Query returns inserted row; automated backup visible in RDS console.

**Common Issues/Fixes**:
- Can't connect → check RDS security group inbound rule and subnet public accessibility
- "Password auth failed" → re-check username, reset master password in console

### B. Azure SQL Database (Quick Student Lab)

**Portal**:
1. Azure Portal → Create a resource → Azure SQL → Single database
2. Choose server (create new), specify admin login - *Microsoft Learn*
3. Set compute tier: Basic/DTU or vCore for lab
4. Configure firewall rule to allow client IP
5. Deploy, then use Query editor (preview) in portal or connect using Azure Data Studio:

```bash
sqlcmd -S <server>.database.windows.net -U admin -P <password>
```

6. Run same SQL create/insert/select example (use T-SQL syntax if needed)

**Checks & Issues**: Firewall rule is common blocker — add client IP in server firewall settings.

---

## Practical 2: Create & Configure a VPC with Public and Private Subnets (AWS)

### Step A: AWS VPC Setup (Simplified)

**1. Launch VPC Wizard**
- Open AWS Console → VPC → VPC Dashboard → Launch VPC Wizard
- Choose: VPC with Public and Private Subnets

**2. Configure IP Addresses**
- VPC CIDR: `10.0.0.0/16` (overall network)
- Public Subnet: `10.0.1.0/24`
- Private Subnet: `10.0.2.0/24`

*CIDR defines the IP range. /16 gives ~65,536 addresses for the VPC. /24 gives 256 addresses for each subnet.*

**3. Internet Gateway (IGW)**
- Automatically attached by wizard to public subnet
- Purpose: Allows internet traffic to reach your public subnet EC2

**4. NAT Gateway**
- Create NAT in public subnet
- Purpose: Private subnet EC2 can access the internet (e.g., updates) without exposing them directly

### Step B: Launch EC2 Instances

**Public EC2**:
- Launch into public subnet
- Assign public IP
- This EC2 can be accessed directly from your machine (SSH)

**Private EC2**:
- Launch into private subnet
- No public IP (secured)
- Can only access the internet via NAT

**5. Test Connectivity**

From public EC2, SSH into private EC2:
```bash
ssh ec2-user@<private-ip>
```

From private EC2, check internet access:
```bash
curl http://ifconfig.me
```

**6. Verification**
- ✅ Private EC2 can access internet through NAT
- ✅ Public EC2 reachable from your laptop
- ✅ Route tables:
  - Public subnet: `0.0.0.0/0` → IGW
  - Private subnet: `0.0.0.0/0` → NAT Gateway

---

## Practical 3: Managing User Access Using IAM Roles and Policies

**Objective**: Create IAM users/groups, write a least-privilege policy, and create a role assumable by EC2 (instance profile) or by a cross-account principal.

**Prerequisites**: AWS account with admin privileges.

### Hands-on Steps

**Console**:
1. IAM → Users → Add users → create `lab-student` with Console access
2. Add to group `LabReaders`

**Policies**:
1. IAM → Policies → Create policy (JSON editor)
2. Example policy to allow read-only S3:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": [
        "arn:aws:s3:::lab-bucket",
        "arn:aws:s3:::lab-bucket/*"
      ]
    }
  ]
}
```

3. Attach policy to `LabReaders` group
4. Verify user permissions by signing in as that user (or use IAM policy simulator) - *AWS Documentation*

**Roles for EC2**:
1. IAM → Roles → Create role → AWS service → EC2
2. Attach policy (e.g., S3 read) → name `ec2-s3-read-role`
3. Launch EC2 with that role (Instance profile)
4. From EC2, curl metadata to confirm role exists and use AWS CLI to access S3 without credentials:

```bash
aws s3 ls s3://lab-bucket
```

**Verification**: User cannot perform disallowed actions; EC2 can access S3 without storing keys.

---

## Practical 4: Deploy a Web Application Using AWS Elastic Beanstalk or Azure App Service

**Objective**: Deploy a simple Node.js (or static) web app, update app versions, and view logs/health.

**Prerequisites**: Small app repo (sample Node app) zipped or in GitHub.

### AWS Elastic Beanstalk (Fast Lab)

**Prepare App**:
- A simple Node `server.js` that listens on `process.env.PORT || 8080`
- Zip as `app.zip` (or connect Git)

**Console**:
1. Elastic Beanstalk → Create application → give name
2. Create environment → Web server environment → choose platform Node.js → upload `app.zip`
3. Create
4. Wait for environment to become green; open the URL provided by Beanstalk

**Update**:
1. Make small change, create new application version
2. Upload and deploy
3. Check Logs and Health in console

**Verification**: App returns expected page; new versions deploy without manual EC2 work.

**Troubleshooting**: Platform logs in console; common error is PORT mismatch — ensure app listens on provided env port.

### Azure App Service (Brief)

**Option**: Create App Service → choose runtime (Node/Python), deploy via GitHub Actions or ZIP deploy from portal.

**Student Task**: Implement zero-downtime deploy by uploading new version and observe environment swapping.

---

## Practical 5: Deploy a Static Website on AWS S3 and a Dynamic Website on EC2

**Objective**: Host a static site on S3 + CloudFront (optional) and deploy a dynamic website on EC2 (with security group, Elastic IP, and optional Load Balancer).

### A. Static Site on S3 (Steps)

1. Create S3 bucket named like `yourdomain.com` → Properties → Static website hosting enable
2. Upload `index.html` & `error.html`
3. **Permissions**: Disable Block Public Access for the bucket used for site hosting only after understanding risk
4. Add bucket policy to allow `s3:GetObject` for `arn:aws:s3:::yourbucket/*`
5. **(Optional)** Use CloudFront in front for HTTPS and better performance; set origin to the S3 website endpoint or bucket and configure OAC if SSE-KMS used
6. **Verify**: Open the S3 website endpoint URL and see the site

**Common Issues**: Block Public Access prevents site; bucket policy incorrect.

### B. Dynamic Site on EC2

1. Launch EC2 (Amazon Linux 2) with security group allowing 22 and 80/443
2. Assign Elastic IP if you want stable public address
3. SSH into instance, install web server and app (example Node):

```bash
sudo yum update -y
sudo yum install -y git
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash
sudo yum install -y nodejs
git clone <repo>
cd repo
npm install
NODE_ENV=production node server.js
```

4. Optionally place app behind Apache/Nginx reverse proxy and set up systemd unit to keep it running
5. For scale, create an Auto Scaling Group + Application Load Balancer
6. **Verify**: Open `http://<ip>` and see dynamic app responding

**Student Tasks**: Add HTTPS using Let's Encrypt on EC2 or prefer CloudFront + S3/ALB depending on architecture.