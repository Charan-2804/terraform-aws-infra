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
  region = "us-east-1"
}
