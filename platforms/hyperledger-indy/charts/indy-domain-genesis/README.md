[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "indy-domain-genesis"></a>
# indy-domain-genesis

- [indy-domain-genesis Helm Chart](#indy-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-job)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)

<a name = "# indy-node-deployment-helm-charts"></a>
## indy-domain-genesis Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/hyperledger-indy/charts/indy-domain-genesis) helps to deploy the indy-domain-genesis job.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- Helm installed.

<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
indy-domain-genesis/
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
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-domain-genesis/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---
### metadata

| Name            | Description                                      | Default Value       |
| ----------------| -----------------------------------------------  | --------------------|
| namespace       | Provide the namespace for organization's peer    | bevel               |
| name            | Provide the name for indy-domain-genesis release | indy-domain-genesis |


### organization

| Name            | Description                                      | Default Value |
| ----------------| -------------------------------------------------| ------------- |
| name            | Provide the namespace for organization's peer    | provider      |
| configmap       | Provide the name for organization                | configmap     |

<a name = "deployment"></a>
## Deployment
---

To deploy the indy-domain-genesis job Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-domain-genesis/values.yam) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./indy-domain-genesis
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the indy-domain-genesis job to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the jobs, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the job was created. The command will display information about the jobs.


<a name = "updating-the-Deployment"></a>
## Updating the Deployment
---

If we need to update the job with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-domain-genesis/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./indy-domain-genesis
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
