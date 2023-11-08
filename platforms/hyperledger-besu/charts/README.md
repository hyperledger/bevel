[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Hyperledger Besu components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the Hyperledger Besu components. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/besu-member-node
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
<!-- [TODO] chart description will go here -->