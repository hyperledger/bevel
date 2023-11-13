[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Corda Charts

The structure below represents the Chart structure for R3 Corda components in Hyperledger Bevel 
implementation.

```
/r3-corda
|-- charts
|   |-- doorman
|   |-- doorman-tls
|   |-- h2
|   |-- h2-addUser
|   |-- h2-password-change
|   |-- mongodb
|   |-- mongodb-tls 
|   |-- nms
|   |-- nms-tls
|   |-- node
|   |-- node-initial-registration
|   |-- notary
|   |-- notary-initial-registration
|   |-- storage
```
---------
## Pre-requisites

``helm`` to be installed and configured on the cluster.

## doorman
### About
This folder consists of Doorman helm charts which are used by the ansible playbooks for the deployment of Doorman component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/corda-doorman
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.tpl
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Doorman implementation.
- This folder contains following template files for Doorman implementation
  
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment for Doorman. The file basically describes the container and volume specifications of the Doorman. The file defines container where doorman container is defined with corda image and corda jar details. The init container init-creds creates doorman db root password and user credentials at mount path, init-certificates init container basically configures doorman keys.jks by fetching certsecretprefix from the vault, change permissions init-containers provides permissions to base directory and db-healthcheck init-container checks for db is up or not.
	      
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the Doorman deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates persistentVolumeClaim for Doorman pvc.
      
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates CA service endpoint. The file basically specifies service type and kind of service ports for doorman server.
      
      
#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml 
- This file contains the default configuration values for the chart.


-----

## doorman-tls
### About
This folder consists of Doorman helm charts which are used by the ansible playbooks for the deployment of Doorman component when TLS is on for the doorman. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/corda-doorman-tls
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.tpl
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Doorman implementation.
- This folder contains following template files for Doorman implementation
  
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment for Doorman. The file basically describes the container and volume specifications of the Doorman. The file defines container where doorman container is defined with corda image and corda jar details. The init container init-creds creates doorman db root password and user credentials at mount path, init-certificates init container basically configures doorman keys.jks by fetching certsecretprefix from the vault, change permissions init-containers provides permissions to base directory and db-healthcheck init-container checks if db is up or not.
	      
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the Doorman deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates persistentVolumeClaim for Doorman pvc.
      
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates CA service endpoint. The file basically specifies service type and kind of service ports for doorman server.
      
      
#### Chart.yaml 
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml 
- This file contains the default configuration values for the chart.


-----


## nms 

### About
This folder consists of networkmapservice helm charts which are used by the ansible playbooks for the deployment of networkmapservice component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/nms
|-- templates
|   |-- volume.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates 
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for nms implementation.
- This folder contains following template files for nms implementation
	  
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment for NMS . The file basically describes the container and volume specifications of the NMS. The file defines containers where NMS container is defined with corda image and corda jar details. The init container init-certificates-creds creates NMS db root password and user credentials at mount path, init-certificates init container basically configures NMS keys.jks by fetching certsecretprefix from the vault, changepermissions init-containers provides permissions to base directory and db-healthcheck init-container checks for db is up or not.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates nms service endpoint. The file basically specifies service type and kind of service ports for the nms server.
	  
  - volume.yaml:   

      This yaml is used to create persistent volumes claim for the nms deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates nms pvc for, the volume claim for nms.
	       
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## nms-tls

### About
This folder consists of networkmapservice helm charts that establish a TLS connection with mongodb, which are used by the ansible playbooks for the deployment of networkmapservice component. This chart is deployed when TLS is on for nms. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/nms-tls
|-- templates
|   |-- volume.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates 
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for nms implementation.
- This folder contains following template files for nms implementation
	  
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment for NMS. The file basically describes the container and volume specifications of the NMS. The file defines containers where NMS container is defined with corda image and corda jar details. The init container init-certificates-creds creates NMS db root password and user credentials at mount path, init-certificates init container basically configures NMS keys.jks by fetching certsecretprefix from the vault, changepermissions init-containers provides permissions to base directory and db-healthcheck init-container checks for db is up or not.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates nms service endpoint. The file basically specifies service type and kind of service ports for the nms server.
	  
  - volume.yaml:   

      This yaml is used to create persistent volumes claim for the nms deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates nms pvc for, the volume claim for nms.
	       
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## h2 (database)

### About
This folder consists of H2 helm charts which are used by the ansible playbooks for the deployment of the H2 database. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/h2
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for H2 implementation.
- This folder contains following template files for H2 implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment.For the H2 node, this file creates H2 deployment.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment. This service.yaml creates H2 service endpoint 
	  
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the H2 deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates h2-pvc for , the volume claim for H2.
	       
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## h2-addUser

### About
This folder consists of H2-adduser helm charts which are used by the ansible playbooks for the deployment of the Peer component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/h2-addUser
|-- templates
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Pre-requisites

 helm to be installed and configured 

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for h2 add user implementation.
- This folder contains following template file for adding users to h2 implementation

  - job.yaml:   
  
      The job.yaml file through template engine runs create h2-add-user container and thus runs newuser.sql to create users and create passwords for new users.  
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

-----

## h2-password-change

### About
This folder consists of H2-password-change helm charts which are used by the ansible playbooks for the deployment of the Peer component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/h2-password-change
|-- templates
|   |-- job.yaml
|-- Chart.yaml
|-- values.yaml
```

### Pre-requisites

 helm to be installed and configured 

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for h2 password change implementation.
- This folder contains following template file for changing h2 password implementation

  - job.yaml:   

      The job.yaml file through template engine runs create h2-add-user container and thus runs newuser.sql to create users and create passwords for new users.  
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

-----

## mongodb

### About
This folder consists of Mongodb helm charts which are used by the ansible playbooks for the deployment of the Mongodb component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/mongodb
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```
### Charts description

#### templates 
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Mongodb implementation.
- This folder contains following template files for Mongodb implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment.For the Mongodb node, this file creates Mongodb deployment.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment. This service.yaml creates Mongodb service endpoint 
	  
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the Mongodb deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud enviornment.
	  This file creates mongodb-pvc for, the volume claim for mongodb.
	  
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml 
- This file contains the default configuration values for the chart.


-----

## mongodb-tls

### About
This folder consists of Mongodb helm charts which are used by the ansible playbooks for the deployment of the Mongodb component. It allows for TLS connection. When TLS is on for nms or doorman, this chart is deployed for them else mongodb chart is deployed. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/mongodb-tls
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```
### Charts description

#### templates 
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Mongodb implementation.
- This folder contains following template files for Mongodb implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment.For the Mongodb node, this file creates Mongodb deployment.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment. This service.yaml creates Mongodb service endpoint 
	  
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the Mongodb deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud enviornment.
	  This file creates mongodb-pvc for, the volume claim for mongodb.
	  
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml 
- This file contains the default configuration values for the chart.


-----

## node

### About
This folder consists of node helm charts which are used by the ansible playbooks for the deployment of the corda node component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/node
|-- templates
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```
### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for R3 Corda node implementation.
- This folder contains following template files for node implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment. For the corda node, this file creates a node deployment. The file defines containers where node container is defined with corda image and corda jar details and corda-logs container is used for logging purpose. The init container init-nodeconf defines node.conf file for node, init-certificates init container basically configures networkmap.crt, doorman.crt, SSLKEYSTORE and TRUSTSTORE at mount path for node by fetching certsecretprefix from the vault and init-healthcheck init-container checks for h2 database. Certificates and notary server database are defined on the volume mount paths.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates node service endpoint.The file basically specifies service type and kind of service ports for the corda nodes. 
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----------


## node-initial-registration 

### About
This folder contains node-initial-registration helm charts which are used by the ansible playbooks for the deployment of the install_chaincode component. The folder contains a templates folder, a chart file and the corresponding value file. 

### Folder Structure ###
```
/node-initial-registration
|-- templates
|   |--job.yaml
|   |--_helpers.tpl
|-- Chart.yaml
|-- values.yaml
```
### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for node-initial-registration implementation.
- This folder contains following template files for  node-initial-registration implementation
  - job.yaml:  
      It is used as a basic manifest for creating a Kubernetes deployment for initial node
      registration. The file basically describes the container and volume specifications of the node. corda-node container is used for running corda jar.store-certs-in-vault container is used for putting certificate into the vault. init container is used for creating node.conf which is used by corda node, download corda jar, download certificate from vault,getting passwords of keystore from vault  and also performs health checks

  - _helpers.tpl:   
      A place to put template helpers that you can re-use throughout the chart.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## notary

### About
This folder consists of Notary helm charts, which are used by the ansible playbooks for the deployment of the Notary component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/notary
|-- templates
|   |-- deployment.tpl
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for Notary implementation.
- This folder contains following template files for Notary implementation

  - deployment.yaml:

      This file is used as a basic manifest for creating a Kubernetes deployment. For the corda notary, this file creates a notary deployment. The file defines containers where notary container is defined with corda image and corda jar details also registers the notary with nms and corda-logs container is used for logging purpose. The init container init-nodeconf defines node.conf file for notary, init-certificates init container basically configures networkmap.crt, doorman.crt, SSLKEYSTORE and TRUSTSTORE at mount path by fetching certsecretprefix from vault and db-healthcheck init-container checks for h2 database. Certificates and notary server database are defined on the volume mount paths.
	  
  - service.yaml

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates Notary service endpoint. The file basically specifies service type and kind of service ports for Notary.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

------

## notary-initial-registration 

### About
This folder consists of notary-initial-registration helm charts, which are used by the ansible playbooks for the deployment of the initial notary components. The folder contains a templates folder, a chart file and a corresponding value file. 

### Folder Structure ###
```
/notary-initial-registration
|-- templates
|   |--job.yaml
|   |--_helpers.tpl
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for registering notary components.
- This folder contains following template files for initializing notary implementation.
  - job.yaml:   

      It is used as a basic manifest for creating a Kubernetes deployment for initial notary
      registration. The file basically describes the container and volume specifications of the notary. corda-node container is used for running corda jar.store-certs-in-vault container is used for putting certificate into the vault. init container is used for creating node.conf which is used by corda node, download corda jar, download certificate from vault,getting passwords of keystore from vault  and also performs health checks.
  
  - _helpers.tpl:   

      A place to put template helpers that you can re-use throughout the chart.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.


## springbootwebserver 

### About
This folder consists of springbootwebserver helm charts which are used by the ansible playbooks for the deployment of the springbootwebserver component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/springbootwebserver
|-- templates
|   |-- deployment.yaml
|   |-- pvc.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description 

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for springbootwebserver implementation.
- This folder contains following template files for springbootwebserver implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment. For the corda springbootwebserver, this file creates a springbootwebserver deployment. The file defines containers where springbootwebserver container is defined with corda image and app jar details and 
	  the init container basically creates app.properties file, configures the vault with various vault parameters. Certificates and springbootwebserver database are defined on the volume mount paths.

  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the springbootwebserver deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud enviornment.
	  This file creates springbootwebserver-pvc for , the volume claim for springbootwebserver.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates springbootwebserver service endpoint.The file basically specifies service type and kind of service ports for the corda springbootwebserver. 

      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## storage

### About
This folder consists of storage helm charts, which are used by the ansible playbooks for the deployment of the storage component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/storage
|-- templates
|   |-- storageclass.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for storageclass implementation.
- This folder contains following template files for storageclass implementation
  
  - storageclass.yaml:
      This yaml file basically creates storageclass. We define provisioner, storagename and namespace from value file.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

------

## webserver Chart

### About
This folder consists of webserver helm charts which are used by the ansible playbooks for the deployment of the webserver component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure ###
```
/webserver
|-- templates
|   |-- pvc.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for webserver implementation.
- This folder contains following template files for webserver implementation
 
  - deployment.yaml:   

      This file is used as a basic manifest for creating a Kubernetes deployment. For the webserver node, this file creates webserver deployment.
	  
  - service.yaml:   

      This template is used as a basic manifest for creating a service endpoint for our deployment. This service.yaml creates webserver service endpoint 
	  
  - pvc.yaml:   

      This yaml is used to create persistent volumes claim for the webserver deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud enviornment.
	  This file creates webserver-pvc for, the volume claim for webserver.

  - volume.yaml:   
  
      This yaml is used to create persistent volumes claim for the webserver deployment. A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates webserver pvc for, the volume claim for webserver.
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion, name, etc.
#### values.yaml
- This file contains the default configuration values for the chart.

