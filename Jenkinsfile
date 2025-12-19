pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "234189401549"
        ECR_REPO = "devops-demo"
        IMAGE = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Build Docker Image & Push') {
            steps {
                sh '''
                docker build -t ${IMAGE}:${BUILD_NUMBER} .
                docker push ${IMAGE}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Update K8s Manifest & Push to Git') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GIT_USERNAME',
                    passwordVariable: 'GIT_PASSWORD'
                )]) {

                    sh '''
                    git config --global user.email "jenkins@devops.com"
                    git config --global user.name "Jenkins"

                    git checkout main

                    sed -i "s#${IMAGE}:.*#${IMAGE}:${BUILD_NUMBER}#g" k8s/deployment.yaml

                    git add k8s/deployment.yaml
                    git commit -m "Deploy build ${BUILD_NUMBER}"
                    git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/Manojmano36/devops-ci-cd-project.git main
                    '''
                }
            }
        }

    }
}
