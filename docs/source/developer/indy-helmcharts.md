[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Indy Charts  
The structure below represents the Chart structure for Hyperledger Indy components in Hyperledger Bevel implementation.

```
/hyperledger-indy
|-- charts
|   |-- indy-auth-job
|   |-- indy-cli
|   |-- indy-domain-genesis
|   |-- indy-key-mgmt
|   |-- indy-ledger-txn
|   |-- indy-node
|   |-- indy-pool-genesis
```
---------

## Pre-requisites

``helm`` to be installed and configured on the cluster.

## Indy-Auth-Job
### About
This chart is using admin auth to generate auth. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/indy-auth-job
|-- templates
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for auth job implementation.
- This folder contains following template files for auth job implementation
	  
  - Job.yaml   

      This job uses admin auth to generate auth read only methods, policies and roles for stewards, so they have the right they need to work.

#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## Indy-Domain-Genesis

### About
This folder consists of domain genesis helm chart which is used to generate the domain genesis for indy network. 

### Folder Structure
```
/indy-domain-genesis
|-- templates
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This chart is used to generate the domain genesis.
	  
  - configmap.yaml   

      The ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping containers agnostic of Kubernetes. Here it is used to store Domain Genesis Data.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.


-----

## Indy Key Management

### About
This folder consists indy-key-management helm charts which are used by the ansible playbooks for the generation of indy crypto material. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/indy-key-management
|-- templates
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate crypto material for Indy.
- This folder contains following template files for peer implementation
  - job.yaml   

      This job is used to generate crypto and save into vault.
           
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

-----

## Indy Ledger Txn

### About
This folder contains helm chart which is used to run Indy Ledger Transaction Script.

### Folder Structure
```
/indy-ledger-txn
|-- templates
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate valid Kubernetes manifest files for ledger NYM transaction implementation.
- This folder contains following template files for indy-ledger NYM Transaction implementation
  - job.yaml   

      This Job is used to generate a NYM transaction between an admin identity and an endorser identity.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## Indy Node

### About
This folder consists of indy-node helm charts, which are used by the ansible playbooks for the deployment of the indy nodes. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/indy-node
|-- templates
|   |-- configmap.yaml
|   |-- service.yaml
|   |-- statesfulset.yaml
|-- Chart.yaml
|-- values.yaml
```
### Charts description

#### templates
- This folder contains template structures which, when combined with values, will generate Indy nodes.
- This folder contains following template files for instantiate_chaincode implementation
  - configmap.yaml   

      The configmap.yaml file through template engine generate configmaps. In Kubernetes, a ConfigMap is a container for storing configuration data. Things like pods can access the data in a ConfigMap. This file is used to inject Kubernetes container with indy config data.
  
  - service.yaml   

      This creates a service for indy node and indy node client. A service in Kubernetes is a grouping of pods that are running on the cluster

  - statesfulset.yaml   

    Statefulsets is used for Stateful applications, each repliCA of the pod will have its own state, and will be using its own Volume.
    This statefulset is used to create indy nodes.
          
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

------

## Indy Pool Genesis

### About
This folder consists of pool genesis helm chart which is used to generate the pool genesis for indy network. 

### Folder Structure
```
/indy-pool-genesis
|-- templates
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This chart is used to generate the initial pool genesis which is used to connect to indy network.
	  
  - configmap.yaml   

      The ConfigMap API resource provides mechanisms to inject containers with configuration data while keeping containers agnostic of Kubernetes. Here it is used to store Pool Genesis Data.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.
