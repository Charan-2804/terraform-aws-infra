 # Output VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Public IP of public EC2
output "public_ec2_public_ip" {
  description = "Public IP address of the public EC2 instance"
  value       = aws_instance.public_ec2.public_ip
}

# Private IP of private EC2
output "private_ec2_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private_ec2.private_ip
}

# S3 bucket name
output "s3_bucket_name" {
  description = "Name of the private S3 bucket"
  value       = aws_s3_bucket.private_bucket.bucket
}

# SSH command for public EC2
output "public_ec2_ssh_command" {
  description = "SSH command to connect to public EC2 instance"
  value       = "ssh -i ${var.key_pair_name}.pem ec2-user@${aws_instance.public_ec2.public_ip}"
}

# SSH command to connect private EC2 via public EC2
output "ssh_via_bastion_command" {
  description = "SSH command to connect to private EC2 via public EC2"
  value       = "ssh -i ${var.key_pair_name}.pem -J ec2-user@${aws_instance.public_ec2.public_ip} ec2-user@${aws_instance.private_ec2.private_ip}"
}

# NAT Gateway public IP
output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

