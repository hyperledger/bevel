[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "tessera-node-deployment"></a>
# Tessera Node Deployment

- [Tessera Node Deployment Helm Chart](#tessera-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "tessera-node-deployment-helm-chart"></a>
## Tessera Node Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-tessera-node) helps to deploy Besu tessera nodes.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- The Besu network is set up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm installed.

<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
besu-tessera-node/
  |- templates/
        |- _helpers.yaml
        |- configmap.yaml
        |- deployment.yaml
        |- service.yaml
        |- servicemonitor.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: This directory contains the template files for generating Kubernetes resources.
- `helpers.tpl`: A template file used for defining custom labels in the Helm chart.
- `configmap.yaml`: The file defines a ConfigMap that content of the "tessera-config.json" file under the key "tessera-config.json.tmpl" in the specified namespace.
- `deployment.yaml`: This file is a configuration file for deploying a StatefulSet in Kubernetes. It creates a StatefulSet with a specified number of replicas and defines various settings for the deployment. It includes initialization containers for fetching secrets from a Vault server, an init container for initializing the Besu blockchain network, and a main container for running the Besu node. It also specifies volume mounts for storing certificates and data. The StatefulSet ensures stable network identities for each replica.
- `service.yaml`: This file defines a Kubernetes Service with multiple ports for different protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `servicemonitor.yaml`: This file defines a Kubernetes ServiceMonitor in order to monitor the metrics of the nodes.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-tessera-node/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### ReplicaCount


| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| replicaCount             | Number of replicas                   | 1             |


### Metadata


| Name            | Description                                                                  | Default Value |
| ----------------| ---------------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace                                | default       |
| labels          | Provide labels other than name, release name , release service, chart version , chart name. Run
  these lables will not be applied to VolumeClaimTemplate of StatefulSet as labels are automatically picked up by Kubernetes                                 | ""       |


### Images 


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| alpineutils        | Provide the alpine utils image  | ghcr.io/hyperledger/bevel-alpine-ext:latest             |
| tessera        | Provide the valid image name and version for tessera  | quorumengineering/tessera:hashicorp-21.7.3             |
| busybox               | Provide the valid image name and version for busybox  | busybox            |
| mysql               | Provide the valid image name and version for MySQL. This is used as the DB for TM  | mysql/mysql-server:5.7            |
| imagePullSecret               | Provide the docker secret name in the namespace  | regcred            |
| pullPolicy               | Pull policy to be used for the Docker image                                                | IfNotPresent    |


### Tessera


| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| name              | Provide the name for tessera node                | node1         |
| dbname            | Provide the mysql DB name                        | demodb         |
| dburl             | Provide the Database URL                         | ""         |
| dbusername        | Provide the Database username                    | demouser         |
| dbpassword        | Provide the Database password                    | ""         |
| url               | Provide the tessera node's own url. This should be local. Use http if tls is OFF                    | ""         |
| clienturl         | Provide the client url for tessera node                    | ""         |
| othernodes        | Provide the list of tessera nodes to connect in url. This should be reachable from this node                    | ""         |
| tls               | Provide if tessera will use tls                 | STRICT         |
| trust             | Provide the server/client  trust configuration for nodes          | CA_OR_TOFU         |
| servicetype       | Provide the k8s service type          | ClusterIP         |
| ports.tm          | Provide the Tessera Transaction Manager service ports           | 443         |
| ports.db          | Provide the DataBase port                                        | 3306              |
| ports.client      | Provide the Client port                                          | 15023              |
| mountPath         | Provide the mountpath for Tessera pod                      | /etc/tessera/data              |
| ambassadorSecret         | Provide the secret name to be used with TLScontext                      | ""             |


### Vault


| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server.                                          | ""            |
| secretengine              | Provide the secret engine.                                                | secretsv2     |
| secretPrefix              | Provide the Vault secret path from where secrets will be read                                             | ""    |
| tmsecretpath              | Provide the Vault secret path from where transaction manager secrets will be read                                             | ""     |
| serviceaccountname        | Provide the already created service account name autheticated to vault    | vault-auth    |
| address                   | Address/URL of the Vault server.                                          | ""            |
| keyname                   | Provide the key name from where besu secrets will be read                                             | data  |
| tm_keyname                    | Provide the key name from where transaction-manager secrets will be read                  | transaction            |
| tlsdir                    | Provide the name of the folder containing the tls crypto for besu validator                  | tls            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | besunode1  |
| type        | Provide the type of vault    | hashicorp    |


### Proxy


| Name                  | Description                                                           | Default Value |
| --------------------- | --------------------------------------------------------------------- | ------------- |
| provider              | The proxy/ingress provider (ambassador, haproxy)                      | ambassador    |
| external_url          | This field contains the external URL of the node                      | ""            |
| portTM                | The TM port exposed externally via the proxy                          | 15013         |


### Storage


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| storageclassname        | Provide the kubernetes storageclass for node                    | awsstorageclass           |
| storagesize             | Provide the memory for node                  | 1Gi           |
| dbstorage               | Provide the memory for database              | 1Gi           |


### Metrics


| Name                      | Description                        | Default Value |
| ------------------------- | ---------------------------------- | ------------- |
| enabled             | Enable/disable metrics for the node       | false            |
| port             | Mention the subject for ambassador tls       | 9545           |


<a name = "deployment"></a>
## Deployment
---

To deploy the besu-tessera-node Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-tessera-node/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./besu-tessera-node
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the Besu tessera nodes to the Kubernetes cluster based on the provided configurations.

<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get statefulsets -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of 
replicas and their current status.

<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-tessera-node/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./besu-tessera-node
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the besu-tessera-node node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Ambassador Certs GoQuorum Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-tessera-node), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
