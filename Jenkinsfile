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
        stage('Build Docker image'){
            steps{
                   container('docker'){
                        script{
                            docker_image = docker.build "${IMAGE_NAME}"
                         
                        }
                   }
                
            }
        }
        stage('Login Into Dockerhub'){
            steps{
               container('docker'){
                script{
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                        sh 'docker login -u $user --password $pass'
                        sh 'docker_image.push ${BUILD_NUMBER}'
                    }
                    
                }
               }
            }

        }
       
        stage('Delete Docker Image'){
            steps{
                container('docker'){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                    script{
                        sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker rmi ${IMAGE_NAME}:latest"
                    }
                }
            }
        }
        stage('Updating K8s deployment'){
            steps{
                container('docker'){
                    script{
                         sh "cat deployment.yaml"
                         sh "sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yaml"
                         sh "cat deployment.yaml"
                    }
                }
            }
        }
        stage('Update deployment file'){
            steps{
                script{
                    sh """
                        git config user.name "bruceherve"
                        git config user.email "hernino25@gmail.com"
                        git add deployment.yaml
                        git commit -m 'Updated the deployment file'"""

                        withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'pass', usernameVariable: 'user')]) {
                            sh "git push https://${user}:${pass}@github.com/${user}/go-fiber-api.git HEAD:main"
                        }
                }
            }
            
        }
    }
}