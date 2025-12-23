# 🧑‍💻 AWS CodeCommit - Deep Dive

AWS CodeCommit is a **private, secure, and scalable source control service** that hosts private Git repositories. It is the AWS equivalent of GitHub or Bitbucket.

## 📋 Table of Contents

1. [Core Features](#1-core-features)
2. [Authentication (HTTPS vs SSH)](#2-authentication-https-vs-ssh)
3. [Security & Cross-Account Access](#3-security--cross-account-access)
4. [Triggers & Notifications](#4-triggers--notifications)
5. [Exam Cheat Sheet](#5-exam-cheat-sheet)

---

## 1. Core Features

- **Managed Service**: No servers to manage (unlike hosting your own GitLab).
- **Highly Available**: Data is stored in S3/DynamoDB on the backend (regional service).
- **Encryption**: Automatically encrypted at rest (KMS) and in transit (HTTPS/SSH).
- **Private**: No public repositories. Only private.

### Integration Workflow

CodeCommit acts as the **Source** stage in your release pipeline.

```text
[ Developer ] --(Git Push)--> [ CodeCommit ] --(Triggers)--> [ AWS CodePipeline ]
```

---

## 2. Authentication (HTTPS vs SSH)

To push/pull code, you need to authenticate.

### HTTPS (Recommended)

- **Git Credentials**: You generate a static _Username/Password_ in the IAM Console (Security Credentials tab).
- **Git Credential Helper**: Uses your AWS CLI profile (`aws configure`) to automatically sign requests. Best for developers.

### SSH

- **SSH Keys**: You generate an SSH Key pair (`ssh-keygen`), upload the **Public Key** to the IAM Console (Security Credentials -> Upload SSH public key), and configure your local `~/.ssh/config` to use the Private Key.

---

## 3. Security & Cross-Account Access

### How to share a repo with another AWS Account?

You **cannot** just "invite" a user like GitHub. You must use **IAM Roles**.

1.  **Account A (Repo Owner)**: Creates a Role (`RepoSharedRole`) with `codecommit:Pull` permissions. Trusted entity = Account B.
2.  **Account B (Developer)**: Assumes the Role (`sts:AssumeRole`) in Account A.
3.  **Git Access**: The developer configures their git client to use the temporary credentials from the assumed role.

---

## 4. Triggers & Notifications

- **SNS / Lambda Triggers**: You can configure CodeCommit to trigger an SNS topic or a Lambda function on events (e.g., `updateReference`, `createBranch`).
  - _Usecase_: "Send email when Master branch is pushed" (SNS).
  - _Usecase_: "Run syntax check when code is pushed" (Lambda).
- **CloudWatch Events (EventBridge)**: More modern way to react to Pull Request changes (Created, Merged, Commented).

---

## 5. Exam Cheat Sheet

- **Auth**: "Developer gets 403 trying to push" -> Check **IAM Policy** first. Then check if they are using the correct **Git Credentials** (not their AWS Console password).
- **Cross-Account**: "Share repo with external dev" -> Use **IAM Role with Cross-Account Access**.
- **Encryption**: "Code must be encrypted" -> It is **automatically encrypted** by CodeCommit.
- **Migration**: "Migrate from GitHub to CodeCommit" -> `git clone` (GitHub) -> `git push` (CodeCommit). No magic migration tool, just standard Git.
