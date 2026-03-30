pipeline{
 agent any
  environment{
        SCANNER_HOME=tool 'SonarScanner'
	    ACR_LOGIN_SERVER = "devopsproject2.azurecr.io"
		IMAGE_NAME = 'masterpro'
		TAG = 'latest'
        }
  stages{
   stage('Checkout Code'){
    steps{
      git url: "https://github.com/palwalun/EKART.git",
      branch: "main"
	   }
      }
	stage('Build'){
     steps{
	   sh 'mvn clean package'
	   }
      }
    stage('Building docker Image'){
	 steps{
	 sh 'docker build -t masterpro:latest .'
	 }
	}
	stage('Login to ACR') {
       steps {
         withCredentials([usernamePassword(
             credentialsId: 'acr-creds',
             usernameVariable: 'ACR_USER',
             passwordVariable: 'ACR_PASS'
         )]) {
             sh '''
               echo $ACR_PASS | docker login $ACR_LOGIN_SERVER \
               -u $ACR_USER --password-stdin
             '''
           }
          }
         }
		 stage('Tag Image') {
        steps {
         sh '''
           docker tag ${IMAGE_NAME}:${TAG} \
           $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}
         '''
          }
        }
		stage('Push Image to ACR'){
	      steps{
	        sh 'docker push $ACR_LOGIN_SERVER/${IMAGE_NAME}:${TAG}'
	    }
	   }
	stage('Deploy to k8s cluster'){
	  when{
	   expression { params.ENV == 'Prod'}
	  }
	  steps{
	  input message: 'Do you approve deployment to Production?', ok: 'Deploy'
	   sh '''
	    kubectl apply -f deployment.yml
		kubectl apply -f service.yml
		'''
	   }
	  
	 }
  
  }


}
