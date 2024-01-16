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
 stage('Build and Test') {
      steps {
        // build the project and create a JAR file
        sh 'mvn clean package'
      }
    }
   
   stage('Build and Push Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}")
                    dockerImage.push()
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

