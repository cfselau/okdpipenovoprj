pipeline {
    environment {
        registry = "registry.hml.fiesc.com.br/apppipe/appj"
        dockerImage = ''
        registryCredential = 'oc-registry'
    }
    agent any
    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":latest"
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hml.fiesc.com.br', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
          steps {
            sh "docker rmi " + registry + ":latest"
          }
       }
    }
}
