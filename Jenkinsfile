#!/usr/bin/env groovy
pipeline {
    agent any

  stages {

    stage('Ansible') {
      steps {
          withCredentials([
                    usernamePassword(credentialsId: 'dap-creds', usernameVariable:'CONJUR_AUTHN_LOGIN', passwordVariable: 'CONJUR_AUTHN_API_KEY')]) {
                        sh "bash ansible-ssh-user-pwd.sh"
                    }
      }
    }

    stage('Results') {
      steps {
       sh 'echo "Finished!"'
      }
    }

  }
}
