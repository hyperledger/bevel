[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "quorum-member-node-deployment"></a>
# Quorum Member Node Deployment

- [Quorum Member Node Deployment Helm Chart](#quorum-member-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)

<a name = "quorum-member-node-deployment-helm-chart"></a>
## Quorum Member Node Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-member-node) helps to deploy Quorum Member (non-validator) nodes with tessera transaction manager.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- The GoQuorum network is set up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Either HAproxy or Ambassador is required as ingress controller.
- Helm installed.


<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
quorum-member-node/
    |- templates/
            |- _helpers.yaml
            |- configmap.yaml
            |- deployment.yaml
            |- ingress.yaml
            |- service.yaml
    |- Chart.yaml
    |- README.md
    |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `configmap.yaml`: The file defines a ConfigMap that stores the base64-encoded content of the "genesis.json" file under the key "genesis.json.base64" in the specified namespace.
- `deployment.yaml`: This file is a configuration file for deploying a StatefulSet in Kubernetes. It creates a StatefulSet with a specified number of replicas and defines various settings for the deployment. It includes initialization containers for fetching secrets from a Vault server, an init container for initializing the Quorum blockchain network, and a main container for running the Quorum member node. It also specifies volume mounts for storing certificates and data. The StatefulSet ensures stable network identities for each replica.
- `ingress.yaml`: This file is a Kubernetes configuration file for setting up an Ingress resource with HAProxy as the provider. It includes annotations for SSL passthrough and specifies rules for routing traffic based on the host and path.
- `service.yaml`: This file defines a Kubernetes Service with multiple ports for different protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-member-node/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### replicaCount

| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| replicaCount             | Number of replicas                   | 1             |

### metadata

| Name            | Description                                                                  | Default Value |
| ----------------| ---------------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace for the Quorum node                                    | default       |
| labels          | Provide any additional labels                                                | ""            |

### image

| Name           | Description                                                                          | Default Value                         |
| ---------------| ------------------------------------------------------------------------------------ | ------------------------------------- |
| node           | Provide the valid image name and version for quorum node                             | quorumengineering/quorum:2.1.1        |
| alpineutils    | Provide the valid image name and version to read certificates from vault server      | ghcr.io/hyperledger/bevel-alpine:latest      |
| tessera        | Provide the valid image name and version for quorum tessera                          | quorumengineering/tessera:0.9.2       |
| busybox        | Provide the valid image name and version for busybox                                 | busybox                               |
| mysql          | Provide the valid image name and version for MySQL. This is used as the DB for TM    | mysql/mysql-server:5.7                |

### node

| Name                     | Description                                                                    | Default Value     |
| ------------------------ | ------------------------------------------------------------------------------ | -------------     |
| name                     | Provide the name for Quorum node                                               | node-1            |
| status                   | Provide the status of the node as default,additional                           | default           |
| peer_id                  | Provide the id which is obtained when the new peer is added for raft consensus | 5                 |
| consensus                | Provide the consesus for the Quorum network, values can be 'raft' or 'ibft'    | ibft              |
| mountPath                | Provide the mountpath for Quorum pod                                           | /etc/quorum/qdata |
| imagePullSecret          | Provide the docker secret name in the namespace                                | regcred           |
| keystore                 | Provide the keystore file name                                                 | keystore_1        |
| servicetype              | Provide the k8s service type                                                   | ClusterIP         |
| ports.rpc                | Provide the rpc service ports                                                  | 8546              |
| ports.raft               | Provide the raft service ports                                                 | 50401             |
| ports.tm                 | Provide the Tessera Transaction Manager service ports                          | 15013             |
| ports.quorum             | Provide the Quorum port                                                        | 21000             |
| ports.db                 | Provide the DataBase port                                                      | 3306              |
| dbname                   | Provide the mysql DB name                                                      | demodb            |
| mysqluser                | Provide the mysql username                                                     | demouser          |
| mysqlpassword            | Provide the mysql user password                                                | password          |

### vault

| Name               | Description                                                              | Default Value             |
| ----------------   | -------------------------------------------------------------------------| -------------             |
| address            | Address/URL of the Vault server.                                         | ""                        |
| secretprefix       | Provide the Vault secret path from where secrets will be read            | secret/org1/crypto/node_1 |
| serviceaccountname | Provide the service account name verified with Vault                     | vault-auth                |
| keyname            | Provide the key name from where Quorum secrets will be read              | quorum                    |
| tm_keyname         | Provide the key name from where transaction manager secrets will be read | tm                        |
| role               | Provide the service role verified with Vault                             | vault-role                |
| authpath           | Provide the Vault auth path created for the namespace                    | quorumorg1                |

### tessera

| Name          | Description                                                                                                       | Default Value                     |
| ------------- | ----------------------------------------------------------------------------------------------------------------- | -------------                     |
| dburl         | Provide the Database URL                                                                                          | jdbc:mysql://localhost:3306/demodb|
| dbusername    | Provide the Database username                                                                                     | demouser                          |
| dbpassword    | Provide the Database password                                                                                     | ""                                |
| url           | Provide the tessera node's own url. This should be local. Use http if tls is OFF                                  | ""                                |
| othernodes    | Provide the list of tessera nodes to connect in `url: <value>` format. This should be reachable from this node    | ""                                |
| tls           | Provide if tessera will use tls                                                                                   | STRICT                            |
| trust         | Provide the server/client  trust configuration for transaction manager nodes                                            | TOFU                              |


### genesis

| Name    | Description                                    | Default Value |
| --------| ---------------------------------------------- | ------------- |
| genesis | Provide the genesis.json file in base64 format | ""            |


### staticnodes

| Name            | Description                           | Default Value |
| ----------------| --------------------------------------| ------------- |
| staticnodes     | Provide the static nodes as an array  | ""            |

### proxy

| Name                  | Description                                                           | Default Value |
| --------------------- | --------------------------------------------------------------------- | ------------- |
| provider              | The proxy/ingress provider (ambassador, haproxy)                      | ambassador    |
| external_url          | This field contains the external URL of the node                      | ""            |
| portTM                | The TM port exposed externally via the proxy                          | 15013         |
| rpcport               | The RPC port exposed externally via the proxy                         | 15030         |
| quorumport            | The Quorum port exposed externally via the proxy                      | 15031         |
| portRaft              | The Raft port exposed externally via the proxy                        | 15032         |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| storageclassname      | The Kubernetes storage class for the node | awsstorageclass |
| storagesize           | The memory for the node                   | 1Gi             |
| dbstorage             | Provide the memory for database           | 1Gi             |

<a name = "deployment"></a>
## Deployment
---

To deploy the quorum-member-node Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-member-node/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./quorum-member-node
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the quorum member node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get statefulsets -n <namespace>
```
Replace `<namespace>` with the actual namespace where the StatefulSet was created. This command will display information about the StatefulSet, including the number of replicas and their current status.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-member-node/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./quorum-member-node
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the quorum member node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Quorum Member Node Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/develop/platforms/quorum/charts/quorum-member-node), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
