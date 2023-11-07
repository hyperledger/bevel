[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy corda-certs-gen"></a>
# corda-certs-gen deployment

- [corda-certs-gen Deployment Helm Chart](#corda-certs-gen-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "corda-certs-gen-deployment-helm-chart"></a>
## corda-certs-gen Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-certs-gen) generates the certificates.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- Doorman network is setup and running.
- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.


<a name = "chart-structure"></a>
## Chart Structure
---
This chart has following structue:

```
  
  ├── corda-certs-gen
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── job.yaml
  │   │   ├── configmap.yaml
  │   │   └── _helpers.tpl
  │   └── values.yaml
```

Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `job.yaml`        : This Job is responsible for generating the root CA certificate, Doorman CA certificate, and MongoDB CA certificate for doorman.
- `configmap.yaml`  : ConfigMap resource in Kubernetes with a specific name and namespace, along with labels for identification.And holds the openssl configuration file.
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, service, Vault, etc.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-certs-gen/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| name       | Provide the name of the node                       | doorman       |

### Metadata

| Name            | Description                                                           | Default Value |
| ----------------| ----------------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Generate Certs Generator               | notary-ns     |
| labels          | Provide any additional labels for the Generate Certs Generator        | ""            |

### Image

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| initContainerName        | Provide the alpine utils image, which is used for all init-containers of deployments/jobs  | ""              |
| certsContainerName       | Provide the image for the certs container                                                  | ""              |
| imagePullSecret          | Provide the docker-registry secret created and stored in kubernetes cluster as a secret    | ""              |
| pullPolicy               | Pull policy to be used for the Docker image                                                | IfNotPresent    |

### Vault

| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server                                           | ""            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | cordadoorman  |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth    |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | doorman/data  |
| retries                   | Number of retries to check contents from vault                            | 10            |
| sleepTimeAfterError       | Sleep time in seconds when error while registration                       | 15            |

### Subjects

| Name                      | Description                        | Default Value |
| ------------------------- | ---------------------------------- | ------------- |
| root_subject              | Mention the subject for rootca     | ""            |
| mongorootca               | Mention the subject for mongorootca| ""            |
| doormanca                 | Mention the subject for doormanca  | ""            |
| networkmap                | Mention the subject for networkmap | ""            |

### Volume

| Name             | Description            | Default Value |
| -----------------| -----------------------| ------------- |
| baseDir          | Base directory         | /home/bevel   |


<a name = "deployment"></a>
## Deployment
---

To deploy the corda-certs-gen Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-certs-gen/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-certs-gen
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-certs-gen
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
If you encounter any bugs, have suggestions, or would like to contribute to the [corda-certs-gen Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-certs-gen), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
