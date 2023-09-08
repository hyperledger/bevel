[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "vault-k8s-mgmt-deployment"></a>
# Validator Node Deployment

- [Vault k8s Management Deployment Helm Chart](#vault-k8s-management-deploymenthelm-chart)
- [Prerequisitess](#prerequisitess)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Parameters](#parameters)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "vault-k8s-mgmt-deployment-helm-chart"></a>
## Vault k8s Management DeploymentHelm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/shared/charts/vault-k8s-mgmt) This file makes the configurations required to store the crypto materials in the vault.

<a name = "prerequisites"></a>
## Prerequisitess
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm installed.

<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
vault-k8s-mgmt/
  |- templates/
        |- _helpers.yaml
        |- configmap.yaml
        |- job.yaml
        |- serviceAccount.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `configmap.yaml`: The file defines a ConfigMap that stores the base64-encoded content of the "genesis.json" file under the key "genesis.json.base64" in the specified namespace.
- `job.yaml`: This file defines the Kubernetes job resource to configure the store and allow its use for the storage of Cryptographic materials. Create the secret path, authpath, policies and roles.
- `serviceAccount.yaml`: This file defines a kubernetes Service Account and ClusterRoleBinding, which will be created on job execution.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/shared/charts/vault-k8s-mgmt/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---


### Metadata


| Name                  | Description                                                           | Default Value                                     |
| ----------------------| ----------------------------------------------------------------------| --------------------------------------------------|
| name                  | Organization's name                                                   | org1                                              |
| namespace             | Organization's namespace                                              | org1-net                                          |
| images.alpineutils    | valid image name and version to read certificates from vault server   | index.docker.io/hyperledgerlabs/alpine-utils:1.0  |
| labels                | Custom labels                                                         | ""                                                |


### Vault


| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| address                   | Address/URL of the Vault server.                                          | ""            |
| authpath                  | Authentication path for Vault                                             | ""            |
| policy                    | Provide the vault policy name                                             | ""            |
| policydata                | Provide the vault policy file contents in json format                     | ""            |
| secret_path               | Provide the value for vault secretprefix                                  | secretv2      |
| imagesecretname           | Provide the docker secret name in the namespace                           | ""            |
| tls                       | Enable or disable TLS for vault communication if value present or not     | ""            |


### K8s


| Name             | Description                          | Default Value |
| -----------------| ------------------------------------ | ------------- |
| kubernetes_url   | Provide the kubernetes host url      | ""            |


### Rbac


| Name       | Description                                          | Default Value |
| -----------| -----------------------------------------------------| ------------- |
| create     | Specifies whether RBAC resources should be created   | true          |


### ServiceAccount


| Name         | Description                                            | Default Value |
| -------------| -------------------------------------------------------| ------------- |
| create       | Specifies whether a ServiceAccount should be created   | true          |
| name         | The name of the ServiceAccount to use.                 | vault-auth    |


<a name = "deployment"></a>
## Deployment
---

To deploy the vault-k8s-mgmt Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/shared/charts/vault-k8s-mgmt/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./vault-k8s-mgmt
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the Vault k8s Management job to the Kubernetes cluster based on the provided configurations.

<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get deployments -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of 
replicas and their current status.

<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/shared/charts/vault-k8s-mgmt/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./vault-k8s-mgmt
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the vault-k8s-mgmt node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Ambassador Certs GoQuorum Deployment Helm Chart](ttps://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/vault-k8s-mgmt), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
