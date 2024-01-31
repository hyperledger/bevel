[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy bridge"></a>
# bridge Deployment

- [Bridge Deployment Helm Chart](#Bridge-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Bridge-deployment-helm-chart"></a>
## Bridge Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-bridge) deploys the Bridge component of the Corda Enterprise Firewall.

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
  ├── corda-ent-bridge
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── _helpers.tpl
  │   │   ├── pvc.yaml  
  │   └── values.yaml
```

Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : The deployment ensures that the desired number of firewall service replicas is running in the Kubernetes cluster. 
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, storage, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-bridge/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| nodeName   | Provide the name of the node                       |  bridge       |

### Metadata

| Name            | Description                                                     | Default Value |
| ----------------| ----------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace where the Bridge will be deployed         | cenm          |
| labels          | Provide any additional labels for the Corda Enterprise Bridge   | ""            |

### initContainerImage

| Name                     | Description                                                                  | Default Value       |
| ------------------------ | -----------------------------------------------------------------------------| ------------------- |
| Name                     | Information about the Docker container used for the init-containers          | ghcr.io/hyperledger |

### Image

| Name                     | Description                                                                   | Default Value   |
| ------------------------ | ------------------------------------------------------------------------------| --------------- |
| name                     | Provide the name of the image, including the tag                              | adopblockchaincloud0502.azurecr.io/corda_image_firewall_4.4:latest|
| PullSecret               | Provide the K8s secret that has rights for pulling the image off the registry | ""              |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent      | IfNotPresent    |

### Vault

| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server                                           | ""            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | entcordacenm  |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth    |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | ""            |

### volume

| Name              | Description                                 | Default Value   |
| ------------------| ------------------------------------------  | -------------   |
| baseDir           | Provide the base directory for the container| /opt/corda      |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| name                  | Provide the name of the storage class     | cenm            |

### Healthcheck

| Name                        | Description                                                                   | Default Value |
| ----------------------------| ------------------------------------------------------------------------------| ------------- |
| readinesscheckinterval      | Provide the interval in seconds you want to iterate till db to be ready       | 10            |
| readinessthreshold          | Provide the threshold till you want to check if specified db up and running   | 15            |


<a name = "deployment"></a>
## Deployment
---

To deploy the Brigde Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-bridge/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-ent-bridge
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-ent-bridge
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Bridge Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-bridge), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
