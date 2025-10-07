# IAM Policy for EC2 instances to access private S3 bucket
resource "aws_iam_policy" "private_s3_policy" {
  name        = "ec2-s3-poc-private-s3-policy"
  description = "Allow EC2 to read/write to the private S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}/*"
        ]
      }
    ]
  })
}

# Attach policy to private EC2 role
resource "aws_iam_role_policy_attachment" "private_ec2_s3_attach" {
  role       = aws_iam_role.private_ec2_s3_role.name
  policy_arn = aws_iam_policy.private_s3_policy.arn
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "private_ec2_instance_profile" {
  name = "${var.project_name}-private-ec2-instance-profile"
  role = aws_iam_role.private_ec2_s3_role.name
}
