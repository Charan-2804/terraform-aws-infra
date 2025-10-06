terraform {
  backend "s3" {
    bucket = "s3-poc-s3"   # Replace with your S3 bucket name
    key    = "ec2-s3-poc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Existing resources here:
# aws_instance.public_ec2, aws_instance.private_ec2, aws_s3_bucket.private_bucket, etc.

# -------------------------
# New: Upload test file from private EC2 using null_resource
# -------------------------
resource "null_resource" "upload_test_file" {
  depends_on = [
    aws_instance.private_ec2,
    aws_instance.public_ec2,
    aws_s3_bucket.private_bucket
  ]

  connection {
    type        = "ssh"
    host        = aws_instance.private_ec2.private_ip      # Private EC2
    user        = "ec2-user"
    private_key = file("terraform-poc.pem")                # PEM file in Jenkins workspace
    bastion_host = aws_instance.public_ec2.public_ip       # Public EC2 as bastion
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'This is a test file from private EC2 at $(date)' > /home/ec2-user/test_file.txt",
      "aws s3 cp /home/ec2-user/test_file.txt s3://${aws_s3_bucket.private_bucket.id}/test-files/test_file.txt"
    ]
  }
}

output "private_ec2_private_ip" {
  value = aws_instance.private_ec2.private_ip
}

output "public_ec2_public_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.private_bucket.id
}
