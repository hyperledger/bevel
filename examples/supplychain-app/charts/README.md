[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Helm Charts #

## About ##

This repository contains all the examples of helm charts used in the automation scripts for deploying the apps.

## Charts description ##

### 1. expressapp ###

This chart helps deploying the express applications for the middleware between backend and frontend.

The values.yaml file contains the fields that will be read by the following files:

* deployment.yaml
* service.yaml

The fields inside the values.yaml file are:

Field name | Description
-----------|-------------
nodeName|Gives the name to the pod that will be deployed in the server
metadata.namespace|The namespace where the pod will be deployed
replicaCount|The number of replicas that this service must have in the server
expressapp| Groups the following variables
serviceType| The kind of service that this pod will be, in this case it will be NodePort which exposes the service on each Node's IP at a static port. For more information about this kind of service or any other available kinds visit: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types **WARNING: The nodePort is unique in kubernetes cluster so this can eventualy cause some issues**
image| The docker image that will be pulled to create the pod.
pullPolicy | this value is set to "IfNotPresent" this tell kubernetes to only download the image if it is not present, important to say that this is not the only kind of pullPolicy, for more information visit: https://kubernetes.io/docs/concepts/containers/images/ 
pullSecrets | this value stores the name of the secret used to pull the image from the repository, if in the values file, it will take a default value.
nodePorts| This variable is inside the expressApp group and groups the following variables
port | The port that the service will have, other services may look for this service in this port
targetPort | The port on the POD where the service is running
name | The name of the service
env | This value is no longer inside "nodePorts" this will group the following values
apiUrl | This is the end point where the service will make any request

Here is how the file looks like:
```
# Default values for nodechart.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.
nodeName: changeMe
metadata:
  namespace: 

# The number of replicas the node will have
replicaCount: 1

deployment:
  #   annotations:
  #     key: "value"
  annotations: {}

# This will group the values of the expressapp
expressapp:
  #This defines the service type of the node, it will always be NodePort for the expressapp
  serviceType: NodePort
  # The image that will be pulled from jenkins
  image: fromJenkins:tag
  # The pull policy
  pullPolicy: Always
  # The node ports to be used
  pullSecrets: regcred
  nodePorts:
      port: 3000
      targetPort: 3000
      name: expressapp
  # The environment variables that will store the port to be working on and the end point to ask for requests
  env:
    apiUrl: blockchaincloudpoc.com
```
All this values are used by the files inside the templates folder

### 2. springbootwebserver ###

This chart helps deploying the Corda Springboot Server which provides an API into the Corda network.

The values.yaml file contains the fields that will be read by the following files:

* deployment.yaml
* pvc.yaml
* service.yaml

The fields inside the values.yaml file are:

Field name | Description
-----------|-------------
nodeName|Gives the name to the pod that will be deployed in the server
metadata.namespace|The namespace where the pod will be deployed
replicaCount|The number of replicas that this service must have in the server
image| Groups the following variables
containerName| The docker image that will be pulled to create the pod (with tag).
initContainerName| The docker image of the init-container (with tag).
imagePullSecret | this value stores the name of the secret used to pull the image from the repository, if in the values file, it will take a default value.
smartContract|  Groups the following variables
name| Name of the smartcontract jar
path| Path where the smartcontract jar will be copied
JAVA_OPTIONS| JAVA_OPTIONS for running the Corda jars
volume.mountPath| Mount path for corda home
nodeConf| Groups the following variables for node configuration
node| Name of the node
nodeRpcPort| RPC port of the node
nodeRpcAdminPort| RPC Admin port of the node
controllerName| Controller Name
trustStorePath| Path for the truststore
trustStoreProvider| Provider for truststore default is jks
legalName| Legal Name or Subject of the node
devMode| DevMode boolean for the Corda Node: true or false
useHTTPS| Boolean option to use HTTPS
useSSL| Boolean option to use SSL
tlsAlias| TLS Alias
credentials.rpcUser| RPC Username for the node
resources| Groups the following variables 
limits| Max Memory limit for the pod
requests| Min Memory requests for the pod
storage| Groups the following variables
provisioner| Provisioner for the Storage (depends on Cloud service provider)
memory| Memory size for the volume for the pod
name| Name of the storageclass that will be used to create the volume
parameters.type| Type of storageclass
parameters.encrypted| Boolean value to choose default encryption
annotations| Key Value pair for annotations
web| Groups the following variables
port | The port that the service will have, other services may look for this service in this port
nodePort| Optional **WARNING: The nodePort is unique in kubernetes cluster so providing this can eventualy cause some issues**
targetPort | The port on the POD where the service is running
service| Groups the following variables
type| The kind of service that this pod will be, in this case it will be NodePort which exposes the service on each Node's IP at a static port. For more information about this kind of service or any other available kinds visit: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types
annotations| Key Value pair for annotations
deployment.annotations| Key Value pair for annotations
pvc.annotations| Key Value pair for annotations
vault| Groups the following variables
address| Hashicorp Vault web-address. This web address should be reachable by Kubernetes cluster.
role| Vault role to connect to the Vault
authpath| Authorization path to connect to the Vault
serviceaccountname| Serviceaccount to connect to the Vault
secretprefix| Prefix for the secrets in Vault
node.readinesscheckinterval | Interval to check for the node readiness
node.readinessthreshold | Starting Threshold to check the node readiness

All this values are used by the files inside the templates folder

### Folder Structure ###
```
/expressapp
|-- templates
|   |-- deployment.yaml
|   |-- service.yaml
|-- Chart.yaml
|-- values.yaml
/springbootwebserver
|-- templates
|    |-- deployment.yaml
|    |-- pvc.yaml
|    |-- service.yaml
|-- Chart.yaml
|-- values.yaml
```