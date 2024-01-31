[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy mongodb"></a>
# Mongodb Deployment

- [Mongodb Deployment Helm Chart](#Mongodb-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Mongodb-deployment-helm-chart"></a>
## Mongodb Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-mongodb) deploys Mongodb. 


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- Mongodb database up and running.
- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.

<a name = "chart-structure"></a>
## Chart Structure
---
This chart has following structue:

```
  
  ├── mongodb
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── pvc.yaml
  │   │   └── service.yaml
  │   └── values.yaml
```

Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : This Deployment manages a MongoDB replica set of a Pod template, including volume mounts, environment variables, and ports for the container.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the image, storage and service.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-mongodb/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| name       | Provide the name of the node                       | mongodb       |

### Image

| Name                     | Description                                             | Default Value   |
| ------------------------ | ------------------------------------------------------- | --------------- |
| containerName            | Provide the containerName of image                      | ""              |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| Memory                | Provide the memory for node               | "4Gi"           |
| MountPath             | The path where the volume will be mounted | ""              |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | "NodePort"      |
| tcp port              | Provide the tcp port for node             | "9101"          |
| nodePort              | Provide the tcp node port for node        | "32001"         |
| targetPort            | Provide the tcp targetPort for node       | "27017"         |


<a name = "deployment"></a>
## Deployment
---

To deploy the Mongodb Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-mongodb/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify, delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-mongodb
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-mongodb
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Mongodb Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-mongodb), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
