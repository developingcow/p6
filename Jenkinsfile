pipeline {
    agent any
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
                    // Bind credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerpat', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Login to Docker within shell script
                        sh '''
                        echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
                        '''
                        
                        sh 'docker build -t devopscow/todo:1 .'
                        sh 'docker push devopscow/todo:1'
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
