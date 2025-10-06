pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Charan-2804/terraform-aws-infra.git', branch: 'main'
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
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Get Private S3 Bucket Name') {
            steps {
                script {
                    // Capture S3 bucket name from Terraform output
                    BUCKET_NAME = sh(
                        script: "terraform output -raw s3_bucket_name",
                        returnStdout: true
                    ).trim()
                    echo "Private S3 bucket name is: ${BUCKET_NAME}"
                }
            }
        }

        stage('Upload Test File from Private EC2') {
            steps {
                script {
                    // Get private EC2 private IP
                    PRIVATE_IP = sh(
                        script: "terraform output -raw private_ec2_private_ip",
                        returnStdout: true
                    ).trim()

                    // Get public EC2 public IP
                    BASTION_IP = sh(
                        script: "terraform output -raw public_ec2_public_ip",
                        returnStdout: true
                    ).trim()

                    echo "Private EC2 IP: ${PRIVATE_IP}"
                    echo "Bastion IP: ${BASTION_IP}"

                    // SSH into private EC2 via bastion and run the S3 upload script
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${var.key_pair_name}.pem \
                    -J ec2-user@${BASTION_IP} ec2-user@${PRIVATE_IP} \
                    'bash /home/ec2-user/scripts/test_s3.sh'
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
