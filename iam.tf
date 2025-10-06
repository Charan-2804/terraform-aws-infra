# IAM Role for Private EC2 to access S3
resource "aws_iam_role" "private_ec2_s3_role" {
  name = "${var.project_name}-private-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-private-ec2-s3-role"
  }
}

# IAM Policy for S3 access (private bucket only)
resource "aws_iam_policy" "private_s3_policy" {
  name        = "${var.project_name}-private-s3-policy"
  description = "Allow private EC2 to access private S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# Attach policy to the private EC2 role
resource "aws_iam_role_policy_attachment" "private_ec2_s3_attach" {
  role       = aws_iam_role.private_ec2_s3_role.name
  policy_arn = aws_iam_policy.private_s3_policy.arn
}

# Instance profile for private EC2
resource "aws_iam_instance_profile" "private_ec2_instance_profile" {
  name = "${var.project_name}-private-ec2-instance-profile"
  role = aws_iam_role.private_ec2_s3_role.name
}
