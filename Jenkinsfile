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
                dir('ansible') {
                    sh '''
                      BASTION_IP=$(terraform -chdir=../redis-infra output -raw bastion_public_ip)
                      echo "Detected Bastion Public IP: ${BASTION_IP}"
                      
                      if [ -z "${BASTION_IP}" ]; then
                        echo "Error: Bastion Public IP is empty!"
                        exit 1
                      fi
                      
                      ansible-playbook playbook.yml --ssh-common-args="-o ProxyCommand='ssh -W %h:%p -q -i /home/rahul/.ssh/my_guru.pem ubuntu@${BASTION_IP}'"
                    '''
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