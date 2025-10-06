pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out Git repository..."
                git branch: 'main', url: 'https://github.com/Charan-2804/terraform-aws-infra.git'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Planning Terraform changes..."
                sh 'terraform plan -var-file=terraform.tfvars -out=tfplan -input=false'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Show Outputs') {
            steps {
                script {
                    echo "Terraform Outputs:"
                    sh '''
                        echo "Public EC2 IP: $(terraform output -raw public_ec2_public_ip)"
                        echo "Private EC2 IP: $(terraform output -raw private_ec2_private_ip)"
                        echo "S3 Bucket Name: $(terraform output -raw s3_bucket_name)"
                        echo "Public EC2 SSH Command: $(terraform output -raw public_ec2_ssh_command)"
                        echo "SSH via Bastion Command: $(terraform output -raw ssh_via_bastion_command)"
                    '''
                }
            }
        }

        stage('Upload Test File from Private EC2') {
            steps {
                script {
                    // Get Terraform outputs
                    def PRIVATE_IP = sh(script: "terraform output -raw private_ec2_private_ip", returnStdout: true).trim()
                    def PUBLIC_IP  = sh(script: "terraform output -raw public_ec2_public_ip", returnStdout: true).trim()
                    def S3_BUCKET  = sh(script: "terraform output -raw s3_bucket_name", returnStdout: true).trim()

                    echo "Uploading test file from private EC2 to S3 bucket: ${S3_BUCKET}"

                    // SSH into private EC2 via public EC2 (bastion), create a file, upload to S3
                    sh """
                    ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/keys/terraform-poc.pem \
                    -J ec2-user@${PUBLIC_IP} ec2-user@${PRIVATE_IP} \
                    'echo "This is a test file from private EC2 at \$(date)" > /home/ec2-user/test_file.txt && \
                     aws s3 cp /home/ec2-user/test_file.txt s3://${S3_BUCKET}/test-files/test_file.txt'
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Terraform applied successfully'
        }
        failure {
            echo 'Terraform apply failed'
        }
    }
}
