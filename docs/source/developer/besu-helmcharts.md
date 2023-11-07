[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Hyperledger Besu Charts

The structure below represents the Chart structure for Hyperledger Besu components in Hyperledger Bevel implementation.

```
|hyperledger-besu
|-- charts
|   |-- besu-member-node
```
-------------

## Pre-requisites

``helm`` to be installed and configured on the cluster.

## besu-member-node (besu node chart)

### About
This folder consists of Hyperledger-Besu node charts which is used by the ansible playbook for the deployment of the node. This folder contains a template folder, a chart file and a value file.

### Folder Structure
```
|besu-member-node
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

### templates
- This folder contains template structures which, when combined with values, will generate valid Kuberetenes manifest files for Hyperledger-Besu node implementation.
- This folder contains following template files for node implementation

  - _helpers.tpl   

      This file doesn't output a Kubernets manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
      That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block label for node.

  - configmap.yaml   

      The configmap contains the genesis file data encoded in base64 format.

  - deployment.yaml   

      This file is used as a basic manifest for creating a Kubernetes deployment. For the node, this file creates a deployment. The file defines where containers are defined and the respective Hyperledger-Besu images. It also contain the initial containers where the crypto material is fetched from the vault.

  - service.yaml   

      This template is used as a basic manifest for creating service endpoints for our deployment.
      This service.yaml creates endpoints for the besu node.
