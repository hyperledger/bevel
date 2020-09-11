# Corda Enterprise Helm Charts

Following are the helm charts used for R3 Corda Enterprise in Blockchain Automation Framework.

```
platforms/r3-corda-ent/charts
├── bridge
├── float
├── generate-pki
├── h2
├── idman
├── nmap
├── node
├── node-initial-registration
├── notary
├── notary-initial-registration
└── signer
```
---------
## Pre-requisites

``helm`` version 2.x.x to be installed and configured on the cluster.

## Bridge
### About
This chart deploys the Bridge component of Corda Enterprise filewall. The folder contents are below: 

### Folder Structure
```
├── bridge
│   ├── Chart.yaml
│   ├── files
│   │   └── firewall.conf
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```

### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for bridge.
  - firewall.conf: The main configuration file for firewall.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Corda Firewall implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains one init-container `init-certificates` to download the keys/certs from Vault, and one `main` containers which executes the firewall service.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVC used by firwall
      
  - service.yaml: This creates the firewall service endpoint.

#### values.yaml 
- This file contains the default values for the chart.

-----
## Float
### About
This chart deploys the Float component of Corda Enterprise filewall. The folder contents are below: 

### Folder Structure
```
├── float
│   ├── Chart.yaml
│   ├── files
│   │   └── firewall.conf
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```

### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for float.
  - firewall.conf: The main configuration file for firewall.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Corda Firewall implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains one init-container `init-certificates` to download the keys/certs from Vault, and one `main` containers which executes the firewall service.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVC used by firwall
      
  - service.yaml: This creates the firewall service endpoint.

#### values.yaml 
- This file contains the default values for the chart.

-----
## Generate-pki
### About
This chart deploys the Generate-PKI job on Kubernetes. The folder contents are below: 

### Folder Structure
```
├── generate-pki
│   ├── Chart.yaml
│   ├── files
│   │   └── pki.conf
│   ├── README.md
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── _helpers.tpl
│   │   └── job.yaml
│   └── values.yaml
```

### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for PKI.
  - pki.conf: The main configuration file for generate-pki.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for PKI job. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  - _helpers.tpl: This is a helper file to add any custom labels.
  - job.yaml: This creates the main Kubernetes job. It contains a `main` container which runs the pkitool to generate the certificates and keystores, and a `store-certs` container to upload the certificates/keystores to Vault.
#### values.yaml 
- This file contains the default values for the chart.
----

## h2 (database)

### About
This chart deploys the H2 database pod on Kubernetes. The folder contents are below:

### Folder Structure
```
├── h2
│   ├── Chart.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```

### Charts description
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name etc
#### templates
- This folder contains template structures which when combined with values, will generate        valid Kubernetes manifest files for H2 implementation. This folder contains following template files:
   - deployment.yaml: This file is used as a basic manifest for creating a Kubernetes deployment. For the H2 node, this file creates H2 pod.
	- pvc.yaml: This yaml is used to create persistent volumes claim for the H2 deployment. This file creates h2-pvc for, the volume claim for H2.
	- service.yaml: This template is used as a basic manifest for creating a service endpoint for our deployment.This service.yaml creates H2 service endpoint.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## idman
### About
This chart deploys the Idman component of Corda CENM. The folder contents are below: 

### Folder Structure
```
├── idman
│   ├── Chart.yaml
│   ├── files
│   │   ├── idman.conf
│   │   └── run.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml

```

### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for idman.
  - idman.conf: The main configuration file for idman.
  - run.sh: The executable file to run the idman service in the kubernetes pod.

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Idman implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains one init-container `init-certificates` to download the keys/certs from Vault, and two main containers: `idman` and `logs`.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVCs used by idman: one for logs and one for the file H2 database.
      
  - service.yaml: This creates the idman service endpoint with Ambassador proxy configurations.       

#### values.yaml 
- This file contains the default values for the chart.

-----

## nmap
### About
This chart deploys the NetworkMap component of Corda CENM. The folder contents are below: 

### Folder Structure
```
├── nmap
│   ├── Chart.yaml
│   ├── files
│   │   ├── nmap.conf
│   │   ├── run.sh
│   │   └── set-network-parameters.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```

### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for nmap.
  - nmap.conf: The main configuration file for nmap.
  - run.sh: The executable file to run the nmap service in the kubernetes pod.
  - set-network-parameters.sh: This executable file which creates the initial network-parameters.

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for NetworkMap implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains a init-container `init-certificates` to download the keys/certs from Vault, a `setnparam` container to set the network-parameters, and two main containers: `main` and `logs`.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVCs used by nmap: one for logs and one for the file H2 database.
      
  - service.yaml: This creates the nmap service endpoint with Ambassador proxy configurations.       

#### values.yaml 
- This file contains the default values for the chart.

-----

## node

### About
This chart deploys the Node component of Corda Enterprise. The folder contents are below: 

### Folder Structure ###
```
├── node
│   ├── Chart.yaml
│   ├── files
│   │   ├── node.conf
│   │   └── run.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```
### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for Corda node.
  - node.conf: The main configuration file for node.
  - run.sh: The executable file to run the node service in the kubernetes pod.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Corda Node implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains three init-containers: `init-check-registration` to check if node-initial-registration was completed, `init-certificates` to download the keys/certs from Vault, and a `db-healthcheck` container to check if the database service is reachable, and two main containers: `node` and `logs`.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVC used by the node.
      
  - service.yaml: This creates the node service endpoint with Ambassador proxy configurations.       

#### values.yaml 
- This file contains the default values for the chart.

----------

## node-initial-registration 

### About
This chart deploys the Node-Registration job for Corda Enterprise. The folder contents are below: 

### Folder Structure ###
```
├── node-initial-registration
│   ├── Chart.yaml
│   ├── files
│   │   ├── node.conf
│   │   └── node-initial-registration.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── _helpers.tpl
│   │   └── job.yaml
│   └── values.yaml
```
### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for Corda node.
  - node.conf: The main configuration file for node.
  - node-initial-registration.sh: The executable file to run the node initial-registration.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for registration job. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  - _helpers.tpl: This is a helper file to add any custom labels.
  - job.yaml: This creates the main Kubernetes job. It contains two init-containers: `init-certificates` to download the keys/certs from Vault, and a `db-healthcheck` container to check if the database service is reachable, and two main containers: `registration` for the actual registration and `store-certs` to upload the certificates to Vault.       

#### values.yaml 
- This file contains the default values for the chart.

----

## notary

### About
This chart deploys the Notary component of Corda Enterprise. The folder contents are below: 

### Folder Structure ###
```
├── notary
│   ├── Chart.yaml
│   ├── files
│   │   ├── notary.conf
│   │   └── run.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── _helpers.tpl
│   │   ├── pvc.yaml
│   │   └── service.yaml
│   └── values.yaml
```
### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for Corda Notary.
  - notary.conf: The main configuration file for notary.
  - run.sh: The executable file to run the notary service in the kubernetes pod.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Corda Notary implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains three init-containers: `init-check-registration` to check if notary-initial-registration was completed, `init-certificates` to download the keys/certs from Vault, and a `db-healthcheck` container to check if the database service is reachable, and two main containers: `notary` and `logs`.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - pvc.yaml: This creates the PVC used by the notary.
      
  - service.yaml: This creates the notary service endpoint with Ambassador proxy configurations.       

#### values.yaml 
- This file contains the default values for the chart.

------

## notary-initial-registration 

### About
This chart deploys the Notary-Registration job for Corda Enterprise. The folder contents are below: 

### Folder Structure ###
```
├── notary-initial-registration
│   ├── Chart.yaml
│   ├── files
│   │   ├── create-network-parameters-file.sh
│   │   ├── notary.conf
│   │   └── notary-initial-registration.sh
│   ├── templates
│   │   ├── configmap.yaml
│   │   ├── _helpers.tpl
│   │   └── job.yaml
│   └── values.yaml
```
### Charts description

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for Corda Notary.
  - create-network-parameters-file.sh: Creates the network parameters file.
  - notary.conf: The main configuration file for notary.
  - notary-initial-registration.sh: The executable file to run the notary initial-registration.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Notary registration job. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  - _helpers.tpl: This is a helper file to add any custom labels.
  - job.yaml: This creates the main Kubernetes job. It contains two init-containers: `init-certificates` to download the keys/certs from Vault, and a `db-healthcheck` container to check if the database service is reachable, and two main containers: `registration` for the actual registration and `store-certs` to upload the certificates to Vault.       

#### values.yaml 
- This file contains the default values for the chart.

----

## signer 

### About
This chart deploys the Signer component of Corda CENM. The folder contents are below: 

### Folder Structure ###
```
└── signer
    ├── Chart.yaml
    ├── files
    │   └── signer.conf
    ├── README.md
    ├── templates
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   ├── _helpers.tpl
    │   └── service.yaml
    └── values.yaml
```

### Charts description 

#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name etc.

#### files
- This folder contains the configuration files needed for signer.
  - signer.conf: The main configuration file for signer.
  
#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Signer implementation. This folder contains following template files:
  - configmap.yaml: This creates a configmap of all the files from the `files` folder above.
  
  - deployment.yaml: This creates the main Kubernetes deployment. It contains two init-containers: `init-check-certificates` to check if the signer certificates are saved on Vault and `init-certificates` to download the keys/certs from Vault, and two main containers: `signer` and `logs`.
  - _helpers.tpl: This is a helper file to add any custom labels.
          
  - service.yaml: This creates the signer service endpoint.       

#### values.yaml 
- This file contains the default values for the chart.
