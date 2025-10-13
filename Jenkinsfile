pipeline {
    agent any
    parameters {
        choice(name: 'TF_ACTION', choices: ['apply', 'destroy'], description: 'Terraform action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo "Checking out Git repository..."
                git branch: 'main', url: 'https://github.com/Charan-2804/terraform-aws-infra.git'
            }
        }

        stage('Prepare PEM') {
            steps {
                echo "Retrieving PEM file from Jenkins credentials..."
                // Jenkins secret file credential
                withCredentials([file(credentialsId: 'Mini-dft-project-key-pem', variable: 'PEM_FILE')]) {
                    sh '''
                        cp $PEM_FILE ./Mini-dft-project-key.pem
                        chmod 600 ./Mini-dft-project-key.pem
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                echo "Planning Terraform changes..."
                sh 'terraform plan -var="private_key=${WORKSPACE}/Mini-dft-project-key.pem" -var-file=terraform.tfvars -out=tfplan -input=false'
            }
        }

        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    if (params.TF_ACTION == 'apply') {
                        echo "Applying Terraform changes..."
                        sh 'terraform apply -input=false tfplan'
                    } else {
                        echo "Destroying Terraform resources..."
                        sh 'terraform destroy -var="private_key=Mini-dft-project-key.pem" -var-file=terraform.tfvars -auto-approve'
                    }
                }
            }
        }

        stage('Upload Test File from Private EC2') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
            steps {
                script {
                    def PRIVATE_IP = sh(script: "terraform output -raw private_ec2_private_ip", returnStdout: true).trim()
                    def PUBLIC_IP  = sh(script: "terraform output -raw public_ec2_public_ip", returnStdout: true).trim()
                    def S3_BUCKET  = sh(script: "terraform output -raw s3_bucket_name", returnStdout: true).trim()

                    echo "Uploading test file from private EC2 to S3 bucket: ${S3_BUCKET}"

                    sh """
                        scp -o StrictHostKeyChecking=no -i Mini-dft-project-key.pem Mini-dft-project-key.pem ec2-user@${PUBLIC_IP}:/home/ec2-user/.ssh/Mini-dft-project-key.pem
                        ssh -o StrictHostKeyChecking=no -i Mini-dft-project-key.pem ec2-user@${PUBLIC_IP} chmod 600 /home/ec2-user/.ssh/Mini-dft-project-key.pem

                        ssh -o StrictHostKeyChecking=no -i Mini-dft-project-key.pem ec2-user@${PUBLIC_IP} \\
                            "ssh -o StrictHostKeyChecking=no -i /home/ec2-user/.ssh/Mini-dft-project-key.pem ec2-user@${PRIVATE_IP} \\
                            'echo \"This is a test file from private EC2 at \$(date)\" > /home/ec2-user/test_file.txt && \\
                             aws s3 cp /home/ec2-user/test_file.txt s3://${S3_BUCKET}/test-files/test_file.txt'"
                    """
                }
            }
        }

        stage('Show Outputs') {
            when {
                expression { params.TF_ACTION == 'apply' }
            }
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
    }

    post {
        always {
            echo 'Cleaning up sensitive files...'
            sh 'rm -f Mini-dft-project-key.pem'
            echo 'Pipeline finished'
        }
        success {
            echo "Terraform ${params.TF_ACTION} executed successfully"
        }
        failure {
            echo "Terraform ${params.TF_ACTION} failed"
        }
    }
}