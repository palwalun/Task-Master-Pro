pipeline{
 agent any
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
  
  
  }


}