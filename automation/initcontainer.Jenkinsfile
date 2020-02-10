// This jenkinsfile is trying to automate init container valut docker image build and push to Azure registry

//   Stage : Docker build and push
// - Create a Dockerfile
// - using docker.registry to login, build and push docker image

//pipeline
pipeline {
    //agent
    agent any
    
    environment {
        DOCKER_REGISTRY_AZURE = 'adopblockchaincloud0502.azurecr.io'
        DOCKER_USERNAME = 'ADOPBlockchainCloud0502'
        DOCKER_CREDS = 'azure_registry_creds'
        DOCKER_INITCONTAINER_IMAGE_PREFIX = 'alpine-utils'
    }
    stages{
        // Stage : Docker build and push
        // Use Docker to build and push image to Azure registry
        stage('Docker build and push'){
            // use 'docker' agent
             agent { label 'docker' }
            steps {
                script { 
                    sh '''
                    ls
                    cp platforms/shared/docker-files/alpine-utils.Dockerfile platforms/shared/Dockerfile
                    cd platforms/shared
                    ls       
                    '''
                     // Use docker to login to registry 
                    // - build image
                    // - push image with `BUILD_NUMBER` and `latest` version
                    docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_CREDS}") {
                        def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_INITCONTAINER_IMAGE_PREFIX}", "platforms/shared/")
                        image.push("${env.BUILD_NUMBER}")
                        image.push("latest")
                }
            }
        }
    }
}
}
