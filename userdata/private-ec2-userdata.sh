    #!/bin/bash
# User data for private EC2

# Update packages
yum update -y

# Install common tools
yum install -y awscli python3 python3-pip git jq unzip

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --update

# Create scripts directory
mkdir -p /home/ec2-user/scripts

# Script to test S3 access
cat << 'EOF' > /home/ec2-user/scripts/test_s3.sh
#!/bin/bash
BUCKET_NAME="${s3_bucket_name}"

echo "Testing S3 access to bucket: $BUCKET_NAME"

# Create bucket if not exists
aws s3 mb s3://$BUCKET_NAME || echo "Bucket already exists"

# Create test file
echo "This is a test file from private EC2 instance at $(date)" > /home/ec2-user/test_file.txt

# Upload file to S3
aws s3 cp /home/ec2-user/test_file.txt s3://$BUCKET_NAME/test-files/

# List files
aws s3 ls s3://$BUCKET_NAME/test-files/ || echo "No files found"

echo "S3 test completed!"
EOF

chmod +x /home/ec2-user/scripts/test_s3.sh
chown -R ec2-user:ec2-user /home/ec2-user/scripts

echo "Private EC2 instance setup complete!"

