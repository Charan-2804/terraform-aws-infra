terraform {
  backend "s3" {
    bucket         = "s3-poc-s3"   # Replace with your S3 bucket name
    key            = "ec2-s3-poc/terraform.tfstate"  # Path inside the bucket
    region         = "us-east-1"                      # Your AWS region
      
  }
}
