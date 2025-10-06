pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
        PRIVATE_KEY_PATH      = '/var/lib/jenkins/keys/terraform-poc.pem' // Path to your private key
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
                    // Get dynamic values from Terraform outputs
                    def privateIp = sh(script: "terraform output -raw private_ec2_private_ip", returnStdout: true).trim()
                    def publicIp  = sh(script: "terraform output -raw public_ec2_public_ip", returnStdout: true).trim()
                    def s3Bucket  = sh(script: "terraform output -raw s3_bucket_name", returnStdout: true).trim()

                    echo "Uploading test file from private EC2 to S3 bucket: ${s3Bucket}"

                    // SSH command to run on private EC2 via bastion (public EC2)
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${PRIVATE_KEY_PATH} -J ec2-user@${publicIp} ec2-user@${privateIp} \\
                        "echo 'This is a test file from private EC2 at \$(date)' > /home/ec2-user/test_file.txt && \\
                         aws s3 cp /home/ec2-user/test_file.txt s3://${s3Bucket}/test-files/"
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
