pipeline {
 agent any
    tools{
      maven 'mvn'
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
   
    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhublogin'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push("latest")
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
