# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create public EC2 instance
resource "aws_instance" "public_ec2" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = filebase64("${path.module}/userdata/public-ec2-userdata.sh")

  tags = {
    Name = "${var.project_name}-public-ec2"
  }

  depends_on = [aws_internet_gateway.main]
}

# Create private EC2 instance
resource "aws_instance" "private_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.ec2_instance_type
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = filebase64("${path.module}/userdata/private-ec2-userdata.sh")

  tags = {
    Name = "${var.project_name}-private-ec2"
  }

  depends_on = [aws_nat_gateway.main]
}