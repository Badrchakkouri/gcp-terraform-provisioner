pipeline{
    agent{
        label "master"
    }
    stages{
        stage("Terraform destroy plan"){
            steps{
                sh "cd ${env.WORKSPACE}"
                sh "cp /share/gcp-kit/* ."
                sh "sudo terraform init"
                sh "sudo terraform destroy"
                slackSend (color: 'good', message: "Please check terraform's destroy output here: ${env.JENKINS_URL}job/terraform/job/${env.JOB_BASE_NAME}/${env.BUILD_NUMBER}/console")
            }
            }

        stage("Terraform approve destroy"){
            steps{
                sh "cd ${env.WORKSPACE}"
                slackSend (color: 'good', message: "If everything's fine please go to ${env.JENKINS_URL}job/terraform/job/${env.JOB_BASE_NAME} and proceed with the destroy")
                input(message: "Do you approve the destroy?")
            
            }
            }
        
        stage("Terraform destory"){
            steps{
                sh "cd ${env.WORKSPACE}"
                sh "yes \"yes\" | sudo terraform destroy"
                slackSend (color: 'good', message: "terraform's has finished the destroy. Check the results here: ${env.JENKINS_URL}job/terraform/job/${env.JOB_BASE_NAME}/${env.BUILD_NUMBER}/console")
            }
            }
        
        
            
        }
        post{
            always{
                cleanWs()
            }
        }

    
}
