[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "indy-node"></a>
# indy-node

- [indy-node Helm Chart](#indy-node-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)

<a name = "indy-node-helm-chart"></a>
## indy-node Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/hyperledger-indy/charts/indy-node) helps to deploy indy node job.

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
indy-node/
    |- templates/
            |- _helpers.tpl
            |- job.yaml
    |- Chart.yaml
    |- README.md
    |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`:  Contains custom label definitions used in other templates.
- `job.yaml`:  This file provides information about the kubernetes job 
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-node/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---
### metadata

| Name            | Description                                     | Default Value |
| ----------------| ----------------------------------------------- | ------------- |
| namespace       | Provide the namespace for organization's peer   | bevel       |
| name            | Provide the name for indy-node release      |   indy-node          |


### replicas

| Name      | Description                              | Default Value |
| --------- | ---------------------------------------- | ------------- |
| replicas  | Provide the number of indy-node replicas |  1           |

### network

| Name    | Description                  | Default Value |
| ------- | ---------------------------- | ------------- |
| name    | Provide the name for network |  bevel           |


### organization
 
| Name              | Description                          | Default Value |
| --------          | -----------------------------------  | ------------- |
| name              | Provide the name for organization    | provider            |

# add_new_org is true when adding new validator node to existing network
add_new_org: false



### image

| Name          | Description                                                    | Default Value |
| ------------  | -------------------------------------------------------------- | ------------- |
| initContainer | 
|    name       | Provide the image name for the indy-node init container        | indy-node      |
|    repository | provide the image repository for the indy-node init            | alpine:3.9.4   | 
| cli           |                                                                |             |
|    name       | Provide the image name for the indy-ledger-txn container       | indy-ledger-txn            |
|    repository | Provide the image repository for the indy-ledger-txn container | alpine:3.9.4            |
| indyNode      |                                                                |             |
|    name       |   Provide the name for the indy node                           | indy-node            |
| repository    | Provide the image name for the indy-node  container            | alpine:3.9.4            |
| pullSecret    |  Provide the image pull secret of image                        | regcred            |
     
    

### node

| Name             | Description              | Default Value |
| -----------------| -------------------------| ------------- |
| name             |  Provide the  node name  | indy-node            |
| ip               |  Provide the  node ip    | 0.0.0.0            |
| publicIp         |  Provide the  node ip    | 0.0.0.0            |
| port             |  Provide the  node port  | 9752            |
| ambassadorPort   |  Provide the  node port  | 15911            |

### client

| Name             | Description              | Default Value |
| -----------------| -------------------------| ------------- |
| ip               |  Provide the  node ip    | 0.0.0.0            |
| publicIp         |  Provide the  node ip    | 0.0.0.0            |
| port             |  Provide the  node port  | 9752            |
| ambassadorPort   |  Provide the  node port  | 15912            |

#### service
| Name                 | Description                                  | Default Value |
| -------------------- | ---------------------------------------------| ------------- |
| type                 | Provide type of service (NodePort/ClusterIp) | NodePort            |
| ports                |                                              |             |
|   nodePort           | Provide the service node port                | 9711          |
|   nodeTargetPort     | Provide the service node target port         | 9711          |
|   clientPort Provide | the service client port                      | 9712          |
|   clientTargetPort   | Provide the service client target port       | 9712          |

### configmap

| Name                 | Description                                  | Default Value |
| -------------------- | ---------------------------------------------| ------------- |
| domainGenesis        | Provide the domain genesis                   | ""            |
| poolGenesis          | Provide the pool genesis                     | ""            |
 
   

### ambassador

### vault

| Name                 | Description                                  | Default Value |
| -------------------- | ---------------------------------------------| ------------- |
| address              | Provide the vault server address             | http://54.226.163.39:8200            |
| serviceAccountName   | Provide the service account name for vault   |vault-auth-provider-agent-app""            |
| keyPath              | Provide the key path for vault               | /keys/udisp/keys/indy-node            |
| auth_path            | Provide the authpath                         | kubernetes-bevel-provider-steward-1-auth            |
| nodeId               | Provide the indy-node node Id                | indy-node            |
| role                 | Provide the indy-node role                   | ro|
 

### storage

| Name                 | Description                                        |  Default Value |
| -------------------- | -------------------------------------------------- | -------------  |
| keys                 |                                                    |              |
|   storagesize        |  Provide the storage size for storage for keys     | 512Mi             |
|   storageClassName   |  Provide the storageClassName for storage for keys | ebs             |
| data                 |                                                    |              |
|   storagesize        |  Provide the storage size for storage for data     | 5Gi|
|   storageClassName   |  Provide the storageClassName for storage for data | ebs             |

<a name = "deployment"></a>
## Deployment
---

To deploy the indy-node Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-node/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./indy-node
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the indy auth job to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the jobs, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the job was created. The command will display information about the jobs.


<a name = "updating-the-job"></a>
## Updating the job
---

If we need to update the job with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-indy/charts/indy-node/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./indy-node
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
If you encounter any bugs, have suggestions, or would like to contribute to the  [INDY  authorization job Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/hyperledger-indy/charts/indy-node), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
