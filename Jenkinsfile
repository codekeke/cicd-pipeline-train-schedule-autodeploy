pipeline {
    agent { label 'Agent3' }
    tools {
       gradle '7.5.1'
    }     
    environment {
        //- be sure to replace "bhavukm" with your own Docker Hub username
         dockerImage = 'knj15955/train-schedule'
        registry = 'knj15955/edureka_schedule_autodeploy'
        //- update your credentials ID after creating credentials for connecting to Docker Hub
        DOCKERHUB_CREDENTIALS = credentials ('dckrhub_PAT')
       
                }    
  stages {
        stage('Check Out') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/codekeke/cicd-pipeline-train-schedule-autodeploy.git']]])
            }
        }
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                sh "sudo docker build -t knj15955/train-schedule-1.0 ."
                }
         }
         stage('Login Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u knj15955 --password-stdin'
		}
	}
        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                 sh "sudo docker push knj15955/my-app-1.0:latest"
                 }
            }
        }
        stage('CanaryDeploy') {
            when {
                branch 'master'
            }
            environment { 
                CANARY_REPLICAS = 1
            }
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    stage('DeployToProduction') {
            when {
                branch 'master'
            }
            environment { 
                CANARY_REPLICAS = 0
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube-canary.yml',
                    enableConfigSubstitution: true
                )
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'train-schedule-kube.yml',
                    enableConfigSubstitution: true
             )
            }
        }
    }
}
