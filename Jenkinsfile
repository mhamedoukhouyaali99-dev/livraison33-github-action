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
                bat 'python -m pip install --upgrade pip'
                bat 'python -m pip install --upgrade robotframework robotframework-requests robotframework-seleniumlibrary selenium'
            }
        }

        stage('Tests unitaires') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports mkdir reports'
                    bat 'python -m unittest discover -v tests_unitaire > reports\\unit-test-results.txt 2>&1'
                }
            }
        }

        stage('Tests API') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\api mkdir reports\\api'
                    bat 'python -m robot --outputdir reports\\api tests_api'
                }
            }
        }

        stage('Tests IHM') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\ihm mkdir reports\\ihm'
                    bat 'python -m robot --outputdir reports\\ihm tests_ihm'
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
