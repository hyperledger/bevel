[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Substrate Charts

The structure below represents the Chart structure for Substrate components in Hyperledger Bevel implementation.

```
/substrate
|-- charts
|   |-- dscp-ipfs-node
|   |-- substrate-genesis
|   |-- substrate-key-mgmt
|   |-- substrate-node
|   |-- vault-k8s-mgmt
```
---------

## Pre-requisites

``helm`` to be installed and configured on the cluster.

## substrate-genesis
### About
This chart is used to deploy substrate genesis block. 

### Folder Structure
```
/substrate-genesis
|-- templates
|   |-- _helpers.tpl
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate valid kubernetes manifest files for substrate genesis block deployment.
- This folder contains the following template files for substrate genesis implementation.

  - _helpers.tpl

      This file doesn't output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	    That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for substrate-genesis.

  - job.yaml

      This file is used as a basic manifest for creating a Kubernetes job. For the substrate-genesis, this file creates a genesis block deployment. The file defines 1 main container which gets all the secrets from the vault.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## substrate-key-mgmt
### About
This chart is used for generating crypto material for substrate node.

### Folder Structure
```
/substrate-key-mgmt
|-- templates
|   |-- _helpers.tpl
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts Description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for substrate key management implementation.
- This folder contains following template files for substrate-key-mgmt implementation

  - _helpers.tpl
      This file doesn't output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	    That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for substrate-key-mgmt.

  - job.yaml

      This file is used as a basic manifest for creating a Kubernetes job. For the substrate-key-mgmt, this file creates a genesis block deployment. The file defines 1 init container and 1 main container which gets all the secrets from the vault.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## substrate-node
### About
This chart is used for deploying a substrate node.

### Folder Structure
```
/substrate-node
|-- templates
|   |-- _helpers.tpl
|   |-- customNodeKeySecret.yaml
|   |-- googleServiceAccountKeySecret.yaml
|   |-- ingress.yaml
|   |-- keys.yaml
|   |-- service.yaml
|   |-- serviceAccount.yaml
|   |-- serviceMonitor.yaml
|   |-- statefulset.yaml
|-- .helmignore
|-- Chart.yaml
|-- values.yaml
```

### Charts Description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for substrate node implementation.
- This folder contains following template files for substrate-node implementation

  - _helpers.tpl

      This file doesn't output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for substrate-node.

  - customNodeKeySecret.yaml

      This component generates a customised node key in base64 format for the substrate blocks if there isn't already an existing persistant node key.

  - googleServiceAccountKeySecret.yaml

      This component generates a google service account key in base64 format to be injected into the Sync-chain-gcs init container using a Kubernetes secret.

  - ingress.yaml

      Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.
      This file containes those resources.

  - keys.yaml

      This component generates the list of keys in base64 format to be injected into the node before it starts up. The keys consist of type, scheme and secret seed.

  - service.yaml

      This template is used as a basic manifest for creating service endpoints for our deployment.
      This service.yaml creates endpoints for the substrate node.

  - serviceAccount.yaml

      This gives identity to the pods to enable thtem to authenticate themselves to the Kubernetes API server to allow deployment of substrate network.

  - serviceMonitor.yaml

      This is used to define services to be monitored by Prometheus and specifying labels so the services can be identified as well as ports and namespaces.

  - statefulset.yaml

      Statefulsets is used for Stateful applications, each replica of the pod will have its own state, and will be using its own Volume.
      This statefulset is used to create substrate nodes.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## vault-k8s-mgmt
### About
This chart uses vault to provide kubernetes authentication method so vault can connect with the kubernetes application pods and send or retrieve secrets.

### Folder Structure
```
/vault-k8s-mgmt
|-- templates
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for vault auth implementation.
- This folder contains following template files for vault-k8s-mgmt implementation

  - _helpers.tpl

      This file doesnt output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for vault-k8s-mgmt.

  - configmap.yaml
      
      The ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping containers agnostic of Kubernetes. Here it is used to store the vault auth policies.

  - job.yaml

      This file is used as a basic manifest for creating a Kubernetes job. For the vault-k8s-mgmt, this file creates vault auth to kubernetes pods. The file defines 1 main container, vault-kubernetes, which gives vault authuthorisation to kubernetes pods.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## dscp-ipfs-node
### About
This chart is used to deploy dscp-ipfs-node.

### Folder Structure
```
/dscp-ipfs-node
|   |-- _helpers.tpl
|   |-- configmap.yaml
|   |-- secret.yaml
|   |-- service.yaml
|   |-- statefulset.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for ipfs node creation.
- This folder contains following template files for dscp-ipfs-node implementation
	  
  - _helpers.tpl   

      This file doesnt output a Kubernetes manifest file as it begins with underscore (_). And it's a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials, as we have defined a template to encapsulate a Kubernetes block of labels for dscp-ipfs-node.
	  
  - configmap.yaml

      The ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping containers agnostic of Kubernetes. Here it is used to store the ipfs-node config data.

  - secret.yaml

      The Secret resource provides mechanisms to inject containers with sensitive data while keeping containers agnostic of Kubernetes. Here it is used to store the ipfs-node secrets data.

  - service.yaml

      This template is used as a basic manifest for creating a service endpoint for our deployment. The file basically specifies service type and kind of service ports for the ipfs node.

  - statefulset.yaml

      Statefulsets is used for Stateful applications, each repliCA of the pod will have its own state, and will be using its own Volume.
      This statefulset is used to create ipfs nodes.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.