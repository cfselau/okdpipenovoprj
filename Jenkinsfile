pipeline {
    environment {
<<<<<<< HEAD
        registryHML = "registry.hml.fiesc.com.br/demoprj/appas"
        registryPRD = "registry.fiesc.com.br/demo1/appas"
        registryCredentialHML = 'registry-hml'
        registryCredentialPRD = 'registry-prd'
=======
        registry = "registry.hml.fiesc.com.br/novoprj/appn"
>>>>>>> 825678b0ac86ef90b5b84d5a07cb6306ce45d07e
        dockerImage = ''
    }
    agent any
    stages {
        stage('Build HML Image') {
            steps {
                script {
                    dockerImage = docker.build registryHML + ":HML"
                }
            }
        }
        stage('Push Docker Image to HML') {
            steps {
                script {
                    docker.withRegistry('https://registry.hml.fiesc.com.br', registryCredentialHML) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Promote to PRD with approve') {
            steps {
                script {
                    def userInput = input(id: 'Proceed1', message: 'Promote build to PRD?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                    echo 'userInput: ' + userInput

                    if(userInput == true) {
                        dockerImage = docker.build registryPRD + ":PRD"
                        docker.withRegistry('https://registry.fiesc.com.br', registryCredentialPRD) {
                            // A project with the same name must exist on OKD PR
                            dockerImage.push()
                        }
                    } else {
                        // not do action
                        echo "Action was aborted."
                    }

                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi " + registryHML + ":HML"
                sh "docker rmi " + registryPRD + ":PRD"
            }
       }
    }
}


