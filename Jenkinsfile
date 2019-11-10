pipeline{
    agent{
        label "master"
    }
    stages{
        stage("Terraform init and plan"){
            steps{
                sh "cd ${env.WORKSPACE}"
                sh "cp /share/gcp-kit/* ."
                sh "sudo terraform init"
                sh "sudo terraform plan"
                slackSend (color: 'good', message: "Please check terraform's plan output here: ${env.jenkins_server_url}/jenkins/job/${env.JOB_NAME}/${env.BUILD_NUMBER}/console")
            }
            }

        stage("Terraform approve"){
            steps{
                sh "cd ${env.WORKSPACE}"
                slackSend (color: 'good', message: "Is it okay to proceed with the deployment ${env.jenkins_server_url}/jenkins/job/${env.JOB_NAME}")
                input(message: "Do you approve deployment?")
            
            }
            }
        
        stage("Terraform apply"){
            steps{
                sh "cd ${env.WORKSPACE}"
                sh "yes | sudo terraform apply"
                slackSend (color: 'good', message: "Please check terraform's apply results here: ${env.jenkins_server_url}/jenkins/job/${env.JOB_NAME}/${env.BUILD_NUMBER}/console")
            }
            }
        
            
        }

    
}
