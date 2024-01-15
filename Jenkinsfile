pipeline {
 agent any
 tools {
  maven 'mvn'
 }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-cred')
        DOCKER_IMAGE_NAME = 'sindhu212/cicd'
    }
 stages {
  stage('Checkout') {
      steps {
         git branch: 'main', url: 'https://github.com/iamkishore0/maven_project.git'
       }
    }
  stage('Static Code Analysis') {
      environment {
       
            scannerHome = tool 'sonarqube'

            }

            steps {

             withSonarQubeEnv('sonarqube'){

                 sh "${scannerHome}/bin/sonar-scanner \
                  -Dsonar.login=87da6f33c59af2f60af0af0ce897b099c79732fa\
                  -Dsonar.host.url=https://sonarcloud.io \
                  -Dsonar.organization=cicd123\
                  -Dsonar.projectKey=cicd123_myproject \
                  -Dsonar.java.binaries=./ "
        }
      }
    }
   
  stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                    sh 'docker build -t your-docker-image-name:${env.BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'DOCKER_HUB_CREDENTIALS') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Pull Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'DOCKER_HUB_CREDENTIALS') {
                        docker.image("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}").pull()
                    }
                }
            }
        }
    
stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "maven_project"
            GIT_USER_NAME = "harasindhu"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" maven_project/deployment.yml
                    git add maven_project/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }
} 

