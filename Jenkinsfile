pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')     // Jenkins AWS credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout Terraform Repo') {
            steps {
                echo "Checking out Terraform repo..."
                git url: 'https://github.com/Charan-2804/terraform-aws-infra.git', branch: 'main'
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
                sh 'terraform plan -var-file=terraformtf.vars -out=tfplan -input=false'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Upload File to Private S3') {
            steps {
                script {
                    def sshPrivate = sh(script: "terraform output -raw ssh_via_bastion_command", returnStdout: true).trim()
                    echo "Running S3 upload script on private EC2..."
                    sh """
                    $sshPrivate << 'EOF'
                    chmod +x /home/ec2-user/scripts/test_s3.sh
                    /home/ec2-user/scripts/test_s3.sh
                    EOF
                    """
                }
            }
        }

        stage('Verify File in S3') {
            steps {
                script {
                    def sshPrivate = sh(script: "terraform output -raw ssh_via_bastion_command", returnStdout: true).trim()
                    echo "Verifying file exists in S3..."
                    sh """
                    $sshPrivate << 'EOF'
                    BUCKET_NAME=$(terraform output -raw s3_bucket_name)
                    aws s3 ls s3://$BUCKET_NAME/test-files/test_file.txt
                    EOF
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Terraform, file upload, and verification completed successfully."
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
