terraform {
  backend "s3" {
    bucket         = "mini-dtf-project-bucket"          # Your manually created bucket
    key            = "terraform/state/terraform.tfstate" # Path inside the bucket
    region         = "us-east-1"                         # Region of your bucket
  }
}

# Null resource to upload test file from private EC2
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
    private_key  = file("Mini-dft-project-key-pem")
    bastion_host = aws_instance.public_ec2.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'This is a test file from private EC2' > /home/ec2-user/test_file.txt",
      "aws s3 cp /home/ec2-user/test_file.txt s3://${aws_s3_bucket.private_bucket.bucket}/test-files/test_file.txt"
    ]
  }
}
