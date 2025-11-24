# 🔐 Practical 3: Managing User Access Using IAM Roles and Policies

## 🎯 Objective
Create IAM users/groups, write a least-privilege policy, and create a role assumable by EC2 (instance profile) or by a cross-account principal.

## 📋 Prerequisites
- AWS account with admin privileges
- Understanding of IAM concepts
- Basic knowledge of JSON policy syntax

---

## 👥 Step A: Create IAM Users and Groups

### 1. Create IAM Group

1. **Navigate to IAM Console**
   - AWS Console → IAM → Groups → Create New Group

2. **Configure Group**
   - Group Name: `LabReaders`
   - Description: `Read-only access for lab students`
   - Skip policy attachment for now (we'll create custom policy)

### 2. Create IAM User

1. **Create User**
   - IAM → Users → Add users
   - Username: `lab-student`
   - Access type: ✅ **AWS Management Console access**
   - Console password: Set custom password
   - Require password reset: ✅ (recommended)

2. **Add to Group**
   - Select `LabReaders` group
   - Complete user creation

---

## 📜 Step B: Create Custom IAM Policies

### 1. S3 Read-Only Policy

1. **Navigate to Policies**
   - IAM → Policies → Create policy

2. **JSON Policy Editor**
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:ListBucket",
           "s3:GetObject"
         ],
         "Resource": [
           "arn:aws:s3:::lab-bucket",
           "arn:aws:s3:::lab-bucket/*"
         ]
       }
     ]
   }
   ```

3. **Policy Details**
   - Name: `S3-ReadOnly-LabBucket`
   - Description: `Read-only access to lab-bucket S3 bucket`

### 2. EC2 Read-Only Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:List*"
      ],
      "Resource": "*"
    }
  ]
}
```

### 3. Attach Policies to Group

1. **Select Group**
   - IAM → Groups → `LabReaders`

2. **Attach Policies**
   - Permissions tab → Attach Policy
   - Select your custom policies
   - Click Attach Policy

---

## 🔄 Step C: Create IAM Roles for EC2

### 1. Create EC2 Service Role

1. **Create Role**
   - IAM → Roles → Create role
   - Trusted entity type: **AWS service**
   - Use case: **EC2**

2. **Attach Permissions**
   - Search and select: `AmazonS3ReadOnlyAccess`
   - Or attach your custom S3 policy

3. **Role Details**
   - Role name: `ec2-s3-read-role`
   - Description: `Allows EC2 instances to read S3 buckets`

### 2. Advanced Role with Custom Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::lab-bucket",
        "arn:aws:s3:::lab-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

---

## 🖥️ Step D: Launch EC2 with IAM Role

### 1. Launch EC2 Instance

1. **Basic Configuration**
   - AMI: Amazon Linux 2
   - Instance Type: `t2.micro`

2. **IAM Role Assignment**
   - Configure Instance → IAM role
   - Select: `ec2-s3-read-role`

3. **Security Group**
   - Allow SSH (port 22) from your IP

### 2. Test Role Functionality

1. **Connect to EC2**
   ```bash
   ssh -i your-key.pem ec2-user@<public-ip>
   ```

2. **Verify Role Assignment**
   ```bash
   # Check instance metadata for role
   curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
   
   # Should return: ec2-s3-read-role
   ```

3. **Test S3 Access**
   ```bash
   # Install AWS CLI (if not present)
   sudo yum install -y aws-cli
   
   # Test S3 access without credentials
   aws s3 ls s3://lab-bucket
   
   # Should list bucket contents without error
   ```

---

## 🧪 Step E: Test User Permissions

### 1. Test Lab Student Access

1. **Sign in as lab-student**
   - Use IAM user credentials
   - Navigate to S3 console

2. **Verify Read Access**
   - ✅ Can view `lab-bucket` contents
   - ✅ Can download objects
   - ❌ Cannot upload objects
   - ❌ Cannot delete objects

3. **Test Policy Simulator**
   - IAM → Policy Simulator
   - Select user: `lab-student`
   - Test actions: `s3:GetObject`, `s3:PutObject`

### 2. Verify Least Privilege

```bash
# These should FAIL for lab-student user
aws s3 cp file.txt s3://lab-bucket/  # Should be denied
aws s3 rm s3://lab-bucket/file.txt   # Should be denied
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0  # Should be denied
```

---

## 🔒 Step F: Cross-Account Role (Advanced)

### 1. Create Cross-Account Role

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT-B-ID:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "unique-external-id"
        }
      }
    }
  ]
}
```

### 2. Assume Role from Another Account

```bash
# From Account B
aws sts assume-role \
  --role-arn "arn:aws:iam::ACCOUNT-A-ID:role/CrossAccountRole" \
  --role-session-name "CrossAccountSession" \
  --external-id "unique-external-id"
```

---

## ✅ Verification Checklist

### User and Group Verification
- [ ] IAM user `lab-student` created successfully
- [ ] User added to `LabReaders` group
- [ ] Custom policies attached to group
- [ ] User can sign in to AWS Console

### Policy Verification
- [ ] User can read S3 bucket contents
- [ ] User cannot write to S3 bucket
- [ ] User cannot access unauthorized resources
- [ ] Policy simulator shows expected results

### Role Verification
- [ ] EC2 role created with appropriate permissions
- [ ] EC2 instance launched with role attached
- [ ] Instance can access S3 without stored credentials
- [ ] Role permissions work as expected

---

## 🔧 Troubleshooting Guide

### Common Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| User can't sign in | Invalid credentials | Check username/password, verify user exists |
| Access denied errors | 403 Forbidden | Review policy permissions, check resource ARNs |
| Role not working | EC2 can't access S3 | Verify role attachment, check trust policy |
| Policy too permissive | User has unexpected access | Review policy statements, apply least privilege |

### Policy Debugging

1. **Use CloudTrail**
   ```bash
   # Check API calls and access patterns
   aws logs filter-log-events \
     --log-group-name CloudTrail/APIGateway \
     --filter-pattern "{ $.errorCode = \"AccessDenied\" }"
   ```

2. **Policy Simulator**
   - Test specific actions before deployment
   - Verify policy logic and conditions

---

## 📊 IAM Best Practices Summary

### Security Principles
1. **Least Privilege**: Grant minimum permissions needed
2. **Separation of Duties**: Use groups and roles appropriately
3. **Regular Auditing**: Review permissions periodically
4. **Strong Authentication**: Enable MFA where possible

### Policy Design
- Use specific resource ARNs when possible
- Implement conditions for additional security
- Avoid using wildcards (*) in production
- Document policy purpose and scope

---

## 📚 Additional Resources

- [AWS IAM User Guide](https://docs.aws.amazon.com/iam/)
- [IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Policy Simulator](https://policysim.aws.amazon.com/)