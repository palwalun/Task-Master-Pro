pipeline{
 agent any
  parameters{
   choice(name: 'ENV', choices: ['Dev', 'QA', 'Prod'], description: 'Select Environment')
  }
  environment{
        SCANNER_HOME=tool 'SonarScanner'
	    ACR_LOGIN_SERVER = "devopsproject1.azurecr.io"
		IMAGE_NAME = 'masterpro'
		TAG = 'latest'
        }
  stages{
   stage('Checkout Code'){
    steps{
	   checkout scm
	   }
      }
	stage('Build'){
     steps{
	   sh 'mvn clean package'
	   }
      }
	stage('SonarQube Analysis'){
     steps{
	   sh 'mvn clean package'
	   }
      }
    stage("Sonarqube Analysis"){
            steps{
                withSonarQubeEnv('SonarQube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BankApp \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=BankApp '''
    
                }
            }
        }
	stage('OWASP Dependency-Check') {
          steps {
           dependencyCheck additionalArguments: '--scan pom.xml', odcInstallation: 'Dependency-Check'
              dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
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
	   stage('Deploy the docker image to QA server') {
	     when{
		  expression { params.ENV == 'QA' }
		 }
        steps {
         withCredentials([usernamePassword(
         credentialsId: 'acr-creds',
         usernameVariable: 'ACR_USER',
         passwordVariable: 'ACR_PASS'
         )]) {
          sh '''
            ssh jenkins@4.222.234.133 \
            ansible-playbook /home/jenkins/Myansible/masterpro.yml \
            -e acr_username=$ACR_USER \
            -e acr_password=$ACR_PASS \
            -b
         '''
         }
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