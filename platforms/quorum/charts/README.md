# Charts for Quorum components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the component. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/raft_constellation
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

### 1. raft_constellation ###
- This folder contains chart templates and default values for deploying a RAFT node with Constellation Transaction Manager.
