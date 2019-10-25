# Charts for Hyperledger Fabric components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the component. Each chart folder contain a folder for templates, chart file and corresponding value file. 

## Example Folder Structure ###
```
/ca
|-- templates
|   |--_helpers.tpl
|   |-- volumes.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

## Pre-requisites

 Helm to be installed and configured 

## Charts description ##

### 1. ca ###
- This folder contains chart templates and default values for certificate authority(CA) servers
### 2. create_channel ###
- This folder contains chart templates and default values for creation of  channel
### 3. join_channel ###
- This folder contains chart templates and default values for joining the channel
### 4. orderernode ###
- This folder contains chart templates and default values for Orderer node 
### 5. peernode ###
- This folder contains chart templates and default values for peer node 
### 6. zkkafka ###
- This folder contains chart templates and default values for  zkkafka Orderer 
