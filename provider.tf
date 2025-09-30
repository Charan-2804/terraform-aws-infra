 # Specify Terraform version and required AWS provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS provider with region and default tags
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ec2-s3-poc"  # Project tag for resources
      Environment = "poc"          # Environment tag
      Terraform   = "true"         # Indicates resource is managed by Terraform
    }
  }
}

