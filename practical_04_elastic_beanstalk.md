# 🚀 Practical 4: Deploy Web Application Using AWS Elastic Beanstalk

## 🎯 Objective
Deploy a simple Node.js (or static) web app, update app versions, and view logs/health monitoring.

## 📋 Prerequisites
- AWS account with appropriate permissions
- Small app repository (sample Node app) zipped or in GitHub
- Basic understanding of web applications
- Text editor for code modifications

---

## 📦 Step A: Prepare Your Application

### 1. Create Simple Node.js Application

**Create `server.js`:**
```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello from Elastic Beanstalk!</h1>
    <p>Version: 1.0</p>
    <p>Environment: ${process.env.NODE_ENV || 'development'}</p>
    <p>Port: ${port}</p>
  `);
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0'
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

**Create `package.json`:**
```json
{
  "name": "beanstalk-demo-app",
  "version": "1.0.0",
  "description": "Simple Node.js app for Elastic Beanstalk",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "engines": {
    "node": ">=14.0.0"
  }
}
```

### 2. Create Application Package

1. **Create ZIP file**
   ```bash
   # Include only necessary files
   zip -r app.zip server.js package.json
   ```

2. **Alternative: Use Git Repository**
   - Push code to GitHub repository
   - Beanstalk can deploy directly from Git

---

## 🏗️ Step B: Deploy with Elastic Beanstalk

### 1. Create Beanstalk Application

1. **Navigate to Elastic Beanstalk**
   - AWS Console → Elastic Beanstalk
   - Click **Create application**

2. **Application Configuration**
   - Application name: `my-web-app`
   - Description: `Demo web application for learning`

### 2. Create Environment

1. **Environment Settings**
   - Environment tier: **Web server environment**
   - Environment name: `my-web-app-env`
   - Domain: `my-web-app-env` (will be auto-generated)

2. **Platform Configuration**
   - Platform: **Node.js**
   - Platform branch: **Node.js 18 running on 64bit Amazon Linux 2**
   - Platform version: **Latest**

3. **Application Code**
   - **Upload your code**: Select `app.zip`
   - Or **Sample application** for quick start

4. **Presets (Optional)**
   - **Single instance (free tier eligible)** for learning
   - **High availability** for production workloads

### 3. Configure Environment (Advanced)

1. **Configuration Options**
   - **Capacity**: Single instance or Auto Scaling
   - **Load balancer**: Application Load Balancer (if HA)
   - **Rolling deployments**: For zero-downtime updates
   - **Environment variables**: Set NODE_ENV=production

2. **Monitoring**
   - **Health reporting**: Enhanced
   - **Health check URL**: `/health`
   - **Ignore health check**: Unchecked

---

## 🚀 Step C: Deploy and Monitor

### 1. Initial Deployment

1. **Create Environment**
   - Click **Create environment**
   - Wait for deployment (5-10 minutes)
   - Status should become **Ok** (green)

2. **Access Application**
   - Click on environment URL
   - Should see "Hello from Elastic Beanstalk!" message

### 2. Monitor Application Health

1. **Dashboard Overview**
   - Health status indicator
   - Recent events log
   - Application versions

2. **Health Monitoring**
   - Navigate to **Health** tab
   - View instance health status
   - Check health check results

---

## 🔄 Step D: Update Application Version

### 1. Modify Application Code

**Update `server.js`:**
```javascript
app.get('/', (req, res) => {
  res.send(`
    <h1>Hello from Elastic Beanstalk - Updated!</h1>
    <p>Version: 2.0</p>
    <p>Environment: ${process.env.NODE_ENV || 'development'}</p>
    <p>Port: ${port}</p>
    <p>Last Updated: ${new Date().toISOString()}</p>
  `);
});
```

### 2. Deploy New Version

1. **Create New ZIP**
   ```bash
   zip -r app-v2.zip server.js package.json
   ```

2. **Upload New Version**
   - Environment → **Upload and deploy**
   - Choose `app-v2.zip`
   - Version label: `v2.0`
   - Click **Deploy**

3. **Monitor Deployment**
   - Watch deployment progress in events
   - Verify new version is live

---

## 📊 Step E: View Logs and Troubleshooting

### 1. Application Logs

1. **Request Logs**
   - Environment → **Logs** → **Request logs**
   - **Last 100 lines** for quick check
   - **Full logs** for complete analysis

2. **Download Logs**
   ```bash
   # Logs include:
   # - Application logs (/var/log/nodejs/nodejs.log)
   # - Web server logs (/var/log/nginx/access.log)
   # - System logs (/var/log/eb-engine.log)
   ```

### 2. Health and Monitoring

1. **Health Dashboard**
   - Overall health status
   - Instance health details
   - Recent health transitions

2. **CloudWatch Integration**
   - Automatic metrics collection
   - Custom application metrics
   - Alarms and notifications

---

## 🔧 Step F: Configuration Management

### 1. Environment Variables

1. **Set Environment Variables**
   - Configuration → **Software**
   - Environment properties:
     ```
     NODE_ENV = production
     API_URL = https://api.example.com
     DEBUG_MODE = false
     ```

### 2. Scaling Configuration

1. **Auto Scaling Settings**
   - Configuration → **Capacity**
   - Instance type: `t3.micro` (free tier)
   - Min instances: 1
   - Max instances: 4
   - Scaling triggers: CPU utilization > 70%

---

## 🧪 Step G: Testing and Validation

### 1. Application Testing

```bash
# Test main endpoint
curl https://your-app-url.region.elasticbeanstalk.com/

# Test health endpoint
curl https://your-app-url.region.elasticbeanstalk.com/health

# Load testing (optional)
ab -n 1000 -c 10 https://your-app-url.region.elasticbeanstalk.com/
```

### 2. Deployment Testing

1. **Rolling Deployment Test**
   - Deploy new version
   - Monitor for zero downtime
   - Verify gradual instance updates

2. **Rollback Test**
   - Application versions → Previous version
   - Click **Deploy**
   - Verify rollback successful

---

## ✅ Verification Checklist

### Deployment Verification
- [ ] Application deployed successfully
- [ ] Environment status shows "Ok" (green)
- [ ] Application accessible via provided URL
- [ ] Health check endpoint responding

### Version Management
- [ ] New version deployed successfully
- [ ] Version history visible in console
- [ ] Rollback functionality tested
- [ ] Zero-downtime deployment achieved

### Monitoring and Logs
- [ ] Application logs accessible
- [ ] Health monitoring configured
- [ ] CloudWatch metrics available
- [ ] Error handling working properly

---

## 🔧 Troubleshooting Guide

### Common Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| Deployment fails | Red health status | Check application logs for errors |
| App not accessible | 502/503 errors | Verify app listens on correct port (process.env.PORT) |
| Health check fails | Degraded health | Ensure /health endpoint exists and responds |
| Version update fails | Deployment stuck | Check for syntax errors in new code |

### Port Configuration Issues

**Common Problem:**
```javascript
// ❌ Wrong - hardcoded port
app.listen(3000, () => {
  console.log('Server running on port 3000');
});

// ✅ Correct - use environment port
const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

### Log Analysis

1. **Check Application Logs**
   ```bash
   # Look for common errors:
   # - Port binding issues
   # - Missing dependencies
   # - Application crashes
   # - Health check failures
   ```

2. **Web Server Logs**
   ```bash
   # Nginx access logs show:
   # - Request patterns
   # - Response codes
   # - Performance metrics
   ```

---

## 🎓 Key Learning Points

### Elastic Beanstalk Benefits
1. **Easy Deployment**: Upload code and deploy
2. **Auto Scaling**: Handles traffic spikes automatically
3. **Health Monitoring**: Built-in application health checks
4. **Version Management**: Easy rollbacks and updates
5. **Integration**: Works with other AWS services

### Best Practices
1. **Environment Variables**: Use for configuration
2. **Health Checks**: Implement proper health endpoints
3. **Logging**: Use structured logging for debugging
4. **Rolling Deployments**: Enable for zero downtime
5. **Monitoring**: Set up CloudWatch alarms

---

## 📚 Additional Resources

- [AWS Elastic Beanstalk Developer Guide](https://docs.aws.amazon.com/elasticbeanstalk/)
- [Node.js Platform Guide](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_nodejs.html)
- [Beanstalk Best Practices](https://aws.amazon.com/elasticbeanstalk/best-practices/)
- [Troubleshooting Guide](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/troubleshooting.html)