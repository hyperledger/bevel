# Charts for R2 Corda components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the component. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/doorman
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

### 1. doorman ###
- This folder contains chart templates and default values for doorman servers.
### 2. h2 ###
- This folder contains chart templates and default values for creation of h2 database.
### 3. h2-adduser ###
- This folder contains chart templates and default values for adding new user into h2 database.
### 4. h2-password-change ###
- This folder contains chart templates and default values for changing the password for h2 database user. 
### 5. mongodb ###
- This folder contains chart templates and default values for mongodb node
### 6. networkMap ###
- This folder contains chart templates and default values for networkmap
### 7. nms ###
- This folder contains chart templates and default values for nms
### 8. node ###
- This folder contains chart templates and default values for node
### 9. node-initial-registration ###
- This folder contains chart templates and default values for registering node with notary
### 10. notary ###
- This folder contains chart templates and default values for notary and also registering notary with nms
### 11. notary-initial-registration ###
- This folder contains chart templates and default values for initializing notary