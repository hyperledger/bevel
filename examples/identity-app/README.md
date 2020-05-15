# Identity-App

## About
This folder contains the files that are needed for the deployment of a Identity Application on a Indy network that has been created using the Blockchain Automation Framework.

## Folder structure
```
identity-app
|-- charts: this folder contains the Helm charts that are needed for the deployment of the Identity Application.
|-- images: this folder contains the Docker images that are needed for running of the Identity Application.
```

## Pre-requisites

* A network with 2 organizations:
    * Authority
        * 1 Trustee
    * University
        * 4 Steward nodes
        * 1 Endorser
* A Docker repository

## Deploy Identity Application
### Step 1
Be sure that Docker image von-network is on your Docker registry.
If you have not the Docker image on your Docker registry, then build them.
Please follow [Documentation](./images/von-network/README.md)
### Step 2
Prepare a network.yaml file for your demo or you can use this sample for [AWS](../../platforms/hyperledger-indy/configuration/samples/network-indyv3-aries.yaml) or [Minikube](../../platforms/hyperledger-indy/configuration/samples/network-minikube-aries.yaml) and update for your case.
### Step 3
Run Ansible Playbook by these [steps](../../platforms/hyperledger-indy/configuration/README.md)
Can be started also via Docker container:
1. Go to root directory of this git repository.
2. Run command: `docker run -it -v $(pwd):/home/blockchain-automation-framework/ --entrypoint bash hyperledgerlabs/baf-build`
3. When are you entered into Docker container console, use command:
`./run.sh`
### Step 4
After Blockchain Automation Framework setup can be created Helm release of Indy Web Server:
1. Create Helm release with command: `helm install --name authority-webserver ./charts/webserver/`

or when you prefer use docker:
1. Be sure that you are into Docker container, if not, then enter via command: `docker exec -it <docker_container_name_or_id> bash`
2. Create environment variable for kubernetes config: `export KUBECONFIG=/home/blockchain-automation-framework/build/config`
3. Create Helm release with command: `helm install --name authority-webserver /home/blockchain-automation-framework/examples/identity-app/charts/webserver/`