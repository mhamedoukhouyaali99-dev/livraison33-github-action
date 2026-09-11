pipeline {
    agent any

    options {
        timestamps()
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Installer les dependances') {
            steps {
                bat 'py -3 --version'
                bat 'py -3 -m pip install --upgrade pip'
                bat 'py -3 -m pip install --upgrade robotframework robotframework-requests robotframework-seleniumlibrary selenium'
            }
        }

        stage('Tests unitaires') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports mkdir reports'
                    bat 'py -3 -m unittest discover -v tests_unitaire > reports\\unit-test-results.txt 2>&1'
                }
            }
        }

        stage('Tests API') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\api mkdir reports\\api'
                    bat 'py -3 -m robot --outputdir reports\\api tests_api'
                }
            }
        }

        stage('Tests IHM') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\ihm mkdir reports\\ihm'
                    bat 'py -3 -m robot --outputdir reports\\ihm tests_ihm'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**/*', allowEmptyArchive: true, fingerprint: true
            archiveArtifacts artifacts: 'log.html,report.html,output.xml', allowEmptyArchive: true
        }
    }
}
