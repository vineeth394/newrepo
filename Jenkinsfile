pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'  // Change as per your AWS region
        S3_BUCKET = 'your-terraform-backend-bucket' // S3 bucket for Terraform state
        DYNAMODB_TABLE = 'your-lock-table' // DynamoDB table for state locking
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vineeth394/jenkinsec2.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init \
                        -backend-config="bucket=$S3_BUCKET" \
                        -backend-config="key=terraform.tfstate" \
                        -backend-config="region=$AWS_REGION" \
                        -backend-config="dynamodb_table=$DYNAMODB_TABLE"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval Before Apply') {
            steps {
                input message: "Do you want to proceed with Terraform Apply?", ok: "Yes"
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Configure EC2 with Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i inventory.ini configure_ec2.yml
                    '''
                }
            }
        }

        stage('Cleanup - Terraform Destroy (Optional)') {
            when {
                expression { return params.DESTROY_ENVIRONMENT == 'true' }
            }
            steps {
                dir('terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs for errors.'
        }
    }
}
