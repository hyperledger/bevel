[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "raft-crypto-goquorum-deployment"></a>
# RAFT Crypto GoQuorum Deployment

- [RAFT Crypto GoQuorum Deployment Helm Chart](#raft-crypto-goquorum-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "raft-crypto-goquorum-deployment-helm-chart"></a>
## RAFT Crypto GoQuorum Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-raft-crypto-gen) generate the crypto material for raft consensus.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- The GoQuorum network is set up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm installed.

<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
quorum-raft-crypto-gen/
    |- templates/
            |- helpers.tpl
            |- job.yaml
    |- Chart.yaml
    |- README.md
    |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `job.yaml`: Interacting with a Vault server to fetch and validate secrets, as well as generating and saving cryptographic materials in the vault.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes settings for the metadata, peer, image, and Vault configurations.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-raft-crypto-gen/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Metadata

| Name            | Description                                                                             | Default Value         |
| ----------------| --------------------------------------------------------------------------------------- | --------------------- |
| namespace       | Provide the namespace for organization's peer                                           | default               |
| name            | Provide the name for quorum-raft-crypto job release                                     | quorum-crypto-raft    |

### Peer

| Name            | Description                                                                             | Default Value |
| ----------------| --------------------------------------------------------------------------------------- | ------------- |
| name            | Provide the name of the peer                                                            | carrier       |
| gethPassphrase  | Provide the passphrase for building the crypto files                                    | 12345         |

### Image

| Name               | Description                                                                                  | Default Value                     |
| -------------------| -------------------------------------------------------------------------------------------- | --------------------------------- |
| initContainerName  | Provide the alpine utils image, which is used for all init-containers of deployments/jobs    | ghcr.io/hyperledger/bevel-alpine:latest  |
| pullPolicy         | Pull policy to be used for the Docker image                                                  | IfNotPresent                      |
| node               | Pull quorum Docker image                                                                     | ""                                |

### Vault

| Name                | Description                                                             | Default Value |
| ------------------- | ------------------------------------------------------------------------| ------------- |
| address             | Provide the vault address/URL                                           | ""            |
| role                | Provide the vault role used                                             | vault-role    |
| authpath            | Provide the authpath configured to be used                              | ""            |
| serviceAccountName  | Provide the already created service account name autheticated to vault  | vault-auth    |
| certSecretPrefix    | Provide the vault path where the certificates are stored                | ""            |
| retries             | Number of retries to check contents from vault                          | 30            |

### Sleep

| Name                      | Description                                              | Default Value |
| ------------------------- | -------------------------------------------------------  | ------------- |
| sleepTimeAfterError       | Sleep time in seconds when error while registration      | 120           |
| sleepTime                 | custom sleep time in seconds                             | 20            |

### Healthcheck

| Name                        | Description                                                                                                 | Default Value |
| ----------------------------| ----------------------------------------------------------------------------------------------------------- | ------------- |
| readinesscheckinterval      | Provide the wait interval in seconds in fetching certificates from vault                                    | 5             |
| readinessthreshold          | Provide the threshold number of retries in fetching certificates from vault                                 | 2             |


<a name = "deployment"></a>
## Deployment
---

To deploy the quorum-raft-crypto-gen Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-raft-crypto-gen/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./quorum-raft-crypto-gen
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the raft node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the Job was created. This command will display information about the Job, including the number of completions and the current status of the Job's pods.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-raft-crypto-gen/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./quorum-raft-crypto-gen
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the raft node is up to date.


<a name = "deletion"></a>
## Deletion
---

To delete the deployment and associated resources, run the following Helm command:
```
$ helm uninstall <release-name>
```
Replace `<release-name>` with the name of the release. This command will remove all the resources created by the Helm chart.


<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the [RAFT Crypto GoQuorum Deployment Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-raft-crypto-gen), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
