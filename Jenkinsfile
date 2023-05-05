pipeline {
    agent any
    tools {
        maven "MAVEN"
        jdk "JDK8"
    }
    
    environment {
        SNAPSHOT_REPO = 'bookworld-snapshot'
        RELEASE_REPO = 'bookworld-release'
        CENTRAL_REPO = 'bookworld-maven-central'
        GROUP_REPO = 'bookworld-group'
        NEXUS_USERNAME = 'admin'
        NEXUS_PASSWORD = 'adminadmin'
        NEXUS_IP = '??'
        NEXUS_PORT = '8081'
        NEXUS_LOGIN = 'nexus' 
        APP_LOGIN = 'bookworldlogin'
        SONARSERVER = 'sonarserver'
        SONARSCANNER = 'sonarscanner'
    }

    stages {
        stage('Build'){
            steps {
                sh 'mvn -s settings.xml -DskipTests install'
            }
            post {
                success {
                    echo "Now Archiving."
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage('Test'){
            steps {
                sh 'mvn -s settings.xml test'
            }

        }

//         stage('Checkstyle Analysis'){
//             steps {
//                 sh 'mvn -s settings.xml checkstyle:checkstyle'
//             }
//         }



        stage('Sonar Analysis') {
            steps {
            withSonarQubeEnv('My SonarQube Server') { 
                // You can override the credential to be used 
                sh 'mvn sonar:sonar'
            }
	    }
//             environment {
//                 scannerHome = tool "${SONARSCANNER}"
//             }
//             steps {
		  
//                withSonarQubeEnv("${SONARSERVER}") {
//                    sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
//                    -Dsonar.projectName=vprofile \
//                    -Dsonar.projectVersion=1.0 \
//                    -Dsonar.sources=src/ \
//                    -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
//                    -Dsonar.junit.reportsPath=target/surefire-reports/ \
//                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
//                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
//               }
//             }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("UploadArtifact"){
            steps{
                nexusArtifactUploader(
                  nexusVersion: 'nexus3',
                  protocol: 'http',
                  nexusUrl: "${NEXUSIP}:${NEXUSPORT}",
                  groupId: 'QA',
                  version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                  repository: "${RELEASE_REPO}",
                  credentialsId: "${NEXUS_LOGIN}",
                  artifacts: [
                    [artifactId: 'vproapp',
                     classifier: '',
                     file: 'target/vprofile-v2.war',
                     type: 'war']
                  ]
                )
            }
        }

        stage('Deploy Using Ansible Playbooks'){
            ansiblePlaybook(
                inventory: 'ansible/inventory',
                playbook: 'ansible/import.yml',
                disableHostKeyChecking: true,
                credentialsId: 'applogin',
                extraVars: [
                    USER: 'admin',
                    PASS: 'admin123',
                    nexusip: '123.2.2.2',
                    reponame: 'vprofile-release',
                    groupid: 'QA',
                    time: "${env.BUILD_TIMESTAMP}",
                    build: "${env.BUILD_ID}",
                    artifact: 'vproapp',
                    bookworld_version: "bookworld-${env.BUILD_ID}-${env.BUILD_TIMESTAMP}.war"
                ])
        }
}
