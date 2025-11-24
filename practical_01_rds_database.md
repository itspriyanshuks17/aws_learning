# 🗄️ Practical 1: Launch & Interact with Cloud-Native SQL Database

## 🎯 Objective
Create a managed relational database, connect from a client, run basic SQL (create table/insert/select), and show backups & public/private connectivity.

## 📋 Prerequisites
- Cloud account (AWS or Azure)
- IAM user with console access
- Simple client (mysql/psql/Azure Data Studio)

---

## 🔧 A. AWS RDS (MySQL/Postgres) – Step-by-Step

### Console Setup

1. **Navigate to RDS**
   - Sign in → RDS → Databases → Create database → Standard create

2. **Choose Database Engine**
   - Select MySQL or PostgreSQL
   - *Refer to [AWS Documentation](https://docs.aws.amazon.com/rds/)*

3. **Configure Database Settings**
   - Template: Free tier
   - Instance: `db.t3.micro` (if using free tier)
   - DB identifier: `lab-rds-db`
   - Master username: `labadmin`
   - Set secure password

4. **Networking Configuration**
   - Place DB in VPC (use VPC from Lab 2 or Default VPC)
   - Choose Subnet group (private recommended)
   - Public accessibility: 
     - **No** for production
     - **Yes** for simple labs only
   - Configure VPC security group to allow port 3306/5432 from your lab machine IP

5. **Additional Settings**
   - Enable automated backups (1 day retention)
   - Set retention period for demo

6. **Create Database**
   - Click Create
   - Wait until status = **Available**

### Connect to Database

From EC2 jumpbox or local client (if public access enabled):

```bash
# MySQL Connection
mysql -h <rds-endpoint> -u labadmin -p

# PostgreSQL Connection
psql -h <rds-endpoint> -U labadmin -d postgres
```

### Run SQL Commands

```sql
-- Create table
CREATE TABLE students(id INT PRIMARY KEY, name VARCHAR(100));

-- Insert data
INSERT INTO students VALUES (1, 'Anita');

-- Query data
SELECT * FROM students;
```

### Verification Checklist
- ✅ Query returns inserted row
- ✅ Automated backup visible in RDS console
- ✅ Connection successful from client

### Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Can't connect | Check RDS security group inbound rule and subnet public accessibility |
| "Password auth failed" | Re-check username, reset master password in console |
| Connection timeout | Verify security group allows port 3306 (MySQL) or 5432 (PostgreSQL) |

---

## 🔧 B. Azure SQL Database (Quick Student Lab)

### Portal Setup

1. **Create Database**
   - Azure Portal → Create a resource → Azure SQL → Single database
   - Choose server (create new)
   - Specify admin login
   - *Refer to [Microsoft Learn](https://learn.microsoft.com/)*

2. **Configure Settings**
   - Set compute tier: Basic/DTU or vCore for lab
   - Configure firewall rule to allow client IP

3. **Deploy Database**
   - Deploy and wait for completion

### Connect to Database

**Option 1: Query Editor (Portal)**
- Use Query editor (preview) in Azure portal

**Option 2: Command Line**
```bash
sqlcmd -S <server>.database.windows.net -U admin -P <password>
```

**Option 3: Azure Data Studio**
- Connect using Azure Data Studio with server details

### Run SQL Commands

```sql
-- Create table (T-SQL syntax)
CREATE TABLE students(id INT PRIMARY KEY, name NVARCHAR(100));

-- Insert data
INSERT INTO students VALUES (1, N'Anita');

-- Query data
SELECT * FROM students;
```

### Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| Connection blocked | Add client IP in server firewall settings |
| Authentication failed | Verify admin credentials and server name |

---

## 📊 Lab Completion Checklist

- [ ] RDS/Azure SQL database created successfully
- [ ] Database connection established
- [ ] Table created with SQL commands
- [ ] Data inserted and queried successfully
- [ ] Automated backups configured and visible
- [ ] Security groups/firewall rules properly configured
- [ ] Connection tested from client application

---

## 🔍 Key Learning Points

1. **Managed Database Benefits**
   - Automated backups and maintenance
   - High availability options
   - Scalability without downtime

2. **Security Considerations**
   - Private vs public accessibility
   - Security group/firewall configuration
   - Encryption at rest and in transit

3. **Connection Methods**
   - Direct client connections
   - Application-based connections
   - Jumpbox/bastion host patterns

---

## 📚 Additional Resources

- [AWS RDS User Guide](https://docs.aws.amazon.com/rds/)
- [Azure SQL Database Documentation](https://docs.microsoft.com/azure/sql-database/)
- [Database Security Best Practices](https://aws.amazon.com/rds/security/)