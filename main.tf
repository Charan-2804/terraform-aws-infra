terraform {
  backend "s3" {
    bucket = "s3-poc-s3"
    key    = "ec2-s3-poc/terraform.tfstate"
    region = "us-east-1"
  }
}

# -------------------------
# Null resource to upload test file from private EC2
# -------------------------
resource "null_resource" "upload_test_file" {
  depends_on = [
    aws_instance.private_ec2,
    aws_instance.public_ec2,
    aws_s3_bucket.private_bucket
  ]

  connection {
    type         = "ssh"
    host         = aws_instance.private_ec2.private_ip
    user         = "ec2-user"
    private_key  = file("terraform-poc.pem")       # PEM file in Jenkins workspace
    bastion_host = aws_instance.public_ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'This is a test file from private EC2 at $(date)' > /home/ec2-user/test_file.txt",
      "aws s3 cp /home/ec2-user/test_file.txt s3://${aws_s3_bucket.private_bucket.id}/test-files/test_file.txt"
    ]
  }
}
