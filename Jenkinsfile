pipeline {
    agent {label "test"}
    options { disableConcurrentBuilds() }

    stages {
        stage('SonarQube Analysis') {
            steps {
                script {
                    scannerHome = tool 'sonarqube_api';
                }
                withSonarQubeEnv(installationName: 'sonarqube_stemly_ui_localhost_password') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Building..'
                sh '''#!/bin/bash

                export PATH=/opt/minicoda/bin/:$PATH
                export PATH=/opt/minicoda/condabin/:$PATH
                export PATH=/home/stemly/.local/bin:$PATH

                source /opt/miniconda/etc/profile.d/conda.sh
                conda activate stemly

                cp /srv/stemly/stemly_api/.env .env

                pip install -r stemly/requirements.txt
                pip install -r stemly/requirements-test.txt
                pip install -e .
                '''

            }
        }
        stage('Static Code and Image Check') {
            steps {
                echo 'Building..'
                sh '''#!/bin/bash

                export PATH=/opt/minicoda/bin/:$PATH
                export PATH=/opt/minicoda/condabin/:$PATH
                export PATH=/home/stemly/.local/bin:$PATH

                source /opt/miniconda/etc/profile.d/conda.sh
                conda activate stemly

                make static-scan

                '''
            }
        }
        stage('Cleaning DBs') {
            steps {
                echo 'Clean DB..'
                sh '''#!/bin/bash

                export PATH=/opt/minicoda/bin/:$PATH
                export PATH=/opt/minicoda/condabin/:$PATH
                export PATH=/home/stemly/.local/bin:$PATH

                source /opt/miniconda/etc/profile.d/conda.sh
                conda activate stemly

                make clean
                rm -r /home/stemly/workspace/data/ 2>/dev/null || true
                '''
            }
        }
        stage('Unit Test') {
            steps {
                sh '''#!/bin/bash
                #!/bin/bash

                export PATH=/opt/minicoda/bin/:$PATH
                export PATH=/opt/minicoda/condabin/:$PATH
                export PATH=/home/stemly/.local/bin:$PATH

                source /opt/miniconda/etc/profile.d/conda.sh
                conda activate stemly

                make unit-test
                '''
            }
        }
    }
}
