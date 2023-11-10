[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Indy components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the component. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/indy-node
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

### 1. indy-auth-job ###
- This folder contains chart templates and default values for creation of indy authotization job.
### 2. indy-cli ###
- This folder contains chart templates and default values for creation of indy cli.
### 4. indy-domain-genesis ###
- This folder contains chart templates and default values for creation of indy domain genesis. 
### 5. indy-key-mgmt ###
- This folder contains chart templates and default values for creation of indy key management.
### 6. indy-ledger-txn ###
- This folder contains chart templates and default values for creation of indy ledger txn.
### 7. indy-node ###
- This folder contains chart templates and default values for creation of indy node.
### 8. indy-pool-genesis ###
- This folder contains chart templates and default values for creation of indy pool genesis.
