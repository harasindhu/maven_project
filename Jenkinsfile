pipeline {
 agent any
 tools {
        jdk 'Java17'
        maven 'maven3'
 }
    environment {
            APP_NAME = "web-app-pipeline"
            RELEASE = "1.0.0"
            DOCKER_USER = "sindhu212"
            DOCKER_PASS = 'docker-cred'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
 stages {
  stage('Checkout') {
      steps {
         git branch: 'main', url: 'https://github.com/harasindhu/maven_project.git'
       }
    }
 stage('Build and Test') {
      steps {
        // build the project and create a JAR file
        sh 'mvn clean package'
      }
    }
   
   stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
   }
stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "maven_project"
            GIT_USER_NAME = "harasindhu"
            GITHUB_PASSWORD = "sindhu21295"
        }
        steps {
         sh 'pwd'
           withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_PASSWORD')]) {
                    sh '''
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" maven_project/webapp/deployment.yml
                    git add maven_project/webapp/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }
} 

