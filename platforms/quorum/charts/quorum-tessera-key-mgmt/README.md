[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "ibft-crypto-goquorum-deployment"></a>
# RAFT Crypto GoQuorum Deployment

- [Tessera Key Management Deployment Helm Chart](#tessera-key-management-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "tessera-key-management-deployment-helm-chart"></a>
## Tessera Key Management Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tessera-key-mgmt) helps in generating Tessera crypto.


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
quorum-tessera-key-mgmt/
    |- templates/
            |- helpers.tpl
            |- job.yaml
    |- Chart.yaml
    |- README.md
    |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `job.yaml`: The job.yaml file defines a Kubernetes Job that runs the "tessera-crypto" container. This container interacts with a Vault server to retrieve secrets and generate tessera keys.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes settings for the peer, metadata, image, and Vault configurations.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-ibft-crypto-gen/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Peer

| Name            | Description                                                                             | Default Value |
| ----------------| --------------------------------------------------------------------------------------- | ------------- |
| name            | Provide the name of the peer                                                            | node_1        |

### Metadata

| Name            | Description                                                                             | Default Value         |
| -------------   | --------------------------------------------------------------------------------------- | --------------------- |
| namespace       | Provide the namespace for organization's peer                                           | default               |
| name            | Provide the name for indy-key-mgmt release                                              | indy-key-mgmt         |

### Image

| Name               | Description                                                   | Default Value                              |
| ----------------   | ------------------------------------------------------------- | ------------------------------------------ |
| pullSecret         | Pull policy to be used for the Docker image                   | regcred                                    |
| repository         | Provide the image repository for the indy-key-mgmt container  | quorumengineering/tessera:hashicorp-21.7.3 |

### Vault

| Name                | Description                                                             | Default Value                       |
| ------------------- | ------------------------------------------------------------------------| ----------------------------------- |
| address             | Provide the vault address/URL                                           | ""                                  |
| authpath            | Provide the authpath configured to be used                              | ""                                  |
| role                | Provide the vault role used                                             | vault-role                          |
| serviceAccountName  | Provide the already created service account name autheticated to vault  | vault-auth                          |
| tmprefix            | Provide the vault path where the tm secrets are stored                  | secret/node_1-quo/crypto/node_1/tm  |
| keyprefix           | Provide the vault path where the keys are stored                        | secret/node_1-quo/crypto/node_1/key |


<a name = "deployment"></a>
## Deployment
---

To deploy the quorum-ibft-crypto-gen Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tessera-key-mgmt/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./quorum-tessera-key-mgmt
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the tessera-key-management node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tessera-key-mgmt/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./quorum-tessera-key-mgmt
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the tessera-key-management node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Tessera Key Management Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tessera-key-mgmt), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
