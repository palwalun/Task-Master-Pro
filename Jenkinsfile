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
  
  
  
  }


}