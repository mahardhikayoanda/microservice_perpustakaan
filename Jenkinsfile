pipeline {
    agent any

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Build Anggota Service') {
            steps {
                dir('anggota') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test Anggota Service') {
            steps {
                dir('anggota') {
                    sh 'mvn test'
                }
            }
        }

        stage('Build Buku Service') {
            steps {
                dir('buku') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test Buku Service') {
            steps {
                dir('buku') {
                    sh 'mvn test'
                }
            }
        }

        stage('Build Peminjaman Service') {
            steps {
                dir('peminjaman') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test Peminjaman Service') {
            steps {
                dir('peminjaman') {
                    sh 'mvn test'
                }
            }
        }

        stage('Build Pengembalian Service') {
            steps {
                dir('pengembalian') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test Pengembalian Service') {
            steps {
                dir('pengembalian') {
                    sh 'mvn test'
                }
            }
        }
    }

    post {
        success {
            echo '✅ All services built and tested successfully!'
        }
        failure {
            echo '❌ Build or test failed!'
        }
        always {
            echo 'Pipeline completed.'
        }
    }
}
