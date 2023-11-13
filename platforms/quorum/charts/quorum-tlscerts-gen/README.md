[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-quorum-tlscerts-gen"></a>
# Ambassador Certs GoQuorum Deployment

- [Ambassador Certs GoQuorum Deployment Helm Chart](#ambassador-certs-goquorum-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "ambassador-certs-goquorum-deployment-helm-chart"></a>
## Ambassador Certs GoQuorum Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tlscerts-gen) facilitates the deployment of Ambassador certificates using Kubernetes Jobs and stores them securely in HashiCorp Vault.


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
quorum-tlscerts-gen/
  |- templates/
      |- helpers.tpl
      |- configmap.yaml
      |- job.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `configmap.yaml`: A Kubernetes ConfigMap resource that holds the OpenSSL configuration file.
- `job.yaml`: This file defines the Kubernetes Job resource for generating ambassador certificates and storing them in the Hashicorp Vault.
- `Chart.yaml`: This file contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: This file contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tlscerts-gen/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| name       | Provide the name of the node                       | node_1        |

### Metadata

| Name            | Description                                                                  | Default Value |
| ----------------| ---------------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace for the quorum Certs Generator.                        | default       |
| labels          | Provide any additional labels for the quorum Certs Generator                 | ""            |

### Image

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| initContainerName        | Provide the alpine utils image, which is used for all init-containers of deployments/jobs  | ""              |
| certsContainerName       | Provide the image for the certs container                                                  | ""              |
| imagePullSecret          | Provide the docker-registry secret created and stored in kubernetes cluster as a secret    | regcred         |
| pullPolicy               | Pull policy to be used for the Docker image                                                | IfNotPresent    |

### Vault

| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server.                                          | ""            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | quorumnode_1  |
| serviceaccountname        | Provide the already created service account name autheticated to vault    | vault-auth    |
| certsecretprefix          | Provide the vault path where the certificates are stored                  | ""            |
| retries                   | Number of retries to check contents from vault                            | 30            |
| type                  | The type of Vault used | hashicorp |

### Subjects

| Name                      | Description                        | Default Value |
| ------------------------- | ---------------------------------- | ------------- |
| root_subject              | Mention the subject for rootca     | "CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"            |
| cert_subject              | Mention the subject for cert       | "CN=DLT Root CA/OU=DLT/O=DLT/L=London/C=GB"            |

### OpenSSL Vars

| Name                      | Description                                               | Default Value |
| --------------------------| ----------------------------------------------------------| ------------- |
| domain_name               | Provides the name for domain                              | ""            |
| domain_name_api           | Provides the name for domain_name api endpoint            | ""            |
| domain_name_web           | provides the name for domain_name web endpoint            | ""            |
| domain_name_tessera       | provides the name for domain domain_name tessera endpoint | ""            |

<a name = "deployment"></a>
## Deployment
---

To deploy the quorum-tlscerts-gen Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tlscerts-gen/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./quorum-tlscerts-gen
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the Quorum Connector to the Kubernetes cluster based on the provided configurations.

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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tlscerts-gen/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./quorum-tlscerts-gen
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the quorum-tlscerts-gen node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Ambassador Certs GoQuorum Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-tlscerts-gen), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
