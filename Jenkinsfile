pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID_devops')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY_devops')
        AWS_DEFAULT_REGION    = 'ap-south-1'
        RJ_APPLICATION = 'RJ'
        AWS_PROFILE = 'AWS_DEVOPS'
    }
    parameters{
        choice choices: ["apply","destroy"], name: "createordestory"
    }
    stages {
        stage('Show the environment') {
            steps {
                echo "Application name is ${RJ_APPLICATION}"
                echo "Build ID is ${env.BUILD_ID}"
            }
        }
        stage('Git Checkout') {
            steps {
                git branch: 'develop', credentialsId: 'foodiesPat', url: 'https://github.com/RaviJangraRJ/EKScomplete.git'
            }
        }

        stage('Terraform Init and plan') {
            steps {
                script {
                    def terraformDir = 'Infrastructure'
                    
                    sh """
                        cd ${terraformDir}
                        sudo aws configure set aws_access_key_id ${env.AWS_ACCESS_KEY_ID}
                        sudo aws configure set aws_secret_access_key ${env.AWS_SECRET_ACCESS_KEY}
                        sudo aws configure set region ${env.AWS_DEFAULT_REGION}
                        sudo terraform init
                        sudo terraform plan
                    """
                }
            }
        }
        
        stage('Terraform apply'){
            steps{
                script {
                    def terraformDir = 'Infrastructure'
                    
                    sh """ 
                    cd ${terraformDir}
                        sudo terraform ${params.createordestory} --auto-approve
                    """
                }
            }
        }
        stage('deploy sample app'){
            steps{
                script {
                    def yaml = 'Infrastructure/manifests'
                    sh """
                    cd ${yaml}
                        sudo aws eks --region ap-south-1 update-kubeconfig --name demo
                        sudo kubectl get pods
                        sudo kubectl apply -f deployment.yaml
                        sudo kubectl apply -f service.yaml
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform apply succeeded!'
        }
        failure {
            echo 'Terraform apply failed!'
        }
    }
}
