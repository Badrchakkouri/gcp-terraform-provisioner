pipeline{
    agent{
        label "master"
    }
    stages{
        stage("A"){
            steps{
                echo "github changed"
            }
            }
        }
    post{
        success{
             slackSend (color: 'good', message: "success: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure{
             slackSend (color: 'good', message: "success: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}
