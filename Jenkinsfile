pipeline {
    agent any
    tools { nodejs 'node' }
    stages {
        stage('Source') {
            steps {
                echo 'Handled by git scm'
            }
        }
        
        stage('Build') {
           steps {
                dir ('react') { 
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test') {
            steps {
                dir ('react') {
                    sh 'npx jest --passWithNoTests'
                }
            }
        }

        stage('Push') {
            steps {
                echo 'Pushing to Docker Hub..'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}