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
                dir ('react') {
                    script {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerpat') {
                            docker.build('devopscow/todo').push()
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}