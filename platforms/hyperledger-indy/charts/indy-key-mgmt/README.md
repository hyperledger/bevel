[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "indy-key-mgmt"></a>
# indy-key-mgmt

- [indy-key-mgmt Helm Chart](#indy-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-job)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)

<a name = "# indy-key-mgmt"></a>
## indy-key-mgmt Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/hyperledger-indy/charts/indy-key-mgmt) helps to deploy the indy-key-mgmt job.

<a name = "prerequisites"></a>
## Prerequisites
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
indy-key-mgmt/
    |- templates/
            |- _helpers.tpl
            |- configmap.yaml
    |- Chart.yaml
    |- README.md
    |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `_helpers.tpl`:  Contains custom label definitions used in other templates.
- `configmap.yaml`:  This file provides information about the kubernetes configmap job 
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-key-mgmt/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---
### metadata

| Name            | Description                                      | Default Value   |
| ----------------| -----------------------------------------------  | ----------------|
| namespace       | Provide the namespace for organization's peer    | bevel           |
| name            | Provide the name for indy-key-mgmt release       | indy-key-mgmt   |

### network

| Name            | Description                                      | Default Value |
| ----------------| -----------------------------------------------  | ------------- |
| name            | Provide the name for network                     | bevel         |

### image
| Name            | Description                                                  | Default Value   |
| ----------------| -----------------------------------------------------------  | ----------------|
| name            | Provide the image name for the indy-key-mgmt container       | indy-key-mgmt   |
| repository      | Provide the image repository for the indy-key-mgmt container | ind-key-mgmt:lts|
| pullSecret      | Provide the image pull secret of image                       | regcred         | 

### vault

| Name                | Description                                   | Default Value |
| ----------------    | -------------------------------------------   | ------------- |
| address             | Provide the vault server address              | http://54.226.163.39:8200  |
| version             | Provide the vault secret version address      | "1 or 2"      |
| keyPath             | Provide the key path for vault                | provider.stewards   |
| identity            | Provide the identity for vault                | my-identity          |
| auth_path           | Provide the authpath                          | kubernetes-bevel-provider-admin-auth |
| certsecretprefix    | Provide the vault path where the  certificates are stored  | secret/organisation-name            |
| retries             | Provide The amount of times to retry fetching from/writing to Vault before giving up        | "10"          |
| sleepTimeAfterError | The amount of time in seconds to wait after an error occurs when fetching from/writing to Vault""      | "15"          |




### account

| Name    | Description                       | Default Value |
| --------| --------------------------------- | ------------- |
| service | Provide the service account name  | vault-auth-provider-agent-app     |
| role    |Provide the service account role   | ro          |


<a name = "deployment"></a>
## Deployment
---

To deploy the indy-key-mgmt job Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-key-mgmt/values.yam) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./indy-key-mgmt
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the indy-key-mgmt job to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the jobs, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the job was created. The command will display information about the jobs.


<a name = "updating-the-deployment"></a>
## Updating the deployment
---

If we need to update the job with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-key-mgmt/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./indy-key-mgmt
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the job , ensuring the job  is up to date.


<a name = "deletion"></a>
## Deletion
---

To delete the jobs and associated resources, run the following Helm command:
```
$ helm uninstall <release-name>
```
Replace `<release-name>` with the name of the release. This command will remove all the resources created by the Helm chart.


<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the  [INDY  authorization job Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/hyperledger-indy/charts/indy-auth-job), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
