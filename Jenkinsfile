#!/usr/bin/env groovy

pipeline {

    agent {
        node {
            label 'dev-node'
        }
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('SF_aws_access_key_id') 
        AWS_SECRET_ACCESS_KEY = credentials('SF_aws_secret_access_key') 
        AWS_REGION = credentials('SF_aws_region') 
        AWS_OUTPUT = credentials('SF_aws_output') 
    }

    stages {

        stage('Export Branch') {
            steps {
                sh 'export GIT_BRANCH=${GIT_BRANCH}'
            }
        }

        stage('AWS Credentials and Login') {
            steps {
                sh 'aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}'
                sh 'aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}'
                sh 'aws configure set default.region ${AWS_REGION}'
                sh 'aws configure set output ${AWS_OUTPUT}'
            }
        }

        stage('Run Jenkins Script') {
            steps {
                sh '~/jenkins/workspace/SF-Terraform-Infrastructure/deployments/team_account/dev/networking/networking_changes_errors.sh'
            }
        }
        // TODO add check to abort

    }

    post {
        always {
            sh 'sudo docker logout'  // logs out of docker removing credentials
            sh 'sudo rm -rf ~/.aws/'  // logs out of aws cli removing credentials
            sh 'sudo rm -rf ~/jenkins/workspace/${JOB_NAME}/*'  // removes all files in job workspace
            sh 'sudo rm -rf ~/jenkins/workspace/${JOB_NAME}/.git*'  // removes all .git files in job workspace
        }
    }

}
