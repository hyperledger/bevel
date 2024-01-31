[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Quorum components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the Quorum components. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```
/quorum-member-node
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- deployment.yaml
|   |-- ingress.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```
