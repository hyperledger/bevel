# Hyperledger Fabric Charts

The structure below represents the Chart structure for Hyperledger fabric components in the Blockchain Automation Framework implementation.

```
/hyperledger-fabric
|-- charts
|   |-- ca
|   |-- catools
|   |-- create_channel
|   |-- fabric_cli
|   |-- install_chaincode
|   |-- instantiate_chaincode
|   |-- join_channel
|   |-- orderernode
|   |-- peernode
|   |-- upgrade_chaincode
|   |-- verify_chaincode
|   |-- zkkafka
```
---------

## Pre-requisites

``helm`` to be installed and configured on the cluster.

## CA (certification authority)

### About
This folder consists CA helm charts which are used by the ansible playbooks for the deployment of the CA component. The folder contains a templates folder, a chart file and a value file. 

### Folder Structure
```
/ca
|-- templates
|   |-- _helpers.tpl
|   |-- volumes.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values, will generate valid Kubernetes manifest files for CA implementation.
- This folder contains following template files for CA implementation
  
  - _helpers.tpl 
      This file doesnt output a Kubernetes manifest file as it begins with underscore (_). And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for CA.
	  
  - deployment.yaml
      This file is used as a basic manifest for creating a Kubernetes deployment. For the ca node, this file creates a ca deployment. The file defines where ca container is defined with fabric image and CA client and CA server onfiguration details and 
	  the init container basically configures the vault with various vault parameters.Certificates and CA server database are defined on the volume mount paths.
	  
  - service.yaml
      This template is used as a basic manifest for creating a service endpoint for our deployment.
	  This service.yaml creates ca service endpoint.The file basically specifies service type and kind of service ports for the CA client and CA server.
	  
  - volume.yaml
      This yaml is used to create persistent volumes claim for the CA deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates ca pvc for, the volume claim for CA.
            
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## CA tools

### About
This folder consists CA tools helm charts which are used by the ansible playbooks for the deployment of the CA tools component. The folder contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/catools
|-- templates
|   |-- volumes.yaml
|   |-- deployment.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for CA tools implementation.
- This folder contains following template files for CA tools implementation
	  
  - deployment.yaml
      This file is used as a basic manifest for creating a Kubernetes deployment for CA tools . The file basicllay describes the container and volume specifications of the ca tools 
	      
  - volume.yaml
      This yaml is used to create persistent volumes claim for the Orderer deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates two persistentVolumeClaims , one for CA tools pvc and the other to store crypto config in the ca-tools-crypto-pvc persistent volume.  
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.


-----

## Create channel

### About
This folder consists create_channel helm charts which are used by the ansible playbooks for the deployment of the create_channel component. The foldere contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/create_channel
|-- templates
|   |--_helpers.tpl
|   |-- create_channel.yaml
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for Peer implementation.
- This folder contains following template files for peer implementation
  - _helpers.tpl 
      This fie doesnt output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for channels.
  
  - configmap.yaml
      The configmap.yaml file through template engine generate configmaps.In Kubernetes, a ConfigMap is a container for storing configuration data.Things like pods, can access the data in a ConfigMap. 
	  The configmap.yaml file creates two configmaps namely genesis-block-peer and peer-config . When Tiller reads this configmap.yaml template,
	  it sends it to Kubernetes as-is.
	  For Create_channel component , it creates two configmaps, one for the channel creation having various data fields such as channel , peer and orderer details and other for the generation of channel artifacts containing the channel transaction (channeltx) block and other labels.
	   
  - create_channel.yaml
      This file creates channel creation job where in the createchannel container the create channel peer commands are fired based on checking the results obtained from fetching channeltx block to see if channel has already been created or not.
	  Additionaly, the commands are fired based on the tls status whether it is enabled or not.The init container is used to setup vault configurations.And certificates are obatined from the volume mount paths.
           
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.


-----

## Install Chaincode

### About
This folder consists install_chaincode helm charts which are used by the ansible playbooks for the deployment of the install_chaincode component. The foldere contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/install_chaincode
|-- templates
|   |--_helpers.tpl
|   |-- install_chaincode.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for install_chaincode implementation.
- This folder contains following template files for install_chaincode implementation
  - _helpers.tpl 
      This fie doesn't output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  This file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for install_chaincodes.
  
  - install_chaincode.yaml
      This yaml file basically creates a job for the installation of chaincode.We define containers where fabrictools image is pulled and chaincode install peer commands are fired.
	  Moreover , the chart provides the environment requirements such as docker endpoint, peer and orderer related information , volume mounts etc for the chaincode to be installed.
	  The init container basically configures the vault with various vault parameters.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----

## Instantiate Chaincode

### About
This folder consists instantiate_chaincode helm charts, which are used by the ansible playbooks for the deployment of the instantiate_chaincode component. The foldere contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/instantiate_chaincode
|-- templates
|   |--_helpers.tpl
|   |-- instantiate_chaincode.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for instantiate_chaincode implementation.
- This folder contains following template files for instantiate_chaincode implementation
  - _helpers.tpl 
      This fie doesn't output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  This file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for instantiate_chaincodes.
  
  - instantiate_chaincode.yaml
      This yaml file basically creates a job for the instantiation of chaincode.We define containers where fabrictools image is pulled and based on the endorsement policies set , chaincode instantiate peer commands are fired.
	  Moreover , the chart provides the environment requirements such as docker endpoint, peer and orderer related information , volume mounts etc for the chaincode to be instantiated.
	  The init container basically configures the vault with various vault parameter.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.

------

## Join channel

### About
This folder consists join_channel helm charts which are used by the ansible playbooks for the deployment of the join_channel component. The foldere contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/join_channel
|-- templates
|   |--_helpers.tpl
|   |-- join_channel.yaml
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for Peer implementation.
- This folder contains following template files for peer implementation
  - _helpers.tpl 
      This fie doesnt output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for peers.
  
  - configmap.yaml
      The configmap.yaml file through template engine generate configmaps.In Kubernetes, a ConfigMap is a container for storing configuration data.Things like pods, can access the data in a ConfigMap. 
	  The configmap.yaml file creates two configmaps namely genesis-block-peer and peer-config . When Tiller reads this configmap.yaml template,
	  it sends it to Kubernetes as-is.
	  For join_channel component , it creates two configmaps, one for the channel creation having various data fields such as channel , peer and orderer details and other for the generation of channel artifacts containing the channel transaction (channeltx) block and other labels.
	   
  - join_channel.yaml
      This file creates channel join job where in the joinchannel container the commands are fired based on the tls status whether it is enabled or not wherein first the channel config is fetched and then the peers join the created channel.
	  The init container is used to setup vault configurations.And certificates are obatined from the volume mount paths.
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.

----------

## Orderer Chart

### About
This folder consists Orderer helm charts which are used by the ansible playbooks for the deployment of the Orderer component. The folder contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/Orderernode
|-- templates
|   |--_helpers.tpl
|   |-- volumes.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for Orderer implementation.
- This folder contains following template files for Orderer implementation
  - _helpers.tpl 
      This fie doesnt output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for Orderers.
  
  - configmap.yaml
      The configmap.yaml file through template engine generate configmaps.In Kubernetes, a ConfigMap is a container for storing configuration data.Things like pods, can access the data in a ConfigMap. 
	  The configmap.yaml file creates two configmaps namely genesis-block-orderer and orderer-config . When Tiller reads this configmap.yaml template,
	  it sends it to Kubernetes as-is.
	  
  - deployment.yaml
      This file is used as a basic manifest for creating a Kubernetes deployment.For the Orderer node, this file creates orderer deployment.
	  
  - service.yaml
      This template is used as a basic manifest for creating a service endpoint for our deployment.This service.yaml creates orderer service endpoint 
	  
  - volume.yaml
      This yaml is used to create persistent volumes claim for the Orderer deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates orderer-pvc for , the volume claim for Orderer.
	  
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.


----

## Peer Chart

### About
This folder consists Peer helm charts which are used by the ansible playbooks for the deployment of the Peer component. The folder contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/peernode
|-- templates
|   |--_helpers.tpl
|   |-- volumes.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|   |-- configmap.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for Peer implementation.
- This folder contains following template files for peer implementation
  - _helpers.tpl 
      This fie doesnt output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for peers.
  
  - configmap.yaml
      The configmap.yaml file through template engine generate configmaps.In Kubernetes, a ConfigMap is a container for storing configuration data.Things like pods, can access the data in a ConfigMap. 
	  The configmap.yaml file creates two configmaps namely genesis-block-peer and peer-config . When Tiller reads this configmap.yaml template,
	  it sends it to Kubernetes as-is.
	  
  - service.yaml
      This template is used as a basic manifest for creating a service endpoint for our deployment.This service.yaml creates peer service endpoint.
	  
  - volume.yaml
      This yaml is used to create persistent volumes claim for the peer deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates peer-pvc for , the volume claim for peer.
  
  - deployment.yaml
      This file is used as a basic manifest for creating a Kubernetes deployment.For the peer node, this file creates three deployments namely ca, ca-tools and peer
      
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.


-----

## Upgrade Chaincode

### About
This folder consists upgrade_chaincode helm charts, which are used by the ansible playbooks for the deployment of the upgrade_chaincode component. The folder contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/upgrade_chaincode
|-- templates
|   |--_helpers.tpl
|   |-- upgrade_chaincode.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for upgrade_chaincode implementation.
- This folder contains following template files for upgrade_chaincode implementation
  - _helpers.tpl 
      This fie doesn't output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  This file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for upgrade_chaincodes.
  
  - upgrade_chaincode.yaml
      This yaml file basically creates a job for the upgradation of chaincode.We define containers where fabrictools image is pulled and based on the endorsement policies set , chaincode upgrade peer commands are fired.
	  Moreover , the chart provides the environment requirements such as docker endpoint, peer and orderer related information , volume mounts ,channel information etc for the chaincode to be upgraded.
	  The init container basically configures the vault with various vault parameter.
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.

------

## zkkafka

### About
This folder consists zkkafka helm charts which are used by the ansible playbooks for the deployment of the zkkafka component. The folder contains a templates folder,a chart file and a value file. 

### Folder Structure
```
/zkkafka
|-- templates
|   |--_helpers.tpl
|   |-- volumes.yaml
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```

### Charts description

#### templates
- This folder contains template structures which when combined with values ,will generate valid Kubernetes manifest files for zkkafka implementation.
- This folder contains following template files for zkkafka implementation
  - _helpers.tpl 
      This fie doesn't output a Kubernetes manifest file as it begins with underscore (_) .And its a place to put template helpers that we can re-use throughout the chart.
	  That file is the default location for template partials ,as we have defined a template to encapsulate a Kubernetes block of labels for zkkafkas.
  
  - deployment.yaml
      This file is used as a basic manifest for creating a Kubernetes deployment.For the zkkafka node, this file creates zkkafka deployment.
	  
  - service.yaml
      This template is used as a basic manifest for creating a service endpoint for our deployment.This service.yaml creates zkkafka service endpoint 
	  
  - volume.yaml
      This yaml is used to create persistent volumes claim for the zkkafka deployment.A persistentVolumeClaim volume is used to mount a PersistentVolume into a Pod. 
	  PersistentVolumes provide a way for users to 'claim' durable storage  without having the information details of the particular cloud environment.
	  This file creates zkkafka pvc for , the volume claim for zkkafka.
	     
      
#### Chart.yaml
- This file contains the information about the chart such as apiversion, appversion ,name etc.
#### values.yaml
- This file contains the default configuration values for the chart.
