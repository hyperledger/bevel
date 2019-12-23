// Pipeline to build docker images for Corda or Fabric
// For Corda we build: springboot-webserver and express-nodejs images
// For Fabrci we build: rest-server and express-nodejs images
pipeline {
    agent {
        label 'docker-large' // use docker-large agent
    }

    environment {
        // Path for Docker registry server
        DOCKER_REGISTRY_AZURE = 'adopblockchaincloud0502.azurecr.io'

        //Credentials for Docker registry server taken from Jenkins credentials
        DOCKER_REGISTRY_AZURE_CREDENTIALS = 'azure_registry_creds'

        //Docker Image variabes		
        DOCKER_REPO_PATH_CORDA = 'supplychain_corda'        
        DOCKER_REPO_PATH_FABRIC = 'supplychain_fabric'
        DOCKER_IMAGE_PREFIX_EXPRESS = 'express_app'
        DOCKER_IMAGE_PREFIX_REST = 'rest_server'
        DOCKER_IMAGE_PREFIX_WEBAPP = 'springboot_server'
    }

    parameters {
        //Choice of platform, add new when new platforms get introduced in The Blockchain Automation Framework
        choice(choices: 'R3-Corda\nHyperledger-Fabric', description: 'What is the DLT Platform?', name: 'DLT_PLATFORM')
    }
    
    stages {
        stage('Build Corda Webapp') {
            when {
                expression {
                    params.DLT_PLATFORM.toLowerCase() == 'r3-corda'
                }
            }
            agent {
                label 'gradleslave' // use a gradle based agent
            }            
            steps {
                //Perform gradle build of Webapps from this folder
                dir('examples/supplychain-app/corda/cordApps_springBoot/') {
                    sh """
                        echo 'Java version is ...'
                        java -version
                        
                        echo 'Ensuring correct permissions ...'
                        chmod +x ./gradlew

                        echo 'Cleaning up any previous builds (if not using one shot slave) ...'
                        ./gradlew clean
                        ./gradlew deployWebapps
                    """
                }
                echo 'Stashing files for later use in another slave ...'
                // Stash files so that another slave can use these
                stash name: 'binary', includes: '**/*.jar', excludes: '**/.git,**/.git/**'
            }
        }
        stage('Build images for Corda') {
            when {
                expression {
                    params.DLT_PLATFORM.toLowerCase() == 'r3-corda'
                }
            }
            steps {
                echo 'Build express image from examples/supplychain-app/corda/express_nodeJS path'
                dir('examples/supplychain-app/corda/express_nodeJS/'){
                    echo 'Building docker image ...'
                    script {
                        docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_REGISTRY_AZURE_CREDENTIALS}") {
                            def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_REPO_PATH_CORDA}/${DOCKER_IMAGE_PREFIX_EXPRESS}:${env.BUILD_ID}", ".")                        
                            image.push()
                            /* to push a docker image with 'latest' tag */
                            image.push('latest')
                        }
                    }                
                }
                echo 'Retrieving files from stash ...'
                // Copy stashed artefacts from gradle slave
                unstash 'binary'
                dir('examples/supplychain-app/corda/cordApps_springBoot/') {
                    sh 'ls -lat build/webapps/'
                    echo 'Building docker image ...'
                    script {
                        docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_REGISTRY_AZURE_CREDENTIALS}") {
                            def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_REPO_PATH_CORDA}/${DOCKER_IMAGE_PREFIX_WEBAPP}:${env.BUILD_ID}", ".")                        
                            image.push()
                            /* to push a docker image with 'latest' tag */
                            image.push('latest')
                        }
                    }
                }
            }
        }
        stage('Build images for Fabric') {
            when {
                expression {
                    params.DLT_PLATFORM.toLowerCase() == 'hyperledger-fabric'
                }
            }
            steps {                              
                echo 'Build rest-server image from examples/supplychain-app/fabric/chaincode_rest_server/rest-server/ path'                
                dir('examples/supplychain-app/fabric/chaincode_rest_server/rest-server/'){
                    echo 'Building docker image ...'
                    script {
                        docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_REGISTRY_AZURE_CREDENTIALS}") {
                            def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_REPO_PATH_FABRIC}/${DOCKER_IMAGE_PREFIX_REST}:${env.BUILD_ID}", ".")                        
                            image.push()
                            /* to push a docker image with 'latest' tag */
                            image.push('latest')
                        }
                    }                
                }
                echo 'Build express image from examples/supplychain-app/fabric/express_nodeJs path'
                dir('examples/supplychain-app/fabric/express_nodeJs/'){                    
                    echo 'Building docker image ...'
                    script {
                        docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_REGISTRY_AZURE_CREDENTIALS}") {
                            def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_REPO_PATH_FABRIC}/${DOCKER_IMAGE_PREFIX_EXPRESS}:${env.BUILD_ID}", ".")                        
                            image.push()
                            /* to push a docker image with 'latest' tag */
                            image.push('latest')
                        }
                    }
                }
            }
        }
    }
}