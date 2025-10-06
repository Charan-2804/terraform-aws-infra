pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')   // Add AWS credentials in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Charan-2804/Waste_management.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file=terraformtf.vars -out=tfplan -input=false'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Show Outputs') {
            steps {
                script {
                    echo "=== Terraform Outputs ==="
                    sh '''
                      echo "Public EC2 IP: $(terraform output -raw public_ec2_public_ip)"
                      echo "Private EC2 IP: $(terraform output -raw private_ec2_private_ip)"
                      echo "Private S3 Bucket: $(terraform output -raw s3_bucket_name)"
                      echo "SSH Command (Public EC2): $(terraform output -raw public_ec2_ssh_command)"
                      echo "SSH Command via Bastion: $(terraform output -raw ssh_via_bastion_command)"
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished!'
        }
        success {
            echo 'Terraform applied successfully!'
        }
        failure {
            echo 'Terraform apply failed!'
        }
    }
}
