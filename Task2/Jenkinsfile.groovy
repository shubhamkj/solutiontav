pipeline {
	agent any
	environment {
		registry = "shubhamkj/docker-test"
		registryCredential = 'dockerhub'
		dockerImage = 'sagan-site'
  	}
	stages{		
		stage(CodeCheckout) {
			steps {
				git url: 'https://github.com/spring-io/sagan.git', branch: 'main',
                 credentialsId: 'github_creds'
			}
		}
		stage(CodeBuild) {
			steps { 
				sh './gradelw build'
			}
		}
		stage(BuildDockerImage) {
			script {
          		dockerImage = docker.build registry + ":$BUILD_NUMBER"
        	}
		}
		stage('Deploy Image') {
			steps{
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
			}
        }
	}
}