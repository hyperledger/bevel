# r3-corda

## About
This folder contains Jenkinsfile required for automation.
* Input configuration - platforms/r3-corda/configuration/samples/network.yaml
* Jenkinsfile - NMS.Jenkinsfile,Doorman.Jenkinsfile,Jenkinsfile(Corda over single/multi cluster)
## Description
* ### **network.yaml** - The details of the network(to be deployed) needs to be added/updated in the file such as name of nodes,subject of nodes, number of nodes,service ports,vault and gitops details etc.

Here is the base network.yaml looks like:
```sh
network:
  type: corda
  version: 4.0
  docker:
    url:
    username:
    password:
    kube_secret:
    email:
 organizations:
   organization:
     doorman:
       nodeName: doorman
       subject: "CN=DLT Root CA, OU=DLT, O=DLT, L=London, ST=London, C=BR"
       service:
         port: 8080
         targetPort: 8080
     nms:
     notaries:
     nodes:
}
```
* ### **Jenkinsfile** -  Its a text file that contains the definition of a Jenkins Pipeline and is checked into source control. various task will be automated under different stages.
## Common environment file used for Jenkinsfile
Field name | Description
-----------|-------------
DOCKER_REGISTRY_AZURE|name of azure registry
DOCKER_USERNAME|docker username
DOCKER_CREDS|credentials id
DOCKER_DOORMAN_IMAGE_NAME|image name
## Doorman.Jenkinsfile - To containerise doorman docker image
**Task to automate** : Create doorman docker image and push to Azure registry

##### **Stages** : 
**Stage: maven clean install**
- Use maven to create `doorman.jar`
- agent used `maven-jdk-8`
- Install `nodejs` as maven uses `npm` for build
- Change folder to `CodeBaseForDoormanAndNetworkMap/doorman/`
- do `mvn clean install -DskipTests`
- stash the `doorman.jar` for next stage to use

**Stage: Docker build and push**
- Agent used `docker`
- unstash `doorman.jar` stash from **stage: maven clean install**
- Create a `Dockerfile` from source `docker-files/Dockerfile-Doorman`
- Use docker to login to registry, build image and push to registry

Here is how the file looks like:
```sh
stage('Docker build and push'){
    agent { label 'docker' }
    steps {
        script {
            unstash 'doorman.jar'
            sh '''
                cp docker-files/Dockerfile-Doorman CodeBaseForDoormanAndNetworkMap/doorman/Dockerfile
                cd CodeBaseForDoormanAndNetworkMap/doorman/
            '''
            docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_CREDS}") {
                def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_DOORMAN_IMAGE_NAME}", "CodeBaseForDoormanAndNetworkMap/doorman/")
                image.push("${env.BUILD_NUMBER}")
                image.push("latest")
            }
        }
    }
}
```
## NMS.Jenkinsfile - To containerise NMS docker image
**Task to automate** : Create NMS docker image and push to Azure registry
##### **Stages** : 
**Stage: maven clean install**
- Use maven to create `network-map-service.jar`
- agent used `maven-jdk-8`
- Install `nodejs` as maven uses `npm` for build
- Change folder to `CodeBaseForDoormanAndNetworkMap/networkmap/`
- do `mvn clean install -DskipTests`
- stash the `network-map-service.jar` for next stage to use


**Stage: Docker build and push**
- Agent used `docker`
- unstash `network-map-service.jar` stash from **stage: maven clean install**
- Create a `Dockerfile` from source `docker-files/Dockerfile-Networkmap `
- Use docker to login to registry, build image and push to registry
```sh
stage('Docker build and push'){
    agent { label 'docker' }
    steps {
        script {
            unstash 'network-map-service.jar'
            sh '''
                cp docker-files/Dockerfile-Networkmap CodeBaseForDoormanAndNetworkMap/networkmap/Dockerfile
                cd CodeBaseForDoormanAndNetworkMap/networkmap/
            '''
            docker.withRegistry("https://${DOCKER_REGISTRY_AZURE}", "${DOCKER_CREDS}") {
                def image = docker.build("${DOCKER_REGISTRY_AZURE}/${DOCKER_NMS_IMAGE_NAME}", "CodeBaseForDoormanAndNetworkMap/networkmap/")
                image.push("${env.BUILD_NUMBER}")
                image.push("latest")
            }
        }
    }
}
```
## Jenkinsfile  - This file enables deployment of corda over single/multi managed Kubernetes cluster 
**Task to automate** : Create single pipeline to automate the entire network creation process.
##### **Jenkins pipeline for corda**:  pipeline does the following
  1. creates the specific network.yaml from the sample by replacing keys with values
 2. Sets up ansible environment and kubernetes environment
 3. Deploys fabric network according to the specifications of network.yaml
 4. Creates a channel according to the specifications of network.yaml
##### **Input Variables**
Pipeline uses environment variables which are defaulted within the Jenkinsfile.
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

##### **Stages in the Pipeline**

##### 1. Get K8 configs from terraform job
It fetches the kube config file from the cluster creation pipeline.
##### 2. Generate corda Configuration
It generates the Fabric Configuration file by replacing the keys with values.
##### 3. Add AWS Details to Configuration
It Adds the AWS Details to Configuration.
##### 4. Deploy Corda Network
Run deploy-network playbook which will setup environment and deploy the network
###### NOTE: Please copy the FLUX SSH KEY generated and provide read-write access to this key on the git repo

### Folder Structure ###
```
/automation
|-- r3-corda
|   |-- Doorman.Jenkinsfile
|   |-- NMS.Jenkinsfile
|   |-- Jenkinsfile
|   |-- README.md
```