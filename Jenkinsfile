pipeline {
    agent any

    environment {
        IMAGE_NAME = "badhrinarayanan26/flask-demo:v1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m py_compile app/app.py'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME app/'
            }
        }

        stage('Image Scan') {
            steps {
                sh 'trivy image --severity CRITICAL --exit-code 1 $IMAGE_NAME'
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl rollout restart deployment flask-app'
            }
        }
    }
}
