# 🌐 Practical 5: Deploy Static Website on S3 and Dynamic Website on EC2

## 🎯 Objective
Host a static site on S3 + CloudFront (optional) and deploy a dynamic website on EC2 with security group, Elastic IP, and optional Load Balancer.

## 📋 Prerequisites
- AWS account with appropriate permissions
- Basic HTML/CSS files for static site
- Node.js application code for dynamic site
- Domain name (optional)

---

## 📄 Part A: Static Website on S3

### 1. Create S3 Bucket for Website

1. **Create Bucket**
   - S3 Console → Create bucket
   - Bucket name: `yourdomain.com` (or unique name)
   - Region: Choose appropriate region
   - **Important**: Bucket name must be globally unique

2. **Bucket Configuration**
   - Object Ownership: **ACLs disabled** (recommended)
   - Block Public Access: **Uncheck all** (for website hosting only)
   - Versioning: Enable (optional)
   - Encryption: Server-side encryption (optional)

### 2. Enable Static Website Hosting

1. **Configure Website Hosting**
   - Bucket → Properties → Static website hosting
   - **Enable** static website hosting
   - Hosting type: **Host a static website**
   - Index document: `index.html`
   - Error document: `error.html`

2. **Note the Endpoint**
   - Copy the bucket website endpoint URL
   - Format: `http://bucket-name.s3-website-region.amazonaws.com`

### 3. Create Website Files

**Create `index.html`:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Static Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255,255,255,0.1);
            padding: 30px;
            border-radius: 10px;
            text-align: center;
        }
        .feature {
            background: rgba(255,255,255,0.2);
            margin: 20px 0;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to My Static Website</h1>
        <p>Hosted on Amazon S3</p>
        
        <div class="feature">
            <h3>✨ Features</h3>
            <ul>
                <li>Fast global delivery</li>
                <li>99.999999999% durability</li>
                <li>Cost-effective hosting</li>
                <li>Easy to maintain</li>
            </ul>
        </div>
        
        <div class="feature">
            <h3>🔗 Links</h3>
            <p><a href="about.html" style="color: #fff;">About Page</a></p>
            <p><a href="contact.html" style="color: #fff;">Contact Page</a></p>
        </div>
        
        <p><small>Last updated: <span id="date"></span></small></p>
    </div>
    
    <script>
        document.getElementById('date').textContent = new Date().toLocaleDateString();
    </script>
</body>
</html>
```

**Create `error.html`:**
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Not Found</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background: #f0f0f0;
        }
        .error-container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>🚫 404 - Page Not Found</h1>
        <p>The page you're looking for doesn't exist.</p>
        <a href="index.html">← Back to Home</a>
    </div>
</body>
</html>
```

### 4. Upload Files and Set Permissions

1. **Upload Files**
   - Drag and drop files to S3 bucket
   - Or use S3 Console → Upload

2. **Set Bucket Policy**
   - Bucket → Permissions → Bucket policy
   - Add the following policy:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```

### 5. Test Static Website

1. **Access Website**
   - Open the S3 website endpoint URL
   - Verify all pages load correctly
   - Test error page by accessing non-existent URL

---

## ☁️ Part A (Optional): Add CloudFront CDN

### 1. Create CloudFront Distribution

1. **CloudFront Console**
   - CloudFront → Create distribution

2. **Origin Settings**
   - Origin domain: S3 website endpoint (not bucket name)
   - Protocol: HTTP only (for S3 website endpoint)

3. **Default Cache Behavior**
   - Viewer protocol policy: **Redirect HTTP to HTTPS**
   - Allowed HTTP methods: GET, HEAD
   - Cache policy: **Managed-CachingOptimized**

4. **Distribution Settings**
   - Price class: **Use all edge locations** (or select regions)
   - Default root object: `index.html`

### 2. Configure Custom Domain (Optional)

1. **Add CNAME**
   - Alternate domain names: `www.yourdomain.com`
   - SSL certificate: Request or import certificate

2. **Update DNS**
   - Point domain CNAME to CloudFront distribution domain

---

## 🖥️ Part B: Dynamic Website on EC2

### 1. Launch EC2 Instance

1. **Instance Configuration**
   - AMI: Amazon Linux 2
   - Instance type: `t2.micro` (free tier)
   - Key pair: Select or create new

2. **Network Settings**
   - VPC: Default or custom VPC
   - Subnet: Public subnet
   - Auto-assign public IP: **Enable**

3. **Security Group**
   - Create new security group: `web-server-sg`
   - Rules:
     ```
     SSH (22)    - Your IP/32
     HTTP (80)   - 0.0.0.0/0
     HTTPS (443) - 0.0.0.0/0
     ```

### 2. Allocate Elastic IP

1. **Create Elastic IP**
   - EC2 → Elastic IPs → Allocate Elastic IP address
   - Network Border Group: Default

2. **Associate with Instance**
   - Select Elastic IP → Actions → Associate Elastic IP address
   - Instance: Select your EC2 instance

### 3. Install Web Server and Application

1. **Connect to Instance**
   ```bash
   ssh -i your-key.pem ec2-user@<elastic-ip>
   ```

2. **Install Node.js and Dependencies**
   ```bash
   # Update system
   sudo yum update -y
   
   # Install Git
   sudo yum install -y git
   
   # Install Node.js 18
   curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
   sudo yum install -y nodejs
   
   # Verify installation
   node --version
   npm --version
   ```

### 4. Deploy Dynamic Application

1. **Create Application Directory**
   ```bash
   mkdir ~/my-app
   cd ~/my-app
   ```

2. **Create Dynamic Web Application**

**Create `server.js`:**
```javascript
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 80;

// Middleware
app.use(express.static('public'));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Dynamic Website on EC2</title>
            <style>
                body { 
                    font-family: Arial, sans-serif; 
                    max-width: 800px; 
                    margin: 0 auto; 
                    padding: 20px;
                    background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
                    color: white;
                }
                .container {
                    background: rgba(255,255,255,0.1);
                    padding: 30px;
                    border-radius: 10px;
                }
                .info-box {
                    background: rgba(255,255,255,0.2);
                    padding: 15px;
                    margin: 15px 0;
                    border-radius: 5px;
                }
                button {
                    background: #00b894;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 5px;
                    cursor: pointer;
                    margin: 5px;
                }
                button:hover { background: #00a085; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🚀 Dynamic Website on EC2</h1>
                <p>Server Time: ${new Date().toISOString()}</p>
                
                <div class="info-box">
                    <h3>📊 Server Information</h3>
                    <p>Node.js Version: ${process.version}</p>
                    <p>Platform: ${process.platform}</p>
                    <p>Uptime: ${Math.floor(process.uptime())} seconds</p>
                </div>
                
                <div class="info-box">
                    <h3>🔗 API Endpoints</h3>
                    <button onclick="fetchData('/api/status')">Check Status</button>
                    <button onclick="fetchData('/api/time')">Get Time</button>
                    <button onclick="fetchData('/api/system')">System Info</button>
                </div>
                
                <div id="result" class="info-box" style="display:none;">
                    <h3>📋 API Response</h3>
                    <pre id="response"></pre>
                </div>
            </div>
            
            <script>
                async function fetchData(endpoint) {
                    try {
                        const response = await fetch(endpoint);
                        const data = await response.json();
                        document.getElementById('response').textContent = JSON.stringify(data, null, 2);
                        document.getElementById('result').style.display = 'block';
                    } catch (error) {
                        document.getElementById('response').textContent = 'Error: ' + error.message;
                        document.getElementById('result').style.display = 'block';
                    }
                }
            </script>
        </body>
        </html>
    `);
});

// API Routes
app.get('/api/status', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        server: 'EC2 Dynamic Website'
    });
});

app.get('/api/time', (req, res) => {
    res.json({
        serverTime: new Date().toISOString(),
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        uptime: process.uptime()
    });
});

app.get('/api/system', (req, res) => {
    res.json({
        nodeVersion: process.version,
        platform: process.platform,
        architecture: process.arch,
        memory: process.memoryUsage(),
        cpuUsage: process.cpuUsage()
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK' });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
```

**Create `package.json`:**
```json
{
  "name": "ec2-dynamic-website",
  "version": "1.0.0",
  "description": "Dynamic website running on EC2",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

3. **Install Dependencies and Start Application**
   ```bash
   # Install dependencies
   npm install
   
   # Start application (requires sudo for port 80)
   sudo npm start
   ```

### 5. Configure Application as Service

1. **Create Systemd Service**
   ```bash
   sudo nano /etc/systemd/system/webapp.service
   ```

2. **Service Configuration**
   ```ini
   [Unit]
   Description=Dynamic Web Application
   After=network.target
   
   [Service]
   Type=simple
   User=ec2-user
   WorkingDirectory=/home/ec2-user/my-app
   ExecStart=/usr/bin/node server.js
   Restart=on-failure
   Environment=PORT=80
   Environment=NODE_ENV=production
   
   [Install]
   WantedBy=multi-user.target
   ```

3. **Enable and Start Service**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable webapp
   sudo systemctl start webapp
   sudo systemctl status webapp
   ```

---

## 🔧 Part C: Advanced Configuration (Optional)

### 1. Add HTTPS with Let's Encrypt

1. **Install Certbot**
   ```bash
   sudo yum install -y certbot
   ```

2. **Install Nginx as Reverse Proxy**
   ```bash
   sudo yum install -y nginx
   
   # Configure Nginx
   sudo nano /etc/nginx/nginx.conf
   ```

3. **Nginx Configuration**
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### 2. Application Load Balancer (Optional)

1. **Create Target Group**
   - EC2 → Target Groups → Create target group
   - Target type: Instances
   - Protocol: HTTP, Port: 80
   - Health check path: `/health`

2. **Create Application Load Balancer**
   - EC2 → Load Balancers → Create load balancer
   - Type: Application Load Balancer
   - Scheme: Internet-facing
   - Listeners: HTTP:80, HTTPS:443 (if certificate available)

---

## ✅ Verification Checklist

### Static Website (S3)
- [ ] S3 bucket created with website hosting enabled
- [ ] Website files uploaded successfully
- [ ] Bucket policy allows public read access
- [ ] Website accessible via S3 endpoint
- [ ] Error page displays for invalid URLs
- [ ] CloudFront distribution created (optional)

### Dynamic Website (EC2)
- [ ] EC2 instance launched with proper security group
- [ ] Elastic IP allocated and associated
- [ ] Node.js and dependencies installed
- [ ] Application running and accessible
- [ ] API endpoints responding correctly
- [ ] Service configured for auto-start
- [ ] HTTPS configured (optional)

---

## 🔧 Troubleshooting Guide

### Static Website Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| 403 Forbidden | Access denied error | Check bucket policy and public access settings |
| 404 Not Found | Page not found | Verify index.html exists and bucket policy is correct |
| Mixed content warnings | HTTPS issues | Use CloudFront with SSL certificate |

### Dynamic Website Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| Connection refused | Can't access website | Check security group allows HTTP/HTTPS |
| Application crashes | 502/503 errors | Check application logs: `sudo journalctl -u webapp` |
| Port permission denied | Can't bind to port 80 | Run with sudo or use port > 1024 |

---

## 🎓 Key Learning Points

### Static vs Dynamic Websites
1. **Static (S3)**: Fast, cheap, scalable for content that doesn't change
2. **Dynamic (EC2)**: Interactive, database-driven, server-side processing

### Architecture Patterns
1. **S3 + CloudFront**: Global content delivery
2. **EC2 + ELB**: Scalable application hosting
3. **Hybrid**: Static assets on S3, dynamic API on EC2

### Cost Optimization
1. **S3**: Pay only for storage and requests
2. **CloudFront**: Reduces S3 costs and improves performance
3. **EC2**: Right-size instances, use Reserved Instances for production

---

## 📚 Additional Resources

- [S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [Application Load Balancer Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)