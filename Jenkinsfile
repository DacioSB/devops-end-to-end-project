pipeline{
    
    agent any 

    tools {

        maven 'maven'
    }
    
    stages {
        
        stage('Git Checkout'){
            
            steps{
                
                script{
                    
                    git branch: 'main', url: 'https://github.com/DacioSB/devops-end-to-end-project.git'
                }
            }
        }
        stage('UNIT testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn test'
                }
            }
        }
        stage('Integration testing'){
            
            steps{
                
                script{
                    
                    sh 'mvn verify -DskipUnitTests'
                }
            }
        }
        stage('Maven build'){
            
            steps{
                
                script{
                    
                    sh 'mvn clean install'
                }
            }
        }
        stage('Static code analysis'){
            
            steps{
                
                script{
                    
                    withSonarQubeEnv(credentialsId: 'sonar-api-key') {
                        
                        sh 'mvn clean package sonar:sonar'
                    }
                   }
                    
                }
            }
            stage('Quality Gate Status'){
                
                steps{
                    
                    script{
                        
                        waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api-key'
                    }
                }
            }
            stage('Nexus upload'){
                steps{

                    script{
                        def readPomVersion = readMavenPom file: 'pom.xml'
                        def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshots" : "demoapp-releases"
                        nexusArtifactUploader artifacts: [[artifactId: 'springboot', classifier: '', file: 'target/Uber.jar', type: 'jar']], credentialsId: 'nexus-auth', groupId: 'com.example', nexusUrl: '172.17.46.180:8081', nexusVersion: 'nexus3', protocol: 'http', repository: nexusRepo, version: "${readPomVersion.version}"
                    }
                }
            }
            stage('Docker image build') {

                steps { 
                    script {
                        sh 'docker build -t ${JOB_NAME}:v1.${BUILD_ID}'
                        sh 'docker tag ${JOB_NAME}:v1.${BUILD_ID} 12020221/${JOB_NAME}:v1.${BUILD_ID}'
                        sh 'docker tag ${JOB_NAME}:v1.${BUILD_ID} 12020221/${JOB_NAME}:latest'
                    }
                }
            }
        }
        
}