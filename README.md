# 🚀 AWS CodeDeploy Project - Complete Setup Guide

## 📋 Prerequisites
- AWS Account with appropriate permissions
- GitHub account
- Basic understanding of AWS services

## 🎯 What We're Building
- EC2 instance running a web application
- Automated deployment using AWS CodeDeploy
- GitHub integration for source code management

---

## 🔷 STEP 1: Launch EC2 Instance

### 1.1 Create EC2 Instance
```bash
# Go to AWS Console → EC2 → Launch Instance
```

**Configuration:**
- **Name:** `my-codedeploy-server`
- **AMI:** Amazon Linux 2023
- **Instance Type:** t2.micro (Free tier eligible)
- **Key Pair:** Create new or use existing
- **Security Group Settings:**
  - SSH (Port 22) - Your IP
  - HTTP (Port 80) - Anywhere (0.0.0.0/0)
  - HTTPS (Port 443) - Anywhere (0.0.0.0/0)

### 1.2 Note Important Details
- **Instance ID:** `i-xxxxxxxxx`
- **Public IP:** `xx.xx.xx.xx`
- **Key Pair Name:** `your-key.pem`

---

## 🔷 STEP 2: Connect to EC2 Instance

### Option 1: Session Manager (Recommended)
```bash
# AWS Console → EC2 → Select Instance → Connect → Session Manager
```

### Option 2: SSH
```bash
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@YOUR_PUBLIC_IP
```

---

## 🔷 STEP 3: Install CodeDeploy Agent

### 3.1 Install Required Packages
```bash
# Update system
sudo yum update -y

# Install Ruby (required for CodeDeploy agent)
sudo yum install -y ruby wget
```

### 3.2 Download and Install CodeDeploy Agent
```bash
# Navigate to home directory
cd /home/ec2-user

# Download CodeDeploy agent (adjust region if needed)
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

# Make installer executable
chmod +x ./install

# Install the agent
sudo ./install auto
```

### 3.3 Start and Verify Agent
```bash
# Start the service
sudo systemctl start codedeploy-agent

# Enable auto-start on boot
sudo systemctl enable codedeploy-agent

# Check status
sudo systemctl status codedeploy-agent
```

**Expected Output:** `Active: active (running)`

---

## 🔷 STEP 4: Create IAM Roles

### 4.1 Create EC2 Service Role
```bash
# AWS Console → IAM → Roles → Create Role
```

**Configuration:**
- **Trusted Entity:** EC2
- **Policies to Attach:**
  - `AmazonEC2RoleforAWSCodeDeploy`
  - `CloudWatchAgentServerPolicy` (optional, for logging)
- **Role Name:** `CodeDeployEC2ServiceRole`

### 4.2 Create CodeDeploy Service Role
```bash
# AWS Console → IAM → Roles → Create Role
```

**Configuration:**
- **Trusted Entity:** CodeDeploy
- **Use Case:** CodeDeploy
- **Policies:** (Auto-selected)
  - `AWSCodeDeployRole`
- **Role Name:** `CodeDeployServiceRole`

### 4.3 Attach Role to EC2 Instance
```bash
# EC2 Console → Select Instance → Actions → Security → Modify IAM Role
# Select: CodeDeployEC2ServiceRole
```

---

## 🔷 STEP 5: Create CodeDeploy Application

### 5.1 Create Application
```bash
# AWS Console → CodeDeploy → Applications → Create Application
```

**Configuration:**
- **Application Name:** `my-web-app`
- **Compute Platform:** EC2/On-premises

### 5.2 Create Deployment Group
```bash
# Click on your application → Create Deployment Group
```

**Configuration:**
- **Deployment Group Name:** `production-deployment-group`
- **Service Role:** `CodeDeployServiceRole`
- **Deployment Type:** In-place
- **Environment Configuration:** 
  - Amazon EC2 instances
  - **Tag:** Name = `my-codedeploy-server`
- **Load Balancer:** Disable (for this demo)

---

## 🔷 STEP 6: Setup GitHub Repository

### 6.1 Create Repository
1. Go to GitHub and create a new repository
2. Name it: `aws-codedeploy-demo`
3. Make it public (easier for this demo)

### 6.2 Upload Project Files
The following files are already created in this project:
- `index.html` - Main web page
- `appspec.yml` - CodeDeploy configuration
- `scripts/install_dependencies.sh` - Install Apache
- `scripts/start_server.sh` - Start web server

### 6.3 Push to GitHub
```bash
# Initialize git repository
git init

# Add all files
git add .

# Commit files
git commit -m "Initial commit: AWS CodeDeploy demo application"

# Add remote origin (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/aws-codedeploy-demo.git

# Push to GitHub
git push -u origin main
```

---

## 🔷 STEP 7: Create Deployment

### 7.1 Start New Deployment
```bash
# CodeDeploy Console → Applications → my-web-app → Create Deployment
```

**Configuration:**
- **Deployment Group:** `production-deployment-group`
- **Revision Type:** My application is stored in GitHub
- **GitHub Token Name:** Create new token
- **Repository Name:** `YOUR_USERNAME/aws-codedeploy-demo`
- **Commit ID:** Use latest commit or leave blank for latest

### 7.2 Monitor Deployment
- Watch the deployment status in real-time
- Check lifecycle events:
  - ✅ ApplicationStop
  - ✅ BeforeInstall
  - ✅ Install
  - ✅ AfterInstall
  - ✅ ApplicationStart

---

## 🔷 STEP 8: Test Your Application

### 8.1 Access Your Web Application
```bash
# Open in browser
http://YOUR_EC2_PUBLIC_IP
```

**Expected Result:** 
🚀 Beautiful web page with "Hello from AWS CodeDeploy!" message

### 8.2 Verify Apache is Running
```bash
# SSH into EC2 and check
sudo systemctl status httpd
curl localhost
```

---

## 🎉 SUCCESS! Your Application is Live!

## 🔄 Making Updates

To deploy updates:
1. Modify your code
2. Commit and push to GitHub
3. Create new deployment in CodeDeploy
4. Watch automatic deployment happen!

---

## 🛠️ Troubleshooting

### Common Issues:

**1. CodeDeploy Agent Not Running**
```bash
sudo systemctl restart codedeploy-agent
sudo systemctl status codedeploy-agent
```

**2. Permission Denied Errors**
```bash
# Check IAM roles are properly attached
# Verify security group allows HTTP traffic
```

**3. Deployment Failed**
```bash
# Check deployment logs in CodeDeploy console
# Verify appspec.yml syntax
# Check script permissions (chmod +x)
```

**4. Apache Not Starting**
```bash
sudo systemctl status httpd
sudo journalctl -u httpd
```

---

## 📚 What You Learned

✅ **EC2 Instance Management**
✅ **IAM Roles and Policies**
✅ **AWS CodeDeploy Configuration**
✅ **GitHub Integration**
✅ **Automated Deployment Pipeline**
✅ **Web Server Configuration**

## 🚀 Next Steps

- Add CodePipeline for full CI/CD
- Implement Blue/Green deployments
- Add CloudWatch monitoring
- Set up auto-scaling groups
- Implement database integration

---

**Happy Deploying! 🎯**