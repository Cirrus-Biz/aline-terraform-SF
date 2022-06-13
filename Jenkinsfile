#!/usr/bin/env groovy

pipeline {

    agent {
        node {
            label 'dev-node'
        }
    }

    environment {
    }

    stages {

        stage('Build Tests') {
            steps {
                echo 'git pull test'
            }
        }

    }

    post {
        always {
        }
    }

}

