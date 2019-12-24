pipeline{
    agent any
  parameters{
    string(name: 'port', defaultValue: '1234')        
  }
    stages{
        stage('checkout'){
            steps{
                git credentialsId: 'git', url: 'https://github.com/vnkrishnan89/java-sample.git'
            }
        }
        stage('build'){
            steps{
                sh "mvn clean package"
            }
        } 
        stage('build container'){
            steps{
            //    sh "sudo docker build -t vnkrishnan89/javasample ."
                sh "sudo docker build -t 743550917294.dkr.ecr.us-east-1.amazonaws.com/javasample:latest ."
            }
        }
        stage('docker push'){
            steps{
            //    withCredentials([string(credentialsId: 'dockerpwd', variable: 'dockerpwd')]) {
            //        sh "sudo docker login -u vnkrishnan89 -p ${dockerpwd}"
            //        sh "sudo docker push vnkrishnan89/javasample"
            //    }
                withAWS(credentials: 'aws', region: 'us-east-1') {
                    sh "eval sudo \$(aws ecr get-login --no-include-email | sed 's|https://||')"
                    sh "sudo docker push 743550917294.dkr.ecr.us-east-1.amazonaws.com/javasample:latest"
                }
            }
        }
        stage('run container'){
            agent { label 'docker' }
            steps {
                git credentialsId: 'git', url: 'https://github.com/vnkrishnan89/java-sample.git'
                sh "if [[ ! -z \"\$(sudo docker ps | grep ${params.port} | grep 743550917294.dkr.ecr.us-east-1.amazonaws.com/javasample | cut -d' ' -f1)\" ]]; then sudo docker ps | grep 1234 | grep 743550917294.dkr.ecr.us-east-1.amazonaws.com/javasample | cut -d' ' -f1 | xargs sudo docker stop; fi"
                withAWS(credentials: 'aws', region: 'us-east-1') {
                    sh "aws ecs register-task-definition --cli-input-json file://java-sample-v_0.json"
                    sh "eval sudo \$(aws ecr get-login --no-include-email | sed 's|https://||')"
                    sh "sudo docker run -d -p ${params.port}:8080 743550917294.dkr.ecr.us-east-1.amazonaws.com/javasample:latest"
                }                    
            }
        }
       
    }
}