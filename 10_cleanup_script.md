## 🧩 **Purpose**

The script is designed to:

* **Remove sensitive data** (SSH keys, AWS credentials, Git credentials, history)
* **Clean logs and temp files**
* **Remove temporary or unwanted users**
* **Lock down root access**
* **Reset configuration files**

It’s commonly used before:

* Creating a **public Amazon Machine Image (AMI)**
* **Transferring instance ownership**
* **Decommissioning** or **terminating** instances securely
* Performing **post-testing cleanup** for lab or sandbox environments

---

## 🧠 **Line-by-Line Explanation**

```bash
#!/bin/bash
```

* Defines that this script will be executed in the Bash shell.

---

### 🔑 **Remove SSH keys**

```bash
rm -rf ~/.ssh/authorized_keys
```

* Deletes all SSH keys for the current user.
* Prevents any old or unauthorized SSH logins.

**Use case:** When you want to make sure **no one (including you)** can log in via SSH after cleanup.

---

### 🔐 **Clear user credentials and history**

```bash
rm -rf ~/.aws/credentials
rm -rf ~/.git-credentials
rm -rf ~/.bash_history
```

* Removes:

  * Stored AWS credentials (access key & secret)
  * GitHub/remote Git credentials
  * Bash command history (to erase traces of past commands)

**Purpose:** Prevents exposure of **sensitive tokens and command history**.

---

### 🧹 **Clean system logs and temporary files**

```bash
rm -rf /var/log/*
rm -rf /tmp/*
rm -rf /var/tmp/*
```

* Wipes all system logs and temporary directories.
* Ensures no traces of previous activity, errors, or system access remain.

**⚠️ Caution:**
This is **dangerous** on production servers — you’ll lose:

* `/var/log/auth.log` (SSH logs)
* `/var/log/syslog`
* Application logs

Always make backups first if you need logs for auditing.

---

### 👥 **Remove user accounts**

```bash
deluser tempuser --remove-home
```

* Deletes a temporary user (named `tempuser` here) and removes their home directory.

**Use case:** Used after temporary maintenance or testing accounts are no longer needed.

---

### 🚫 **Lock root account**

```bash
passwd -l root
```

* Locks the **root account**, preventing direct root login.

**Purpose:** Enforces **least privilege** security principle — root access should be disabled after setup.

---

### ⚙️ **Reset configuration files (example for Nginx)**

```bash
rm -rf /etc/nginx/nginx.conf
```

* Removes Nginx configuration.
* Example of wiping service-specific configs before making a new AMI or resetting setup.

**Best Practice:** Instead of deleting, consider backing up:

```bash
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
```

---

## 🚨 **Important Notes**

* **Irreversible:** This script deletes data **permanently**.
* **Run only when:** You’re preparing a **final image**, or performing **system wipe**.
* **Never use on active or production systems.**
* **Run as root** for all deletions and permissions to work.

---

## 🧱 **Typical Workflow Example**

```text
[ EC2 Instance Setup ]
        |
[ Testing / Deployment Done ]
        |
[ Run Cleanup Script ]
        |
[ Create AMI or Terminate Instance ]
```

---

## 🧾 **Safer Version Example**

Here’s a safer variant that logs actions before deleting:

```bash
#!/bin/bash
LOGFILE="/var/log/cleanup.log"
echo "Cleanup started at $(date)" | tee -a $LOGFILE

# Remove sensitive files
rm -rf ~/.ssh/authorized_keys ~/.aws/credentials ~/.git-credentials ~/.bash_history

# Clean temporary directories
rm -rf /tmp/* /var/tmp/*

# Delete logs (optional)
find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

# Lock root and delete temp user
deluser tempuser --remove-home
passwd -l root

echo "Cleanup completed at $(date)" | tee -a $LOGFILE
```

---

## ✅ **Summary Table**

| Section                   | Purpose                   |
| ------------------------- | ------------------------- |
| Remove SSH keys           | Prevent future logins     |
| Clear credentials/history | Protect secrets           |
| Clean logs/temp files     | Remove traces of usage    |
| Remove user accounts      | Revoke access             |
| Lock root                 | Harden instance security  |
| Reset configs             | Prepare fresh environment |

