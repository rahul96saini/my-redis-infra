pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls code from your Git repository[cite: 2]
                checkout scm
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('redis-infra') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Run Ansible Configuration') {
            steps {
                script {
                    // 1. Dynamically extract the Bastion Public IP from Terraform outputs
                    def bastionIp = sh(
                        script: 'terraform -chdir=redis-infra output -raw bastion_public_ip',
                        returnStdout: true
                    ).trim()

                    echo "Detected Bastion Public IP: ${bastionIp}"

                    // 2. Run Ansible playbook and inject the dynamic SSH proxy command
                    dir('ansible') {
                        sh """
                        ansible-playbook playbook.yml \
                          --ssh-common-args='-o ProxyCommand="ssh -W %h:%p -q -i ~/.ssh/my-guru.pem ubuntu@${bastionIp}"'
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Redis Cluster and Sentinel deployed and configured successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}