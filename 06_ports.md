# 🔑 Important Ports and Protocols

These ports are commonly used in AWS Security Groups, networking, and system administration.

---

## 🌐 Web Traffic
- **HTTP (Port 80)**  
  - Protocol: TCP  
  - Use: Unencrypted web traffic (insecure websites).  
  - Example: `http://example.com`

- **HTTPS (Port 443)**  
  - Protocol: TCP  
  - Use: Encrypted web traffic with SSL/TLS.  
  - Example: `https://example.com`

---

## 🔐 Remote Access
- **SSH (Port 22)**  
  - Protocol: TCP  
  - Use: Secure remote login to Linux/Unix servers.  
  - Example: `ssh user@ip`

- **RDP (Port 3389)**  
  - Protocol: TCP  
  - Use: Remote Desktop access for Windows servers.  
  - Example: Windows Remote Desktop Client

---

## 📂 File Transfer
- **FTP (Port 21)**  
  - Protocol: TCP  
  - Use: File Transfer Protocol (insecure, plain text).  
  - ⚠️ Should be avoided in favor of SFTP/FTPS.

- **SFTP (Port 22)**  
  - Protocol: TCP  
  - Use: Secure File Transfer over SSH.  
  - Example: `sftp user@ip`

---

## 📧 Email
- **SMTP (Port 25)**  
  - Protocol: TCP  
  - Use: Sending emails (Simple Mail Transfer Protocol).  
  - Note: Often blocked by ISPs to prevent spam.  
  - Alternatives:  
    - Port 465 (SMTP over SSL)  
    - Port 587 (SMTP with STARTTLS)

---

## 🗄️ Databases
- **MySQL (Port 3306)**  
  - Protocol: TCP  
  - Use: Connections to MySQL databases.

- **PostgreSQL (Port 5432)**  
  - Protocol: TCP  
  - Use: Connections to PostgreSQL databases.

---

## 🌍 Networking Services
- **DNS (Port 53)**  
  - Protocol: TCP/UDP  
  - Use: Domain Name System → Resolves domain names to IP addresses.  
  - UDP 53 → Standard queries (fast, lightweight).  
  - TCP 53 → Zone transfers and large responses.

---

## 📌 Quick Reference Table

| Service       | Port | Protocol | Description                                |
|---------------|------|----------|--------------------------------------------|
| HTTP          | 80   | TCP      | Unencrypted web traffic                    |
| HTTPS         | 443  | TCP      | Encrypted web traffic (SSL/TLS)            |
| SSH           | 22   | TCP      | Secure remote access (Linux/Unix)          |
| FTP           | 21   | TCP      | File transfer (insecure)                   |
| SFTP          | 22   | TCP      | Secure file transfer over SSH              |
| SMTP          | 25   | TCP      | Email sending (unsecured)                  |
| RDP           | 3389 | TCP      | Remote Desktop for Windows                 |
| MySQL         | 3306 | TCP      | MySQL database connections                 |
| PostgreSQL    | 5432 | TCP      | PostgreSQL database connections            |
| DNS           | 53   | TCP/UDP  | Domain Name System (queries & zone transfer)|

---

## 🔹 Notes
- Always restrict access to sensitive ports (22, 3389, 3306, 5432) in **Security Groups**.  
- Use **VPNs or bastion hosts** instead of opening admin ports to the internet.  
- For web servers, 80 and 443 are the most commonly opened ports.  
- Some services may use **alternative ports** for better security.  
