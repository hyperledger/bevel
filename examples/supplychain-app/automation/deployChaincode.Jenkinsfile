// Pipeline to build the SmartContracts (Cordapps using Gradle build, or chaincode) and then deploy using ansible
// TODO Add Unit test
// TODO Add Sonar Analysis
pipeline {
    agent {
        label 'ansible' // use a ansible based agent
    }
    environment {
        //Define common variables
        //GIT repo links
        GITOPS_REPO="github.com/hyperledger-labs/blockchain-automation-framework.git"
        //SSH version is also needed
        GITOPS_SSH="ssh://git@github.com/hyperledger-labs/blockchain-automation-framework.git"
        //Release path for Fabric
        REL_PATH="platforms/hyperledger-fabric/releases/dev"
        //Path for charts that will be deployed
        CHART_PATH="platforms/hyperledger-fabric/charts"
        //Service User credentials from Jenkins used to check-in to git
        GIT_CREDS="blockofz_serviceuser"
        //Store root directory
        ROOT_DIR="${pwd()}"
        //Docker registry address
        DOCKER_REGISTRY = "adopblockchaincloud0502.azurecr.io"		    
        //username for docker registry 
        DOCKER_USERNAME = 'ADOPBlockchainCloud0502'
        //password for docker registry taken from Jenkins credentials
        DOCKER_PASSWORD = credentials('azure_container_password')

        //KUBECONFIG file to connect to the single cluster. This file is replace when pipeline runs
        // by the choice you make in the build/input parameters
        KUBECONFIG="${pwd()}/platforms/hyperledger-fabric/configuration/kubeconfig.yaml"
        
        //GOPATH for build chaincode
        GOPATH="${pwd()}/go"
    }
    parameters {
        string(defaultValue: "http://aa6305c6592c511e9aaab02f438592f4-1279856826.eu-west-2.elb.amazonaws.com:8200", description: 'Vault Server address?', name: 'VAULT_ADDR')
        password(defaultValue: "", description: 'Vault root token?', name: 'VAULT_TOKEN')
        string(defaultValue: "release/corda0200", description: 'GitOps Release Branch', name: 'RELEASE_BRANCH')
        string(defaultValue: 'deploy-infra-aws-org3', description: 'Which job to get Kubeconfig from?', name: 'KUBE_PROJECT')
        string(defaultValue: 'kube_user.yaml', description: 'Which Kubeconfig filename to use?', name: 'KUBE_FILE')
        string(defaultValue: 'fabric-org3-cluster', description: 'Kluster name?', name: 'CLUSTER_CONTEXT')
        string(defaultValue: 'eu-west-1', description: 'AWS Region?', name: 'REGION')
        // Following are chaincode specific variables
        string(defaultValue: "examples/supplychain-app/fabric/chaincode_rest_server/chaincode", description: 'Chaincode Folder path?', name: 'CHAINCODE_SRC')
        choice(choices: 'supplychain\nXXXX', description: 'Chaincode to install?', name: 'CHAINCODE_ID')
        string(defaultValue: '4.0', description: 'Define Chaincode version', name: 'CHAINCODE_VERSION')
        string(defaultValue: '\"init\",\"\"', description: 'Chaincode Arguments?', name: 'CHAINCODE_ARGS')
        string(defaultValue: 'cmd', description: 'Chaincode Main Directory?', name: 'CHAINCODE_MAIN')
        choice(choices: 'Yes\nNo', description: 'Install Chaincode?', name: 'INSTALL_ACTION')
        choice(choices: 'No\nYes', description: 'Upgrade Chaincode?', name: 'UPGRADE_ACTION')
        
    }

    stages {
        
        stage( 'Build Chaincode and Unit Test' ){            
            steps {
                script{
                    def root = tool name: 'Go 1.8', type: 'go'

                    dir('examples/supplychain-app/fabric/chaincode_rest_server/'){
                        withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin", "INSTALL_DIRECTORY=${root}/bin"]) {
                            sh 'go version'
                            sh """
                                apt-get update
                                apt-get install build-essential -y
                                curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
                            """
                            sh """
                                echo 'copying chaincode folder'
                                mkdir -p ${GOPATH}/src/github.com/ && cp -r chaincode ${GOPATH}/src/github.com/
                                cd ${GOPATH}/src/github.com/chaincode
                                dep ensure
                            """
                        }
                    }
                    
                    dir('examples/supplychain-app/fabric/chaincode_rest_server/'){
                        withEnv(["GOROOT=${root}", "PATH+GO=${root}/bin"]) {
                            sh 'go version'
                            sh """
                                echo 'run go test' 
                                go test github.com/chaincode/supplychain
                            """
                        }
                    }
                }
            }
        }
        
        /*
		 *  Fetching the kube config file from the cluster creation pipeline
		 *  "KUBE_PROJECT" variable contains the cluster creation pipeline name
		 *  "selector" variable determines the last successful build of cluster creation
		 *  "target" variable defines the location of the cluster configuration file path in Jenkins VM
		 */
        stage('Get K8 configs from terraform job') {
            steps {
                copyArtifacts filter: 'kubernetes/*', fingerprintArtifacts: true, projectName: "${params.KUBE_PROJECT}", selector: lastSuccessful(), target: 'platforms/hyperledger-fabric/configuration'
                sh """
					 ls -lat platforms/hyperledger-fabric/configuration/kubernetes
                     cp platforms/hyperledger-fabric/configuration/kubernetes/${params.KUBE_FILE} ${KUBECONFIG}
                """
            }
        }
        /*
		 *  Create the Fabric configuration file
		 */
        stage('Create Fabric Configuration') {
            steps {
                //WithCredentials to get the username and password for GIT user
                withCredentials([
                     usernamePassword(credentialsId: "${GIT_CREDS}", 
                     usernameVariable: 'USERNAME', 
                     passwordVariable: 'PASSWORD'
                )]) {
                    script {
                        //encode the username and password
                        env.encodedGitName=URLEncoder.encode(USERNAME, "UTF-8")
                        env.encodedGitPass=URLEncoder.encode(PASSWORD, "UTF-8")
                    }
                    // Replace the sample fabric network.yaml and fill in required parameters
                    dir('platforms/hyperledger-fabric/configuration/') {
                        sh """
                            cp samples/network-fabricv2.yaml network.yaml
                            sed -i -e 's*docker_url*${DOCKER_REGISTRY}*g' network.yaml
                            sed -i -e 's*docker_username*${DOCKER_USERNAME}*g' network.yaml
                            sed -i -e 's*docker_password*${DOCKER_PASSWORD}*g' network.yaml
                            sed -i -e 's*vault_addr*${params.VAULT_ADDR}*g' network.yaml
                            sed -i -e 's*vault_root_token*${params.VAULT_TOKEN}*g' network.yaml                            
                            sed -i -e 's*gitops_ssh_url*${GITOPS_SSH}*g' network.yaml                            
                            sed -i -e 's*gitops_branch*${params.RELEASE_BRANCH}*g' network.yaml
                            sed -i -e 's*gitops_release_dir*${REL_PATH}*g' network.yaml
                            sed -i -e 's*gitops_charts*${CHART_PATH}*g' network.yaml
                            sed -i -e 's*gitops_push_url*${GITOPS_REPO}*g' network.yaml
                            sed -i -e 's*git_username*${USERNAME}*g' network.yaml
                            sed -i -e 's+git_password+${PASSWORD}+g' network.yaml
                            sed -i -e 's*cluster_region*${params.REGION}*g' network.yaml
                            sed -i -e 's*cluster_context*${params.CLUSTER_CONTEXT}*g' network.yaml
                            sed -i -e 's*cluster_config*${KUBECONFIG}*g' network.yaml
                        """
                    }
                }
            }
        }
        stage('Add AWS Details to Configuration') {
            steps {
                //WithCredentials to get the username and password for AWS Account
                //TODO: Use when statement when multiple cloud provider is available
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'terraform_user',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // Add AWS specific parameters
                    dir('platforms/hyperledger-fabric/configuration/') {
                        sh """
                            sed -i -e 's+aws_access_key+${AWS_ACCESS_KEY_ID}+g' network.yaml
                            sed -i -e 's+aws_secret_key+${AWS_SECRET_ACCESS_KEY}+g' network.yaml                           
                        """
                    }
                }
            }
        }
        
        stage('Add Chaincode to Configuration') {
            steps {                
                // Add Chaincode specific parameters
                dir('platforms/hyperledger-fabric/configuration/') {
                    sh """
                        sed -i -e 's+chaincode_name+${params.CHAINCODE_ID}+g' network.yaml
                        sed -i -e 's+chaincode_version+${params.CHAINCODE_VERSION}+g' network.yaml                           
                        sed -i -e 's+chaincode_main+${params.CHAINCODE_MAIN}+g' network.yaml
                        sed -i -e 's+chaincode_src+${params.CHAINCODE_SRC}+g' network.yaml
                        sed -i -e 's+chaincode_args+${params.CHAINCODE_ARGS}+g' network.yaml
                    """
                }
            }
        }

        // Execute install and instantiate when INSTALL_ACTION is yes
        stage('Deploy and Instantiate Chaincode') {
            when {
                expression {
                    params.INSTALL_ACTION.toLowerCase() == 'yes'
                }
            }
            steps {
                dir('platforms/hyperledger-fabric/configuration/') {
                    sh """
                        ansible-playbook ../../shared/configuration/site.yaml -e "@./network.yaml" -e "chaincode_install=yes"
                    """
                }
            }
        }

        // TODO Add Upgrade and Test chaincode
    }
}
