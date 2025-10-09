# Fetch latest Amazon Linux 2 AMI in us-west-1
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

# Create public EC2 instance
resource "aws_instance" "ec2_public" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.ec2_instance_type
  key_name                    = "Mini-dft-project-key"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true
  user_data                   = filebase64("${path.module}/userdata/public-ec2-userdata.sh")

  tags = {
    Name = "${var.project_name}-public-ec2"
  }

  depends_on = [aws_internet_gateway.main]
}

# Create private EC2 instance
resource "aws_instance" "ec2_private" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = "Mini-dft-project-key"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.private_ec2_instance_profile.name

  user_data = base64encode(templatefile("${path.module}/userdata/private-ec2-userdata.sh", {
    s3_bucket_name = aws_s3_bucket.private_bucket.bucket
  }))

  tags = {
    Name = "${var.project_name}-private-ec2"
  }

  depends_on = [aws_nat_gateway.main]
}
