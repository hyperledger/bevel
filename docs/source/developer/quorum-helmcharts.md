[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Quorum Charts

The structure below represents the Chart structure for Quorum components in Hyperledger Bevel implementation.

```
/quorum
|-- charts
|   |-- quorum-member-node
|   |-- node_tessera
```
---------

## Pre-requisites

``helm`` to be installed and configured on the cluster.

----

## node_tessera

### About
This chart is used to deploy Quorum nodes with tessera transaction manager.

### Folder Structure
```
/node_tessera
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- ingress.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for tessera implementation.
- This folder contains following template files for node_tessera implementation
	  
  - _helpers.tpl   

      This file doesnt output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for node_tessera.
	  
  - deployment.yaml   

      This file is used as a basic manifest for creating a Kubernetes deployment. The file defines 4 containers, init container which gets all the secrets from the vault, mysql-init caontainer, mysql-db and a quorum container.
	  
  - service.yaml   

      This template is used as a basic manifest for creating a service endpoint for our deployment. The file basically specifies service type and kind of service ports for the tessera node.

  - configmap.yaml   

      The ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping containers agnostic of Kubernetes. Here it is used to store tessera config data.
      
  - ingress.yaml   
  
     Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.
     This file contains those resources.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.
