 # AWS region to deploy resources
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Project name for naming resources
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ec2-s3-poc"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public subnet CIDR
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Private subnet CIDR
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Availability zone
variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "us-east-1a"
}

# EC2 instance type
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Existing EC2 key pair name
variable "key_pair_name" {
  description = "terraform-poc"
  type        = string
}

# Private S3 bucket name
variable "s3_bucket_name" {
  description = "s3-poc-private-bucket"
  type        = string
}

