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
   
   stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "abhishekf5/ultimate-cicd:${BUILD_NUMBER}"
        DOCKERFILE_LOCATION = "maven_project/webapp/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
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
