[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Parity Substrate components

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the Parity Substrate network. Each chart folder contain a folder for templates, chart file and the corresponding value file. 

## Example Folder Structure ###
```

/substrate-node
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- ingress.yaml
|   |-- service.yaml
|   |-- statefulset.yaml
|   |-- volume.yaml
|-- Chart.yaml
|-- values.yaml
```

## Pre-requisites

 Helm to be installed and configured 

## Charts description ##

### 1. substrate-genesis ###
- This chart directory contains templates for building genesis file for the substrate network.

### 2. substrate-key-mgmt ###
- This chart directory contains templates for generating crypto material for substrate node.

### 3. substrate-node ###
- This chart directory contains templates for deploying a substrate node.

### 4. vault-k8s-mgmt ###
- This chart directory contains templates for authenticating vault with kubernetes cluster.

### 5. dscp-ipfs-node
- This chart directory contains templates to deploy ipfs node.
