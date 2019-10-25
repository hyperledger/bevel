# Hyperledger Fabric Automation
This folder consists of 
1. Fabric.Jenkinsfile
2. Network.yaml


## Jenkins pipeline for Fabric
This file enables deployment of fabric over single managed Kubernetes cluster. 
This pipeline does the following
 1. creates the specific network.yaml from the sample by replacing keys with values
 2. Sets up ansible environment and kubernetes environment
 3. Deploys fabric network according to the specifications of network.yaml
 4. Creates a channel according to the specifications of network.yaml

#### Input Variables
Pipelineuses environment variables which are defaulted within the Jenkinsfile.
    GITOPS_REPO = GIT repo links
    GITOPS_SSH = GIT repo SSH link
    REL_PATH = Release path for Fabric
    CHART_PATH = Path for charts that will be deployed
    GIT_CREDS = Service User credentials from Jenkins used to check-in to git
    ROOT_DIR = Store root directory
    DOCKER_REGISTRY = Docker registry address		    
    DOCKER_USERNAME = username for docker registry 
    DOCKER_PASSWORD = password for docker registry taken from Jenkins credentials
    KUBECONFIG=KUBECONFIG file to connect to the single cluster. This file is replace when the pipeline runs.

#### Stages in the Pipeline

##### 1. Get K8 configs from terraform job
It fetches the kube config file from the cluster creation pipeline.
##### 2. Generate Fabric Configuration
It generates the Fabric Configuration file by replacing the keys with values.
##### 3. Add AWS Details to Configuration
It Adds the AWS Details to Configuration.
##### 4. Reset existing network
If RESET_ACTION is yes, delete the network
###### NOTE: The Flux installation is also deleted, so you have to provide write access to FLUX SSH KEY Again
##### 5. Deploy Fabric Network and create channel
Execute site.yaml which will setup environment and deploy the network
###### NOTE: Please copy the FLUX SSH KEY generated and provide read-write access to this key on the git repo

-------

### Getting Started
Below are the set of instructions to deploy the Fabric nodes on AWS cluster. This folder has Jenkins file "Fabric.JenkinsFile" for deployment of Fabric node 

### Prerequisites
1. Jenkins with slave configurations. This project uses ADOP which has a pre-defined Jenkins slaves. If you are using your own Jenkins server, make sure that slaves are also configured.
2. AWS Cloud Subscription ( with EKS Zone enabled as Kubernetes is not available for all zones)
3. One IAM user created on AWS with rights to create and delete resources. Save the details of this use as a AWS credential on Jenkins with id as terraform_user. This id is used in the Jenkin file.
4. One git repository to  push the  files. This repository name have to updated  in the Fabric.Jenkins file.
5. Vault setup. The vault address and token are used in Jenkins file. 

### Steps to configure pipeline
1. On Jenkins portal, click "New Item" from the left menu, provide a name, and select Pipeline from the options. Then click "OK".
2. In the Pipeline section below, select "Pipeline script from SCM". All other sections can be left as default or configured according to your project needs.
3. Select "Git" from the "SCM" dropdown and provide the Repository URL and branch where the jenkinsfile is stored. Also select a "Credential" from the dropdown.
4. Change the "Script Path" to Fabric.Jenkinsfile. Keep all other values as default.
5. Save and pipeline is configured.
6. Create credentials in global credentials. Save the credentials as service.account and add  username and password for the git account.
7. Change the defaults value of  VAULT_ADDR, VAULT_TOKEN, check-in the changes and then run the pipeline.
8. Go to the created pipeline on Jenkins portal, and click "Build" or "Build with parameters" from the left menu. For first run, the build will take the default parameters from the jenkinsfiles, in subsequent runs, you will be able to choose the parameter on Jenkins.
9. Select the appropriate option and click "Build". The pipeline will start and you can see the progress.
10. Check the "Console output" for detailed output.

## Network file for User input
network.yaml file consists of the network details of the orderers, organizations, peers, channels and network components such as genesis block profile name. The details of the network(to be deployed) needs to be added/updated in the file.



