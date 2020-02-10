// Pipeline to deploy Corda Springboot server and Express API
pipeline {
    agent {
        label 'ansible' // use an ansible based agent
    }
    environment {
        //Define common variables
        //GIT repo links
        GITOPS_REPO="github.com/hyperledger-labs/blockchain-automation-framework.git"
        //SSH version is also needed
        GITOPS_SSH="ssh://git@github.com:hyperledger-labs/blockchain-automation-framework.git"
        //Release path for Corda
        REL_PATH_CORDA="platforms/r3-corda/releases/dev"
        //Release path for Fabric
        REL_PATH_FABRIC="platforms/hyperledger-fabric/releases/dev"
        //Path for charts that will be deployed
        CHART_PATH="examples/supplychain-app/charts"
        //Service User credentials from Jenkins used to check-in to git
        GIT_CREDS="blockofz_serviceuser"
        //Store root directory
        ROOT_DIR="${pwd()}"
        //Docker registry
        DOCKER_REGISTRY = "adopblockchaincloud0502.azurecr.io"
        REACT_APP_GMAPS_KEY = credentials('google_maps_key_global')
    }
    parameters {
        choice(choices: 'R3-Corda\nHyperledger-Fabric', description: 'What is the DLT Platform?', name: 'DLT_PLATFORM')
        choice(choices: 'EKS\nAKS\nGKE', description: 'What is the K8s provider?', name: 'K8S_PROVIDER')
        string(defaultValue: "http://ab6b5c26b92c511e986b1062a6468841-1059339764.eu-west-2.elb.amazonaws.com:8200", description: 'Vault Server address?', name: 'VAULT_ADDR')
        string(defaultValue: "develop", description: 'GitOps Release Branch', name: 'RELEASE_BRANCH')
    }

    stages {
        stage('Create Corda Configuration') {
            when {
                expression {
                    params.DLT_PLATFORM.toLowerCase() == 'r3-corda'
                }
            }
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
                    // Replace the sample corda network.yaml and fill in required parameters
                    dir('examples/supplychain-app/configuration/') {
                        sh """
                            cp samples/network-cordav2.yaml network.yaml
                            sed -i -e 's+docker_url+${DOCKER_REGISTRY}+g' network.yaml
                            sed -i -e 's+vault_addr+${params.VAULT_ADDR}+g' network.yaml
                            sed -i -e 's+gitops_ssh_url+${GITOPS_SSH}+g' network.yaml
                            sed -i -e 's+gitops_branch+${params.RELEASE_BRANCH}+g' network.yaml
                            sed -i -e 's+gitops_release_dir+${REL_PATH_CORDA}+g' network.yaml
                            sed -i -e 's+gitops_charts+${CHART_PATH}+g' network.yaml
                            sed -i -e 's+gitops_push_url+${GITOPS_REPO}+g' network.yaml
                            sed -i -e 's+git_username+${USERNAME}+g' network.yaml
                            sed -i -e 's+git_password+${PASSWORD}+g' network.yaml
                            sed -i -e 's+gmaps_key+${REACT_APP_GMAPS_KEY}+g' network.yaml
                        """
                    }
                }
            }
        }
        stage('Create Fabric Configuration') {
            when {
                expression {
                    params.DLT_PLATFORM.toLowerCase() == 'hyperledger-fabric'
                }
            }
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
                    // Replace the sample corda network.yaml and fill in required parameters
                    dir('examples/supplychain-app/configuration/') {
                        sh """
                            cp samples/network-fabricv2.yaml network.yaml
                            sed -i -e 's+docker_url+${DOCKER_REGISTRY}+g' network.yaml
                            sed -i -e 's+vault_addr+${params.VAULT_ADDR}+g' network.yaml
                            sed -i -e 's+gitops_ssh_url+${GITOPS_SSH}+g' network.yaml
                            sed -i -e 's+gitops_branch+${params.RELEASE_BRANCH}+g' network.yaml
                            sed -i -e 's+gitops_release_dir+${REL_PATH_FABRIC}+g' network.yaml
                            sed -i -e 's+gitops_charts+${CHART_PATH}+g' network.yaml
                            sed -i -e 's+gitops_push_url+${GITOPS_REPO}+g' network.yaml
                            sed -i -e 's+git_username+${USERNAME}+g' network.yaml
                            sed -i -e 's+git_password+${PASSWORD}+g' network.yaml
                            sed -i -e 's+gmaps_key+${REACT_APP_GMAPS_KEY}+g' network.yaml
                        """
                    }
                }
            }
        }
        stage('Deploy Supplychain App') {
            steps {
                 dir('examples/supplychain-app/configuration/') {
                    echo 'Run ansible playbook'
                    sh 'ansible-playbook deploy-supplychain-app.yaml -e "@./network.yaml"'
                }
            }
        }
    }
}
