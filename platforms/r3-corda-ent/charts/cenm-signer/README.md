[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy signer"></a>
# Signer Deployment

- [Signer Deployment Helm Chart](#Signer-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Signer-deployment-helm-chart"></a>
## Signer Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-signer) Deploys and configure a signer service within a Kubernetes cluster.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.

<a name = "chart-structure"></a>
## Chart Structure
---
This chart has following structue:
```
  ├── signer
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── _helpers.tpl
  │   │   ├── service.yaml  
  │   └── values.yaml
```

Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : Deploys an application using the kubernetes deployment resource, which ensures that a specified number of replica pods are running at all times. The container runs a signing keys and generating certificates and responsible for tailing and displaying log files from the signer service. 
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, storage, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-signer/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| nodeName   | Provide the name of the node                       |  signer       |

### Metadata

| Name            | Description                                                     | Default Value |
| ----------------| ----------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Corda Enterprise Signer           | cenm          |
| labels          | Provide any additional labels for the Corda Enterprise Signer   | ""            |

### Image

| Name                     | Description                                                                      | Default Value                                 |
| ------------------------ | -------------------------------------------------------------------------------- | ----------------------------------------------|
| initContainerName        | Information about the Docker container used for the init-containers              | ghcr.io/hyperledger                           |
| signerContainer          | Provide the image for the main Signer container                                  | corda/enterprise-signer:1.2-zulu-openjdk8u242 |
| ImagePullSecret          | Provide the K8s secret that has rights for pulling the image off the registry    | ""                                            |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent         | IfNotPresent                                  |

### Vault

| Name                      | Description                                                               | Default Value                     |
| ------------------------- | --------------------------------------------------------------------------| --------------------------------- |
| address                   | Address/URL of the Vault server                                           | ""                                |
| role                      | Role used for authentication with Vault                                   | vault-role                        |
| authpath                  | Authentication path for Vault                                             | entcordacenm                      |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth                        |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | secret/cenm-org-name/signer/certs |
| retries                   | Amount of times to retry fetching from/writing to Vault before giving up  | 10                                |
| sleepTimeAfterError       | Amount of time in seconds wait after an error occurs                      | 15                                |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | clusterip       |
| port                  | provide the port for service              | 6000            |

### CenmServices

| Name           | Description                               | Default Value |
| ---------------| ------------------------------------------| ------------- |
| idmanName      | Provide the name of the idman             | idman         |
| authName       | Name of the auth service                  | ""            |
| authPort       | Auth Service port                         | ""            |

### ServiceLocations

| Name                     | Description                                                                           | Default Value   |
| ------------------------ | --------------------------------------------------------------------------------------| --------------- |
| identityManager          | Provide the idman service address                                                     | ""              |
| host                     | The internal hostname for the Idman service, inside the K8s cluster                   | idman.namespace |
| publicIp                 | The public IP of the Idman service, accessible outside of the K8s cluster             | ""              |
| port                     | Port at which idman service is accessible, inside the K8s cluster                     | 5052            |
| publicPort               | Public port at which the Idman service is accessible outside the K8s cluster          | 443             |
| networkMap               | networkmap service details                                                            | ""              |
| revocation port          | Details of service where certificate revocation list will be published by idman       | 5053            |

### Signers

| Name              | Description                                               | Default Value |
| ---------------   | ----------------------------------------------------------| ------------- |
| CSR               | For checking Certificate Signing Request (CSR) schedule   | 1m            |
| CRL               | For checking Certificate Revocation List (CRL) schedule   | 1d            |
| NetworkMap        | For checking with NetworkMap (NMS)                        | 1d            |
| NetworkParameters | For checking network parameters interval                  | 1m            |

### Config

| Name                     | Description                                                                   | Default Value   |
| ------------------------ | ----------------------------------------------------------------------------- | --------------- |
| baseDir                  | Provide volume related specifications                                         | /opt/corda      |
| jarPath                  | Provide the path where the CENM Signer .jar-file is stored                    | "bin"           |
| configPath               | Provide the path where the CENM Service configuration files are stored        | "etc"           |
| cordaJar                 | Provide configuration of the .jar files used in the Node                      | ""              |
| deployment               | Provide any extra annotations for the deployment                              | "vaule"         |
| pod                      | Set memory limits of pod                                                      | ""              |
| replicas                 | Provide the number of replicas for your pods                                  | "1"             |

### Healthcheck

| Name                        | Description                                                   | Default Value |
| ----------------------------| --------------------------------------------------------------| ------------- |
| nodePort                    | Health Check node port set to get rid of logs pollution       | 0             |


<a name = "deployment"></a>
## Deployment
---
To deploy the Signer Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-signer/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./cenm-signer
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./cenm-signer
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Signer Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-signer), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
