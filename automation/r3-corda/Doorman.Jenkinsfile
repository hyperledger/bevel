// This jenkinsfile is trying to automate doorman docker image build and push to Azure registry

//   Stage : maven clean install (doorman.jar)
// - Install prerequisite for npm (nodejs)
// - maven build doorman.jar
// - stash doorman for next stage to use

//   Stage : Docker build and push
// - unstash `doorman.jar`
// - Create a Dockerfile
// - using docker.registry to login, build and push docker image

// pipeline
pipeline {
    // agent
    agent any

    // environment
    environment {
        DOCKER_REGISTRY_AZURE = 'adopblockchaincloud0502.azurecr.io'
        DOCKER_USERNAME = 'ADOPBlockchainCloud0502'
        DOCKER_CREDS = 'azure_registry_creds'
        DOCKER_DOORMAN_IMAGE_NAME = 'doorman'
    }

    // Stages
    stages {

        // Stage : maven clean install
        // Create doorman.jar using maven install
        stage('maven clean install'){
            // Use `maven-jdk-8` agent
            agent { label 'maven-jdk-8' }

            steps {
                // to make npm available to maven -
                // - Install curl
                // - Install nodejs
                // - npm available
                // - change direcotry to `images/doorman/`
                // - create `doorman.jar` using `mvn clean install`

                sh '''
                    echo 'installing curl ...'
                    apt-get install curl
                    echo 'installing node'
                    curl -sL https://deb.nodesource.com/setup_8.x | bash -
                    echo 'installing nodejs'
                    apt-get install -y nodejs
                    node -v
                    npm -v
                    cd platforms/r3-corda/images/doorman/
                    mvn clean install -DskipTests
                '''
                // stash the doorman.jar for next stage to use
                stash name: 'doorman.jar', includes: '**/target/*.jar'
            }
        }

        // Stage : Docker build and push
        // Use Docker to build and push image to Azure registry
        stage('Docker build and push'){
            // Use docker agent
            agent { label 'docker' }
            steps {

                script {
                    // - unstash `doorman.jar`
                    unstash 'doorman.jar'

                    // Create a `Dockerfile` from source `docker-files/Dockerfile-Doorman`
                    // Change directory to `images/doorman/`
                    sh '''
                        ls
                        cd platforms/r3-corda/images/doorman/
                        ls
                        ls ./target
                    '''
                    // Use docker to login to registry 
                    // - build image
                    // - push image with `BUILD_NUMBER` and `latest` version
                    docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_CREDS}") {
                        def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_DOORMAN_IMAGE_NAME}", "platforms/r3-corda/images/doorman/")
                        image.push("${env.BUILD_NUMBER}")
                        image.push("doorman-linuxkit")
                    }
                }
            }
        }
    }
}