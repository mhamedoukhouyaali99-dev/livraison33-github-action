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

        stage('Detecter Python') {
            steps {
                script {
                    env.PYTHON_EXE = powershell(returnStdout: true, script: '''
                        $candidates = @(
                            (Get-Command python -ErrorAction SilentlyContinue).Source,
                            "$env:ProgramFiles\\Python311\\python.exe",
                            "$env:ProgramFiles\\Python312\\python.exe",
                            "$env:LocalAppData\\Programs\\Python\\Python311\\python.exe",
                            "$env:LocalAppData\\Programs\\Python\\Python312\\python.exe",
                            "C:\\Users\\M'hamed\\AppData\\Local\\Programs\\Python\\Python311\\python.exe"
                        ) | Where-Object { $_ -and (Test-Path $_) }

                        foreach ($candidate in $candidates) {
                            & $candidate --version *> $null
                            if ($LASTEXITCODE -eq 0) {
                                Write-Output $candidate
                                exit 0
                            }
                        }

                        throw "Python introuvable. Installez Python 3.11 sur l'agent Jenkins et ajoutez-le au PATH systeme, puis redemarrez le service Jenkins."
                    ''').trim()
                    echo "Python utilise par Jenkins : ${env.PYTHON_EXE}"
                }
            }
        }

        stage('Installer les dependances') {
            steps {
                bat '"%PYTHON_EXE%" --version'
                bat '"%PYTHON_EXE%" -m pip install --upgrade pip'
                bat '"%PYTHON_EXE%" -m pip install --upgrade robotframework robotframework-requests robotframework-seleniumlibrary selenium'
            }
        }

        stage('Tests unitaires') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports mkdir reports'
                    bat '"%PYTHON_EXE%" -m unittest discover -v tests_unitaire > reports\\unit-test-results.txt 2>&1'
                }
            }
        }

        stage('Tests API') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\api mkdir reports\\api'
                    bat '"%PYTHON_EXE%" -m robot --outputdir reports\\api tests_api'
                }
            }
        }

        stage('Tests IHM') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    bat 'if not exist reports\\ihm mkdir reports\\ihm'
                    bat '"%PYTHON_EXE%" -m robot --outputdir reports\\ihm tests_ihm'
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
