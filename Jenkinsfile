pipeline{
 agent any
  environment{
        SCANNER_HOME=tool 'SonarScanner'
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
  
  }


}