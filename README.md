# Terraform AWS Infrastructure

## 📌 Overview
This project demonstrates how to use **Terraform** to provision AWS infrastructure in an automated, reproducible, and scalable way.  
The setup includes EC2 instances, S3 bucket, IAM roles, VPC, and security groups to showcase **Infrastructure as Code (IaC)** principles.

---

## 🛠️ Resources Created
- **VPC** with public and private subnets  
- **EC2 Instances** (public & private) with user data scripts  
- **S3 Bucket** for storage  
- **IAM Roles & Policies** for secure access  
- **Security Groups** for controlled inbound/outbound traffic  

---

## 📂 Project Structure
```
├── ec2.tf                  
├── iam.tf                  
├── main.tf                 
├── outputs.tf              
├── provider.tf             
├── s3.tf                   
├── security_groups.tf      
├── terraform.tfvars        
├── variables.tf            
├── vpc.tf                  
└── userdata/               
```

---

## 🚀 How to Deploy
1. **Clone this repo**:
   ```bash
   git clone https://github.com/Charan-2804/terraform-aws-infra.git
   cd terraform-aws-infra
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Preview the changes**:
   ```bash
   terraform plan
   ```

4. **Apply configuration**:
   ```bash
   terraform apply
   ```

---

## 🔐 Prerequisites
- AWS account with programmatic access  
- Terraform installed (`>=1.5.x`)  
- IAM credentials configured locally (`aws configure`)  

---

## 📖 Concepts Highlighted
- Infrastructure as Code (IaC) using Terraform  
- Modularity with `.tf` configuration files  
- Secure cloud provisioning with IAM & security groups  
- Public–private EC2 networking setup  

---

## 🏆 Learning Outcome
This project demonstrates practical **DevOps & Cloud skills** by automating AWS resource provisioning with Terraform, preparing for real-world cloud infrastructure deployment.

---

## 🌟 Future Enhancements
- Add **RDS database** for backend storage  
- Configure **Load Balancer + Auto Scaling** for EC2  
- Modularize Terraform configurations for better maintainability  
- Integrate with **CI/CD pipelines** (Jenkins/GitHub Actions)  
- Add **monitoring & alerts** using CloudWatch or SNS  

