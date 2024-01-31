[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy gateway"></a>
# Gateway Deployment

- [Gateway Deployment Helm Chart](#Gateway-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Gateway-deployment-helm-chart"></a>
## Gateway Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-gateway) deploys the CENM Gateway Service.

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
  ├── cenm-gateway
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── _helpers.tpl
  │   │   ├── pvc.yaml
  |   |   |__ job.yaml
  |   |   |__ configmap.yaml
  │   │   └── service.yaml 
  │   └── values.yaml
```
Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : Deploy and manage an application in a Kubernetes cluster using a Deployment resource.It includes an init container responsible for fetching secrets from a Vault server and creating directories.Optional liveness and readiness probes can be used to monitor the health and readiness of the application.
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `configmap.yaml`  : ConfigMap resource in Kubernetes with a specific name and namespace, along with labels for identification.
- `job.yaml`        : The job has two init containers for pre-task checks and a main container that runs a shell script, And main container is mounted with necessary files from a ConfigMap.  
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, storage, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-gateway/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| nodeName   | Provide the name of the node                       |  gateway      |

### Metadata

| Name            | Description                                                     | Default Value |
| ----------------| ----------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Corda Enterprise Auth             | cenm-ent      |
| labels          | Provide any additional labels for the Corda Enterprise Auth     | ""            |

### Image

| Name                     | Description                                                                        | Default Value                                  |
| ------------------------ | ---------------------------------------------------------------------------------- | ---------------------------------------------- |
| initContainerName        | Information about the Docker container used for the init-containers                | ghcr.io/hyperledger                            |
| gatewayContainerName     | Provide the image for the main Signer container                                    |corda/enterprise-gateway:1.5.1-zulu-openjdk8u242|
| ImagePullSecret          | Provide the K8s secret that has rights for pulling the image off the registry      | ""                                             |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent           | IfNotPresent                                   |

### CenmServices

| Name           | Description                               | Default Value |
| ---------------| ------------------------------------------| ------------- |
| idmanName      | Provide the name of the idman             | idman         |
| zoneName       | Name of the zone service                  | zone          |
| zonePort       | Zone Service port                         | 12345         |
| gatewayPort    | Gateway Service port                      | 8080          |
| authName       | Name of the auth service                  | auth          |
| authPort       | Auth Service port                         | 8081          |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| name                  | Provide the name of the storage class     | cordaentsc      |

### Vault

| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server                                           | ""            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | entcordacenm  |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth    |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | ""            |
| retries                   | Amount of times to retry fetching from/writing to Vault before giving up  | 10            |

### Config

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | --------------------------------------------------------------------------------------     | --------------- |
| baseDir                  | Provide volume related specifications                                                      | ""              |
| jarPath                  | Provide the path where the CENM Idman .jar-file is stored                                  | "bin"           |
| configPath               | Provide the path where the CENM Service configuration files are stored                     | "etc"           |
| pvc                      | Provide any extra annotations for the PVCs                                                 | ""              |
| deployment               | Provide any extra annotations for the deployment                                           | "value"         |
| pod                      | Set memory limits of pod                                                                   | ""              |
| podSecurityContext       | Allows you to set security-related settings at the Pod level                               | ""              |
| securityContext          | Securitycontext at pod level                                                               | ""              |  
| replicas                 | Provide the number of replicas for your pods                                               | "1"             |
| logsContainersEnabled    | Enable container displaying live logs                                                      | "true"          |
| cordaJar                 | Specify the maximum size of the memory allocation pool                                     | "512"           |
| sleepTimeAfterError      | Sleep time in seconds, occurs after any error is encountered in start-up                   |  "120"          |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | ClusterIP       |
| port                  | provide the port for service              | 8080            |


<a name = "deployment"></a>
## Deployment
---

To deploy the Gateway Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-gateway/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./cenm-gateway
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./cenm-gateway
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Gateway Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-gateway), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
