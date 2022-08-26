pipeline{
    agent{
        kubernetes{
             yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock    
        '''
        }
    }
    environment{
        DOCKERHUB_USERNAME = "hernino"
        APP_NAME = "go-fiber-api"
        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
        REGISTRY_CREDS = 'dockerhub'
    }
    stages{
        stage('Clone'){
            steps{
                container('docker'){
                    git branch: 'main', changelog: false, poll: false, url: 'https://github.com/bruceherve/go-fiber-api.git'
                }
            }
        }
        stage('Check Docker version'){
            steps{
                container('docker'){
                    sh "docker version"
                }
            }
        }
        stage('Build Docker Image'){
            steps{
                container('docker'){
                   sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                   sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }
        stage('Push Docker Image'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-login-creds', passwordVariable: 'password', usernameVariable: 'username')]){
                    /**
                    * Restart docker server
                    **/
                    sh '''
                        echo "${pass} | docker login -u ${user} --password-stdin"
            
                    '''
                }
            }
        }
    }
}