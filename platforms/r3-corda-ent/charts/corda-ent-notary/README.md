[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy Notary"></a>
# Notary Deployment

- [Notary Deployment Helm Chart](#Notary-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Notary-deployment-helm-chart"></a>
## Notary Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-notary) helps to deploy the corda notory node.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- NetworkMap and Node's database up and running.
- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.


This chart has following structure:
```

  ├── corda-ent-notary
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── _helpers.tpl
  │   │   ├── pvc.yaml
  │   │   └── service.yaml
  │   └── values.yaml
```

- `templates`      : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml`: This file is a configuration file for deployement in Kubernetes.It creates a deployment file with a specified number of replicas and defines various settings for the deployment, Init container is responsible for node registration process is completed successfully before the main containers start.It also specifies volume mounts for storing certificates and data.
- `pvc.yaml`       : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `service.yaml`   : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `chart.yaml`     : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`    : Contains the default configuration values for the chart. It includes configuration for the image, nodeconfig, credenatials, storage, service , vault, etc.
- `_helpers.tpl`   : A template file used for defining custom labels and ports for the metrics in the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-notary/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                          | Default Value |
| -----------| -------------------------------------| ------------- |
| nodeName   | Provide the name of the node         |  notary       |

### Metadata

| Name            | Description                                      | Default Value |
| ----------------| -------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Corda node         | cenm          |
| labels          | Provide the labels to the Corda node             | ""            |

### Image

| Name                     | Description                                                                       | Default Value                                 |
| ------------------------ | -------------------------------------------------------------------------------   | ----------------------------------------------|
| initContainerName        | Information about the Docker container used for the init-containers               | ghcr.io/hyperledger                           |
| nodeContainerName        | Enterprise node image                                                             | azurecr.io/corda/notary:1.2-zulu-openjdk8u242 |
| ImagePullSecret          | Provide the K8s secret that has rights for pulling the image off the registry     | ""                                            |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent          | IfNotPresent                                  |

### Vault

| Name                      | Description                                                               | Default Value            |
| ------------------------- | --------------------------------------------------------------------------| -------------------------|
| address                   | Address/URL of the Vault server                                           | ""                       |
| role                      | Role used for authentication with Vault                                   | vault-role               |
| authpath                  | Authentication path for Vault                                             | entcordacenm             |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth               |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | secret/organisation-name |
| retries                   | Amount of times to retry fetching from/writing to Vault before giving up  | 10                       |
| retryInterval             | Amount of time in seconds to wait after an error occurs                   | 15                       |

### cordapps

| Name                     | Description                                             | Default Value   |
| ------------------------ | ------------------------------------------------------- | --------------- |
| getcordapps              | Provide if you want to provide jars in cordapps         | true            |
| repository               | Provide the repository of cordapps                      | ""              |
| jars url                 | Provide url to download the jar using wget cmd          | ""              |

### NodeConf

| Name                     | Description                                                                                | Default Value                |
| ------------------------ | -------------------------------------------------------------------------------------------| -----------------------------|
| p2p                      | The host and port on which the node is available for protocol operations over ArtemisMQ    | ""                           |
| ambassador               | Specify ambassador host:port which will be advertised in addition to p2paddress            | O=Node,OU=Node,L=London,C=GB |
| legalName                | Provide the legalName for node                                                             | dev-node@bevel.com           |
| notary                   | Notary type Ex cenm or notary                                                              | cenm                         |
| volume                   | Provide volume related specifications                                                      | /opt/corda/base              |
| jarPath                  | where is node jar is stored                                                                | bin                          |  
| devMode                  | Provide the devMode for corda node                                                         | "false"                      |
| configPath               | where service configuration files are stored                                               | "etc"                        |
| replicas                 | Provide the number of replicas for your pods                                               | 1                            |

### networkServices

| Name                     | Description                                                         | Default Value                   |
| ------------------------ | ------------------------------------------------------------------  | --------------------------------|
| idmanName                | Name of the idman                                                   | idman                           |
| doormanURL               | doormanURL defines the accesspoint for the Identity Manager server  | http://my-identity-manager:1000 |
| networkmapName           | name of the networkmapName                                          | networkmap                      |
| networkMapURL            | networkMapURL defines the accesspoint for the Network Map server    | http://my-network-map:10000     |
| networkMapDomain         |  defines the networkMapDomain                                       | ""                              |

### Service

| Name                  | Description                                              | Default Value   |
| --------------------- | -------------------------------------------------------- | -------------   |
| p2p port              | p2pPort defines the port number of inbound connections   | 4000            |
| rpcadmin port         | Provide the rpcadmin port for node                       | ""              |

### dataSourceProperties

| Name                  | Description                                      | Default Value   |
| --------------------- | -------------------------------------------------| -------------   |
| dataSource            | DataSource of the url ,user and passowrd         | ""              |
| dataSourceClassName   | dburl, dbport of the data source class           | ""              |

### Healthcheck

| Name                        | Description                                                                   | Default Value |
| ----------------------------| ------------------------------------------------------------------------------| ------------- |
| readinesscheckinterval      | Provide the interval in seconds you want to iterate till db to be ready       | 5             |
| readinessthreshold          | Provide the threshold till you want to check if specified db up and running   | 2             |

<a name = "deployment"></a>
## Deployment
---

To deploy the notary Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-notary/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade,verify, delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-ent-notary
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-ent-notary
```

To verify the deployment:
```bash
kubectl get jobs -n <namespace>
```
Note : Replace `<namespace>` with the actual namespace where the Job was created. This command will display information about the Job, including the number of completions and the current status of the Job's pods.

To delete the chart: 
```bash
helm uninstall <release-name>
```
Note : Replace `<release-name>` with the desired name for the release.


<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the [notary Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-notary), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

<a name = "license"></a>
## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture

### Attribution

This chart is adapted from the [charts](https://hyperledger.github.io/bevel/) which is licensed under the Apache v2.0 License which is reproduced here:

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
