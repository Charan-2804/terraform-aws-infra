terraform {
  backend "s3" {
    bucket         = "mini-dtf-project-bucket"   # Replace with your S3 bucket name
    key            = "Mini-dft-project-key/terraform.tfstate"  # Path inside the bucket
    region         = "us-east-1"                      # Your AWS region
      
  }
}
