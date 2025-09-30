 # Security group for public EC2 (Bastion host)
resource "aws_security_group" "public_ec2_sg" {
  name        = "${var.project_name}-public-ec2-sg"
  description = "Security group for public EC2 instance"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-public-ec2-sg"
  }
}

# Security group for private EC2
resource "aws_security_group" "private_ec2_sg" {
  name        = "${var.project_name}-private-ec2-sg"
  description = "Security group for private EC2 instance"
  vpc_id      = aws_vpc.main.id

  # Allow SSH only from public EC2 (bastion)
  ingress {
    description     = "SSH access from public EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-private-ec2-sg"
  }
}

