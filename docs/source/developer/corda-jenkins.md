# Corda Pipelines
Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

## Jenkins in Blockchain Automation Framework
Jenkins in Blockchain Automation Framework is used to spin up R3 corda network on a given cloud environment. Jenkins file "JenkinsFile" is used for the  deployment of corda network.Jenkins file internally runs the Ansible playbooks which in-turn setup the following network components:
1. Namespaces, Service accounts and Clusterrolebindings
2. Certificate authority
3. Doorman
4. Networkmap service
5. Notary
6. Nodes

## Pre-requisites
1. Setup jenkins with slave configuration. If you are using your own Jenkins server, make sure that slaves are also configured.
2. AWS Cloud Subscription ( with EKS Zone enabled as Kubernetes is not available for all zones)
3. One IAM user created on AWS with rights to create and delete resources. Save the details of this use as a AWS credential on Jenkins with id as terraform_user. This id is used in the Jenkins file.
4. Vault setup. The vault address and token are passed as parameters in Jenkins configuration.

## Environment variable
Environment variable are defined in Jenkins file. These variables are passed to the ansible playbook.
1. **GITOPS_REPO**: Path of the git repository.
    eg GITOPS_REPO="github.com/hyperledger-labs/blockchain-automation-framework.git"
2. **GITOPS_SSH**: SSH path for git repo
    eg GITOPS_SSH="ssh://git@github.com/hyperledger-labs/blockchain-automation-framework.git"
3. **REL_PATH**: Relative path in the repo where files would pushed by GitOps
    eg REL_PATH="platforms/corda/releases/dev"
4. **CHART_PATH**: Path for the Helm Charts
    eg CHART_PATH = 'r3-corda/charts'
5. **GIT_CREDS**: Credentials to access the git repository
    eg GIT_CREDS="blockofz_serviceuser"       
6. **ROOT_DIR**: Root directory path . This is by default set to "${pwd()}"
    eg ROOT_DIR="${pwd()}"
7. **DOCKER_REGISTRY**: Docker registry to store docker images 
    eg DOCKER_REGISTRY= "index.docker.io/hyperledgerlabs"
8. **DOCKER_USERNAME**: Username for docker registry
    eg DOCKER_USERNAME = 'hyperledgerlabs'
9. **DOCKER_PASSWORD**: Password for docker registry. Password has to be stored in  Jenkins credentials
    eg DOCKER_PASSWORD = credentials('azure_container_password')
10. **KUBECONFIG**: Cluster config file name
    eg KUBECONFIG="${pwd()}/platforms/r3-corda/configuration/kube.yaml"

## Parameters
1. **VAULT_ADDR**: The complete Vault server address along with the port.
    eg http://aa6305c6592c511e9aaab02f438592f4-1279856826.eu-west-2.elb.amazonaws.com:8200
2. **VAULT_TOKEN**: Token of the vault. This parameter is of password type
3. **RELEASE_NEW**: Setup new release. Either yes or no has to be selected
4. **RELEASE_BRANCH**: Git branch value has to be specified.
    eg feature/demo_corda
5. **KUBE_PROJECT**: The job from which the kube config is derived.
6. **KUBE_FILE**: The kube config file name to be used.
7. **CLUSTER_CONTEXT**: The context of the cluster to be used (should be mentioned in the config file).
8. **REGION**: The AWS region where the cluster is deployed.
9. **RESET_ACTION**: Delete the existing network. Either yes or no has to be selected.
