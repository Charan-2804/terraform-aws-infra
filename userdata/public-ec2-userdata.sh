#!/bin/bash
# User data for public EC2 (Bastion host)

# Update all packages
yum update -y

# Install amazon-linux-extras and EPEL
yum install -y amazon-linux-extras
amazon-linux-extras install -y epel

# Install common tools
yum install -y awscli python3 python3-pip git jq telnet unzip

# Install latest AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install --update

# Create scripts directory
mkdir -p /home/ec2-user/scripts

# Script to connect to private EC2
cat << 'EOF' > /home/ec2-user/scripts/connect_to_private.sh
#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <private-instance-ip>"
    exit 1
fi
ssh -o StrictHostKeyChecking=no -i /home/ec2-user/.ssh/id_rsa ec2-user@$1
EOF

chmod +x /home/ec2-user/scripts/connect_to_private.sh
chown -R ec2-user:ec2-user /home/ec2-user/scripts

echo "Public EC2 instance setup complete!"

