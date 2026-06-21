pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                sh 'docker build -t flask-demo:v1 app/'
            }
        }

        stage('Deploy') {
            steps {
                sh 'kubectl rollout restart deployment flask-app'
            }
        }
    }
}
