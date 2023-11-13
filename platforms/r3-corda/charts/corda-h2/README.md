[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy h2"></a>
# H2 Deployment

- [h2 Deployment Helm Chart](#h2-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "h2-deployment-helm-chart"></a>
## h2 Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-h2) deploys Kubernetes deployment resource for h2 database.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- Node's database up and running.
- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.


<a name = "chart-structure"></a>
## Chart Structure
---
This chart has following structue:

```
  
  ├── h2
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── pvc.yaml
  │   │   └── service.yaml
  │   └── values.yaml
```
- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : This file is a configuration file for deployement in Kubernetes.It creates a deployment file with a specified number of replicas and defines various settings for the deployment.Including volume mounts, environment variables, and ports for the container.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the image, resources, storage, service, etc.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-h2/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| name       | Provide the name of the node                       |   ""          |

### Image

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| initContainerName        | Provide the alpine utils image, which is used for all init-containers of deployments/jobs  | ""              |
| containerName            | Provide the containerName of image                                                         | ""              |
| imagePullSecret          | Provide the image pull secret of image                                                     | regcred         |

### Resources

| Name                     | Description                                            | Default Value   |
| ------------------------ | ------------------------------------------------------ | --------------- |
| limits                   | Provide the limit memory for node                      | "1Gi"           |
| requests                 | Provide the requests memory for node                   | "1Gi"           |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| Memory                | Provide the memory for node               | "4Gi"           |
| MountPath             | The path where the volume will be mounted | ""              |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | NodePort        |
| tcp port              | Provide the tcp port for node             | 9101            |
| nodePort              | Provide the tcp node port for node        | 32001           |
| targetPort            | Provide the tcp targetPort for node       | 1521            |

## WEB

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| nodePort              | Provide the web node port for node        | 32080           |
| targetPort            | Provide the tcp targetPort for node       | 81              |
| port                  | Provide the tcp node port for node        | 8080            |



<a name = "deployment"></a>
## Deployment
---

To deploy the h2 Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-h2/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify, delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-h2
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-h2
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
If you encounter any bugs, have suggestions, or would like to contribute to the [h2 Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-h2), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
