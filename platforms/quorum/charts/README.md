# Charts for Quorum components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the Quorum components. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/node_constellation
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- deployment.yaml
|   |-- ingress.yaml
|   |-- service.yaml
|   |-- volume.yaml
|-- Chart.yaml
|-- values.yaml
```

## Pre-requisites

 Helm to be installed and configured 

## Charts description ##

### 1. node_constellation ###
- This folder contains chart templates and default values for deploying a node with Constellation transaction manager.
### 2. node_tessera ###
- This folder contains chart templates and default values for deploying a node with Tessera transaction manager.