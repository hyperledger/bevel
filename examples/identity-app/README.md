# Identity-App

## About
This folder contains the files that are needed for the deployment of a Identity Application on a Indy network that has been created using the Blockchain Automation Framework.

## Folder structure
```
identity-app
|-- charts: this folder contains the Helm charts that are needed for the deployment of the Identity Application.
|-- configuration: this folder contains the Ansible playbook and roles that are needed for the deployment of the Identity Application.
|-- images: this folder contains the Docker images that are needed for running of the Identity Application.
|-- tests: this folder contains the Postman suits and environment variables for testing the Identity Application.
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
Make sure that Docker image von-network is on your Docker registry.
If you do not have the Docker image on your Docker registry, then build and push them.
Please follow [Documentation](./images/von-network/README.md).
### Step 2
Make sure that Docker image of agents is on your Docker registry.
If you do not have the Docker image on your Docker registry, then build and push them.
Please follow [Documentation](./images/agents/README.md) 
### Step 3
Prepare a network.yaml file for your demo by following this sample for [AWS](../../platforms/hyperledger-indy/configuration/samples/network-indyv3-aries.yaml) or [Minikube](../../platforms/hyperledger-indy/configuration/samples/network-minikube-aries.yaml) and update relevant sections.
### Step 4
Run Ansible Playbook by following these [steps](../../platforms/hyperledger-indy/configuration/README.md)
Can be started also via Docker container:
1. Go to root directory of this git repository.
2. Run command: `docker run -it -v $(pwd):/home/blockchain-automation-framework/ --entrypoint bash hyperledgerlabs/baf-build`
3. When are you entered into Docker container console, use command:
`./run.sh`
### Step 5
After Indy network has been set up, Identity App can be deployed via Ansible playbook:

- Make sure that you are in Docker container (BAF), if not, then enter via command: `docker exec -it <docker_container_name_or_id> bash`
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
            ambassador: 15010
```
- Update Endorser service in your `network.yaml` file to add port of Indy Client, which will run with endorser role.
example of Endorser: 
```yaml
      endorsers:
        - endorser:
          name: university-endorser
          full_name: Faber university of the Demo.
          avatar: https://faber.com/avatar.png
          # public endpoint will be {{ endorser.name}}.{{ external_url_suffix}}:{{endorser.server.httpPort}}
          # Eg. In this sample https://university-endorser.indy.blockchaincloudpoc.com:15030/
          # For minikube: http://<minikubeip>>:15030
          server:
            httpPort: 15023
            apiPort: 15024
```
- Run Ansible [playbook](./configuration/deploy-identity-app.yaml) with command: `ansible-playbook -i platforms/shared/inventory/ansible_provisioners examples/identity-app/configuration/deploy-identity-app.yaml -e "@./build/network.yaml"`
For minikube, pass additional parameter minikube_ip: `ansible-playbook examples/identity-app/configuration/deploy-identity-app.yaml -e "@./build/network.yaml" -e "minikube_ip='192.x.x.x'"`

### Step 6
Agent for Student Alice don't have Ansible roles created. These agents have to be run manually:
- Be sure that you are in Docker container (BAF), if not, then enter via command: `docker exec -it <docker_container_name_or_id> bash`
- Create environment variable for kubernetes config: `export KUBECONFIG=/home/blockchain-automation-framework/build/config`
- Fill all variables in `value.yaml` file in helm [chart of alice](./charts/alice)
- Create Helm release for Student Alice with command: `helm install --name alice examples/identity-app/charts/alice/`
- If you reset the network, please delete the alice helm release manually: `helm delete --purge alice`

### Step 7
Identity App is running and agents API via Swagger are available on IP address of your cluster with ports which you defined for your agents in `value.yaml` file.
For example, with the given sample network.yaml your Agent's Swagger will be available at
- Faber: https://university-endorser.indy.blockchaincloudpoc.com:15030/
- Alice: http://alice.id.example.blockchaincloudpoc.com:15040/

### Step 8
Follow the [steps](./tests/README.md) to test the API using Postman. You can also follow [these steps](https://github.com/hyperledger/aries-cloudagent-python/blob/master/demo/AriesOpenAPIDemo.md#using-the-openapiswagger-user-interface) as per the Aries Demo on this Identity App.

### Challenge
Similar to the Aries Demo challenge, you may want to run the Acme Endorser as well. Configure and run network.yaml accordingly.