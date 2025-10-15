# AWS IAM (Identity and Access Management)

## 🔹 What is IAM?
AWS IAM is a **global security service** that enables you to securely control **who can access your AWS resources** and **what actions they can perform**.  
It is the **backbone of AWS security**, allowing you to define authentication (who can log in) and authorization (what they can do).

✅ IAM is **free** (you only pay for the resources accessed).  
✅ IAM is **global** (configured once for the whole AWS account, not region-specific).  

---

## 🔹 Key Concepts

1. **Users**
   - Represents a person or an application.
   - Credentials:
     - Console access → username + password
     - Programmatic access → Access Key ID + Secret Key
   - Example: `Priyanshu` (developer) → Needs access to EC2 and S3.

2. **Groups**
   - Collection of IAM users.
   - Easier permission management.
   - Example:
     - `Developers` group → S3 Read/Write
     - `Admins` group → Full AWS access

3. **Roles**
   - Temporary credentials assigned to users, AWS services, or external identities.
   - No password or access key.
   - Example:
     - EC2 instance role → Allows instance to access S3
     - Cross-account role → Account A users can access Account B resources

4. **Policies**
   - JSON documents that define **permissions**.
   - Structure:
     ```json
     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Allow",
           "Action": "s3:ListBucket",
           "Resource": "arn:aws:s3:::mybucket"
         }
       ]
     }
     ```
   - Types:
     - AWS Managed Policies (predefined, e.g., `AmazonEC2FullAccess`)
     - Customer Managed Policies (created by you)
     - Inline Policies (attached to a single user/role/group)

5. **Root Account**
   - Created during AWS sign-up.
   - Full unrestricted access.
   - Should be used **only for account setup**.
   - Protect with MFA.

---

## 🔹 Features
- Fine-grained permissions (down to API level).
- IAM Access Analyzer (detects unintended public access).
- Identity Federation (use external identities like Google, AD, etc.).
- Service-linked roles (auto-created roles for AWS services).
- Credential rotation & lifecycle management.
- MFA enforcement.

---

## 🔹 Real-World Use Cases

- **Enterprise Setup**
  - HR → Read-only access to billing (Cost Explorer).
  - Developers → S3 + DynamoDB read/write.
  - SysAdmins → EC2 + VPC full control.
  - Security Team → CloudTrail + GuardDuty permissions.

- **Cross-Account Access**
  - Company A’s auditors access S3 buckets in Company B via roles.

- **Service Role Example**
  - EC2 instance role allows app server to:
    - Download code from S3
    - Write logs to CloudWatch

- **Federated Identity**
  - Employees login using Google Workspace → IAM roles mapped to permissions.

---

## 🔹 Common CLI Commands

```bash
# List all users
aws iam list-users

# Create a new IAM user
aws iam create-user --user-name devUser

# Attach AWS managed policy to a user
aws iam attach-user-policy \
    --user-name devUser \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create a new IAM group
aws iam create-group --group-name Developers

# Add user to a group
aws iam add-user-to-group --user-name devUser --group-name Developers

# Create a role with trust policy
aws iam create-role \
    --role-name EC2S3AccessRole \
    --assume-role-policy-document file://trust-policy.json

# Attach inline policy to a role
aws iam put-role-policy \
    --role-name EC2S3AccessRole \
    --policy-name S3AccessPolicy \
    --policy-document file://policy.json

# List access keys of a user
aws iam list-access-keys --user-name devUser
````

---

## 🔹 Security Best Practices

* Follow the **Principle of Least Privilege**.
* Use **IAM Roles** instead of embedding access keys.
* Enable **MFA** for root and privileged accounts.
* Regularly **rotate access keys** (every 90 days).
* Use **IAM Access Analyzer** to detect unintended access.
* Monitor IAM activity with **AWS CloudTrail**.
* Tag users/roles for **cost tracking and auditing**.
* Disable or delete unused IAM users.

---

## 🔹 Exam/Interview Notes

* IAM is a **global service** (not region-scoped).
* Root account should **not** be used for daily operations.
* Inline policies are **1-to-1** (user-specific), while managed policies are **reusable**.
* **Temporary credentials** are obtained using STS (Security Token Service).
* **Identity Federation** allows users to login with external IdPs (AD, Google, SAML).
* IAM integrates with AWS Organizations for **multi-account setups**.

---

## 📌 Diagram (Text-Based)

```
         [ Root Account ]
                |
     ------------------------
     |          |           |
  [Users]   [Groups]    [Roles]
     |          |           |
 [Policies] [Policies]  [Policies]
```

---

## 🔹 Extra Notes

* IAM is essential for **compliance (ISO, SOC, HIPAA)**.
* IAM roles are commonly used with **EC2, Lambda, ECS, and cross-account setups**.
* IAM does not manage operating system users (only AWS access).
* Use **service-linked roles** when AWS services need to call other AWS APIs on your behalf.
