pipeline {
    agent any
    
    tools {
        jdk 'jdk21'
    }

    options {
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    environment {
        BUILD_VERSION = "${env.BUILD_NUMBER}"
        DOCKER_REGISTRY = 'localhost:5000'
        GIT_COMMIT_SHORT = "${GIT_COMMIT.take(7)}"
    }
    
    stages {
        stage('📋 Checkout') {
            steps {
                echo "========== 📋 CHECKOUT STAGE =========="
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    extensions: [[$class: 'CloneOption', depth: 1, shallow: true]], 
                    userRemoteConfigs: [[url: 'https://github.com/mahardhikayoanda/microservice_perpustakaan.git']]
                ])
                echo "✅ Repository checked out successfully"
                sh 'git log --oneline -1'
            }
        }
        
        stage('🔧 Setup') {
            steps {
                echo "========== 🔧 SETUP STAGE =========="
                sh '''
                    echo "Checking Versions..."
                    echo "--------------------"
                    echo "Java Runtime (java):"
                    java -version
                    echo "--------------------"
                    echo "Java Compiler (javac):"
                    javac -version
                    echo "--------------------"
                    echo "Maven:"
                    mvn -version
                    echo "--------------------"
                    echo "Docker:"
                    docker --version
                '''
            }
        }
        
        stage('🏗️ Build Services') {
            parallel {
                stage('Build Anggota') {
                    steps {
                        echo "========== 🏗️ Building Anggota Service =========="
                        dir('anggota') {
                            sh 'mvn clean package -DskipTests -q'
                            sh 'ls -lh target/*.jar'
                        }
                    }
                }
                
                stage('Build Buku') {
                    steps {
                        echo "========== 🏗️ Building Buku Service =========="
                        dir('buku') {
                            sh 'mvn clean package -DskipTests -q'
                            sh 'ls -lh target/*.jar'
                        }
                    }
                }
                
                stage('Build Peminjaman') {
                    steps {
                        echo "========== 🏗️ Building Peminjaman Service =========="
                        dir('peminjaman') {
                            sh 'mvn clean package -DskipTests -q'
                            sh 'ls -lh target/*.jar'
                        }
                    }
                }
                
                stage('Build Pengembalian') {
                    steps {
                        echo "========== 🏗️ Building Pengembalian Service =========="
                        dir('pengembalian') {
                            sh 'mvn clean package -DskipTests -q'
                            sh 'ls -lh target/*.jar'
                        }
                    }
                }
                
                stage('Build API Gateway') {
                    steps {
                        echo "========== 🏗️ Building API Gateway =========="
                        dir('api-gateway') {
                            sh 'mvn clean package -DskipTests -q'
                            sh 'ls -lh target/*.jar'
                        }
                    }
                }
            }
        }
        
        stage('🧪 Unit Tests') {
            parallel {
                stage('Test Anggota') {
                    steps {
                        echo "========== 🧪 Testing Anggota Service =========="
                        dir('anggota') {
                            sh 'mvn test -q' 
                        }
                    }
                }
                
                stage('Test Buku') {
                    steps {
                        echo "========== 🧪 Testing Buku Service =========="
                        dir('buku') {
                            sh 'mvn test -q'
                        }
                    }
                }
                
                stage('Test Peminjaman') {
                    steps {
                        echo "========== 🧪 Testing Peminjaman Service =========="
                        dir('peminjaman') {
                            sh 'mvn test -q'
                        }
                    }
                }
                
                stage('Test Pengembalian') {
                    steps {
                        echo "========== 🧪 Testing Pengembalian Service =========="
                        dir('pengembalian') {
                            sh 'mvn test -q'
                        }
                    }
                }
            }
        }
        
        stage('📦 Build Docker Images') {
            steps {
                echo "========== 📦 Building Docker Images =========="
                // Pastikan permission docker.sock sudah diatur (sudo chmod 666 /var/run/docker.sock)
                sh '''
                    echo "Building Docker images from docker-compose..."
                    docker-compose build --no-cache
                '''
            }
        }
        
        stage('🚀 Deploy (Optional)') {
            when {
                branch 'main'
            }
            steps {
                echo "========== 🚀 Deployment Stage =========="
                sh '''
                    echo "Stopping existing containers..."
                    docker-compose down || true
                    
                    echo "Starting new containers..."
                    docker-compose up -d
                    
                    sleep 10
                    echo "Containers status:"
                    docker-compose ps
                '''
            }
        }
        
        stage('✅ Health Check') {
            when {
                branch 'main'
            }
            steps {
                echo "========== ✅ Health Check Stage =========="
                sh '''
                    echo "Checking service health..."
                    for i in {1..10}; do
                        # Cek port 8080 (API Gateway default) atau port lain yang sesuai
                        if curl -f http://localhost:8080/actuator/health || curl -f http://localhost:8081/actuator/health; then
                            echo "✅ Services are healthy!"
                            exit 0
                        fi
                        echo "Waiting for services to start... (attempt $i/10)"
                        sleep 5
                    done
                    echo "⚠️ Services took longer to start, continuing..."
                '''
            }
        }
    }
    
    post {
        always {
            echo "========== 📊 Post Build Actions =========="
            sh 'docker images | head -10'
        }
        
        success {
            echo "✅ Pipeline succeeded!"
            // Pindahkan cleanWs ke sini agar log failure tidak terhapus jika gagal
            cleanWs()
        }
        
        failure {
            echo "❌ Pipeline failed!"
            // Log ini akan sukses muncul sekarang karena workspace belum dihapus
            sh 'docker-compose logs || true'
        }
    }
}