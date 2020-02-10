// This jenkinsfile is trying to automate nms docker image build and push to Azure registry
//   Stage : maven clean install (network-map-service.jar)
// - Install prerequisite for npm (nodejs)
// - maven build network-map-service.jar
// - stash network-map-service.jarfor next stage to use

//   Stage : Docker build and push
// - unstash `network-map-service.jar`
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
        DOCKER_NMS_IMAGE_PREFIX = 'nms'
    }
    //stages
    stages {
         // Stage : maven clean install
        // Create network-map-service.jar.jar using maven install
        stage('maven clean install'){
            // Use `maven-jdk-8` agent
            agent { label 'maven-jdk-8' }
            steps {
                // to make npm available to maven -
                // - Install curl
                // - Install nodejs
                // - npm available
                // - change direcotry to `images/networkmap/`
                // - create `network-map-service.jar.jar` using `mvn clean install`
                sh '''
		        echo 'installing curl'
                apt-get install curl
                echo 'installing node'
                curl -sL https://deb.nodesource.com/setup_8.x | bash -
                apt-get install -y nodejs
                node -v
                npm -v
                cd platforms/r3-corda/images/networkmap/
                mvn clean install -DskipTests
                '''
                // stash the network-map-service.jar for next stage to use
                stash name: 'network-map-service.jar', includes: '**/target/*.jar'
                sh "ls"
            }
        }
        // Stage : Docker build and push
        // Use Docker to build and push image to Azure registry
        stage('Docker build and push'){
            // use 'docker' agent
             agent { label 'docker' }
            steps {
                script { 
                     // unstash network-map-service.jar
                     unstash 'network-map-service.jar'
                    sh '''
                    ls
                    cd platforms/r3-corda/images/networkmap/
                    ls
                    ls ./target
                    '''
                     // Use docker to login to registry 
                    // - build image
                    // - push image with `BUILD_NUMBER` and `latest` version
                    docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_CREDS}") {
                        def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_NMS_IMAGE_PREFIX}", "platforms/r3-corda/images/networkmap/")
                        image.push("${env.BUILD_NUMBER}")
                        image.push("networkmap-linuxkit")
                }
            }
        }
    }
}
}