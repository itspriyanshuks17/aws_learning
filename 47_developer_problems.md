# 🛠️ Common Developer Problems on AWS (Troubleshooting)

AWS is powerful, but things break. This guide covers the most common errors developers face and how to fix them.

## 📋 Table of Contents

1. [EC2 Connection Issues](#1-ec2-connection-issues)
2. [S3 Access Denied (403)](#2-s3-access-denied-403)
3. [Lambda Errors](#3-lambda-errors)
4. [IAM Permission Errors](#4-iam-permission-errors)
5. [Infrastructure (CloudFormation)](#5-infrastructure-cloudformation)
6. [Deployment (CodeDeploy)](#6-deployment-codedeploy)
7. [Load Balancer Errors (5xx)](#7-load-balancer-errors-5xx)
8. [Database & Scaling](#8-database--scaling)
9. [Exam Cheat Sheet](#9-exam-cheat-sheet)

---

## 1. EC2 Connection Issues

### Problem: "Connection Refused" or "Connection Timed Out" (SSH/HTTP)

- **Cause 1: Security Groups (Most Common)**.
  - _Check_: Does the Inbound Rule allow your IP?
  - _Fix_: Add a rule allowing SSH (Port 22) or HTTP (Port 80) from your IP (`My IP` in console) or `0.0.0.0/0`.
- **Cause 2: NACLs (Network Access Control Lists)**.
  - _Check_: Are subnets blocking traffic at the VPC level?
  - _Fix_: Ensure NACLs allow traffic BOTH Inbound and Outbound (NACLs are stateless).
- **Cause 3: Missing Internet Gateway**.
  - _Check_: Is the instance in a Public Subnet? Does the Route Table have `0.0.0.0/0 -> igw-xxxx`?

### Problem: "Permission Denied (publickey)"

- **Cause**: Wrong private key (`.pem`) or wrong user name.
- **Fix**:
  - Amazon Linux 2/2023 user: `ec2-user`
  - Ubuntu user: `ubuntu`
  - Command: `ssh -i my-key.pem ec2-user@<public-ip>`

---

## 2. S3 Access Denied (403)

### Problem: "403 Forbidden" when accessing a file

- **Cause 1: Block Public Access**.
  - _Fix_: Turn off "Block all public access" settings on the bucket if you intend it to be public.
- **Cause 2: Bucket Policy**.
  - _Check_: Does the Bucket Policy explicitly `Deny` access? Or does it fail to `Allow`?
- **Cause 3: KMS Encryption**.
  - _Check_: If the object is encrypted with KMS, the user _ALSO_ needs `kms:Decrypt` permission, not just `s3:GetObject`.

---

## 3. Lambda Errors

### Problem: "Task Timed Out" after 3.00 seconds

- **Cause**: Default timeout is 3 seconds. Your code takes longer (e.g., connecting to DB).
- **Fix**: Increase Timeout setting (Max 15 mins).

### Problem: "Cold Starts" (Slow initial response)

- **Cause**: AWS loading your code environment. Common in Java/C# or inside VPCs.
- **Fix**: Use **Provisioned Concurrency** or increase Memory (which gives more CPU).

### Problem: "KMS Exception: Ciphertext refers to a customer master key that does not exist"

- **Cause**: You deleted the KMS key used to encrypt Environment Variables.

---

## 4. IAM Permission Errors

### Problem: "User is not authorized to perform: `service:Action` on resource"

- **Cause**: The IAM User or Role is missing a policy.
- **Debugging Tool**: Use the **IAM Policy Simulator** to test which policy is denying the action.
- **Encoded Error Message**: If you get a long encoded error string, run `aws sts decode-authorization-message --encoded-message <string>` to see the exact reason (requires `sts:DecodeAuthorizationMessage` permission).

---

## 5. Infrastructure (CloudFormation)

### Problem: "UPDATE_ROLLBACK_FAILED"

- **Cause**: A stack update failed (e.g., bad parameter), CloudFormation tried to roll back, but the rollback ALSO failed (e.g., a resource was manually deleted).
- **Fix**: You must manually fix the underlying error (e.g., recreating the deleted resource) and then use "Continue Update Rollback". Or, delete the stack and start over.

### Problem: "Drift Detected"

- **Cause**: Someone manually changed a resource (e.g., changed an SG rule via Console).
- **Fix**: Run **Drift Detection**. Then either update the template to match the change (if good) or overwrite the resource by running "Update Stack" (if bad).

---

## 6. Deployment (CodeDeploy)

### Problem: "ApplicationStop failed"

- **Cause**: The _previous_ deployment's script is failing. CodeDeploy runs the `ApplicationStop` hook from the _last successful_ revision before downloading the new one.
- **Fix**: SSH into the instance and manually delete the deployment history/files, or use the `--ignore-application-stop-failures` flag.

### Problem: "Deployment Succeeded but App is Down"

- **Cause**: Your scripts passed (exit code 0), but the app process crashed 10 seconds later.
- **Fix**: Add a `ValidateService` hook that actually curls `localhost:8080` to verify the app is responding before marking the deployment as specific.

---

## 7. Load Balancer Errors (5xx)

### Problem: "502 Bad Gateway"

- **Cause**: The application on the EC2 instance closed the connection or sent a malformed response.
- **Fix**: Check application logs (Nginx/Node.js). Ensure the app is running on the correct port.

### Problem: "504 Gateway Timeout"

- **Cause**: The application took too long to respond (longer than the ALB idle timeout).
- **Fix**: Optimize DB queries if they are slow, or increase the idle timeout on the ALB (default 60s).

### Problem: "Health Checks Failing (Unhealthy)"

- **Cause**: ALB pinging `/health` but getting a non-200 code.
- **Fix**: Ensure your app has a specific route `/health` that returns `200 OK`. Check Security Groups (ALB must be allowed to reach Instance).

---

## 8. Database & Scaling

### Problem: "TooManyConnections" (RDS)

- **Cause**: Application opening a new DB connection for every request without closing it.
- **Fix**: Use a **Connection Pool** (in code) or **RDS Proxy**.

### Problem: "ProvisionedThroughputExceededException" (DynamoDB)

- **Cause**: Request rate is higher than Read/Write Capacity Units (RCU/WCU).
- **Fix**: Use exponential backoff in code, switch to On-Demand capacity, or enabling Auto Scaling for DynamoDB.

### Problem: "ASG Thrashing" (Scaling Up and Down Rapidly)

- **Cause**: Scaling policies are too aggressive (e.g., Scale out at 50% CPU, Scale in at 45% CPU).
- **Fix**: Add a **Cooldown Period** (suspend scaling for 300s after an action) or widen the gap between scale-out and scale-in thresholds.

---

## 9. Exam Cheat Sheet

- **Instance Connection**: "Timout" = **Security Group** (Stateful). "Permission Denied" = **Key Pair**.
- **S3 Public**: "Cannot make bucket public" = Check **Block Public Access** settings first.
- **Encryption Access**: "User has S3 access but gets Access Denied on download" = Check **KMS Key Policy**.
- **Lambda VPC**: "Lambda times out connecting to RDS" = Lambda needs access to private subnet (NAT Gateway) relative to where it was launched, or Security Group usually blocks outbound.
