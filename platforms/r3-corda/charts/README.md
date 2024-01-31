[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for R3 Corda components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the R3-Corda components. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/corda-doorman
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
### 2. doorman-tls ###
- This folder contains chart templates and default values for doorman-tls servers.
### 3. h2 ###
- This folder contains chart templates and default values for creation of h2 database.
### 4. h2-adduser ###
- This folder contains chart templates and default values for adding new user into h2 database.
### 5. h2-password-change ###
- This folder contains chart templates and default values for changing the password for h2 database user. 
### 6. mongodb ###
- This folder contains chart templates and default values for mongodb node
### 7. mongodb-tls ###
- This folder contains chart templates and default values for mongodb node with tls=on.
### 8. nms ###
- This folder contains chart templates and default values for nms
### 9. nms-tls ###
- This folder contains chart templates and default values for nms with tls=on.
### 10. node ###
- This folder contains chart templates and default values for node
### 11. node-initial-registration ###
- This folder contains chart templates and default values for registering node with notary
### 12. notary ###
- This folder contains chart templates and default values for notary.
### 13. notary-initial-registration ###
- This folder contains chart templates and default values for registering notary with nms.
### 14. storage ###
- This folder contains chart templates and default values for StorageClass
