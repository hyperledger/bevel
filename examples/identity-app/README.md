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
Be sure that Docker image of agents is on your Docker registry.
If you have not the Docker image on your Docker registry, then build them.
Please follow [Documentation](./images/agents/README.md) 
### Step 3
Prepare a network.yaml file for your demo or you can use this sample for [AWS](../../platforms/hyperledger-indy/configuration/samples/network-indyv3-aries.yaml) or [Minikube](../../platforms/hyperledger-indy/configuration/samples/network-minikube-aries.yaml) and update for your case.
### Step 4
Run Ansible Playbook by following these [steps](../../platforms/hyperledger-indy/configuration/README.md)
Can be started also via Docker container:
1. Go to root directory of this git repository.
2. Run command: `docker run -it -v $(pwd):/home/blockchain-automation-framework/ --entrypoint bash hyperledgerlabs/baf-build`
3. When are you entered into Docker container console, use command:
`./run.sh`
### Step 5
After Indy network has been set up, Identity App can be deployed via Ansible playbook:

- Be sure that you are in Docker container (BAF), if not, then enter via command: `docker exec -it <docker_container_name_or_id> bash`
- Update Trustee service in your `network.yaml` file to add port of Indy WebServer, which will run with trustee role.
example of trustee: 
```yaml
      services:
        trustees:
        - trustee:
          name: authority-trustee
          genesis: true
          server:
            port: 8000
```
- Run Ansible [playbook](./configuration/deploy-identity-app.yaml) with command: `ansible-playbook -i ./blockchain-automation-framework/platforms/shared/inventory/ansible_provisoners ./blockchain-automation-framework/examples/identity-app/configuration/deploy-identity-app.yaml -e "@./blockchain-automation-framework/build/network.yaml"`

### Step 6
Agents for Faber University and Student Alice don't have Ansible roles created yet. These agents have to be run manually:
- Be sure that you are in Docker container (BAF), if not, then enter via command: `docker exec -it <docker_container_name_or_id> bash`
- Create environment variable for kubernetes config: `export KUBECONFIG=/home/blockchain-automation-framework/build/config`
- Fill all variables in `value.yaml` file in helm [chart of faber](./charts/faber)
- Create Helm release for University Faber with command: `helm install --name faber /home/blockchain-automation-framework/examples/identity-app/charts/faber/`
- Fill all variables in `value.yaml` file in helm [chart of alice](./charts/alice)
- Create Helm release for Student Alice with command: `helm install --name alice /home/blockchain-automation-framework/examples/identity-app/charts/alice/`

### Step 7
Identity App is running and agents API via Swagger are available on IP address of your cluster with ports which you defined for your agents in `value.yaml` file.

### Step 8
Follow these [steps](https://github.com/hyperledger/aries-cloudagent-python/blob/master/demo/AriesOpenAPIDemo.md#using-the-openapiswagger-user-interface) for using Aries Demo on this Identity App.