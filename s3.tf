 # Create private S3 bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "${var.project_name}-private-bucket"
  }
}

# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

