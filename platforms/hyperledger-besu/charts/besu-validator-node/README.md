[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "validator-node-deployment"></a>
# Validator Node Deployment

- [Validator Node Deployment Helm Chart](#validator-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "validator-node-deployment-helm-chart"></a>
## Validator Node Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-validator-node) helps to deploy Besu validator nodes.

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
besu-validator-node/
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
- `helpers.tpl`: A template file used for defining custom labels and ports for the metrics in the Helm chart.
- `configmap.yaml`: The file defines a ConfigMap that stores the base64-encoded content of the "genesis.json" file under the key "genesis.json.base64" in the specified namespace.
- `deployment.yaml`: This file is a configuration file for deploying a StatefulSet in Kubernetes. It creates a StatefulSet with a specified number of replicas and defines various settings for the deployment. It includes initialization containers for fetching secrets from a Vault server, an init container for initializing the Besu blockchain network, and a main container for running the Besu node. It also specifies volume mounts for storing certificates and data. The StatefulSet ensures stable network identities for each replica.
- `service.yaml`: This file defines a Kubernetes Service with multiple ports for different protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `servicemonitor.yaml`: This file defines a Kubernetes ServiceMonitor in order to monitor the metrics of the nodes.
- `Chart.yaml`: Provides metadata about the chart, such as its name, version, and description.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the chart. It includes configuration for the metadata, image, node, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-validator-node/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---


### Metadata


| Name            | Description                                                                  | Default Value |
| ----------------| ---------------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace                                | default       |


### ReplicaCount


| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| replicaCount             | Number of replicas                   | 1             |


### Staticnodes


| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| staticnodes              | Provide the static-nodes as a list. The url is formed by enode://<node_public_key>@<ambassador_ip>:<ambassador_p2p_port>                | ""             |


### Liveliness_check


| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| enabled                  | Set this field as true/false to turn the liveliness check on/off     | false             |
| url                      | Provide the bootnode URL             | ""            |
| port                     | Provide the rpc port of the bootnode             | ""             |


### Healthcheck


| Name                        | Description                                                                   | Default Value |
| ----------------------------| ------------------------------------------------------------------------------| ------------- |
| readinessthreshold          | Provide the threshold number of retries in fetching certificates from vault   | 100             |
| readinesscheckinterval      | Provide the wait interval in seconds in fetching certificates from vault      | 5             |


### Proxy


| Name                  | Description                                                           | Default Value |
| --------------------- | --------------------------------------------------------------------- | ------------- |
| provider              | The proxy/ingress provider (ambassador, haproxy)                      | ambassador    |
| external_url          | This field contains the external URL of the node                      | ""            |
| p2p                   | The P2P port configured on proxy                         | 15010         |
| rpc                   | the RPC port configured on proxy                         | 15011         |


### Image


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| alpineutils        | Provide the alpine utils image  | ghcr.io/hyperledger/bevel-alpine:latest             |
| node               | Provide the image of besu version specified in the network.yaml (network.version)  | hyperledger/besu:22.10.2            |
| pullPolicy               | Pull policy to be used for the Docker image                                                | IfNotPresent    |


### Node


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| name               | Provide the name of the node.                                       | node1   |
| consensus          | Provides the consensus used by the network                                       | ibft   |
| tls                | Provide the information for the tls support                         | True   |
| imagePullSecret    | Provide the docker-registry secret created and stored in kubernetes cluster as a secret              | regcred   |
| mountPath          | Provide the mountpath                        |  /opt/besu/data   |
| servicetype        | Provide the k8s service type                 | ClusterIP   |
| ports.p2p          | Provide the p2p service ports                | 30303   |
| ports.rpc          | Provide the rpc service ports                | 8545   |
| ports.ws           | Provide the ws service port                  | 8546   |
| permissioning.enabled        | Enable/disable onchain permissioniong for besu nodes                    | False           |


### Storage


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| storageclassname        | Provide the name of the storageclass. Make sure that the storageclass exist prior to this deployment, this chart doesn't create the storageclass                    | awsstorageclass           |
| storagesize        | Provide the size of the volume                    | 1Gi           |


### Vault


| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth    |
| address                   | Address/URL of the Vault server                                          | ""            |
| secretengine              | Provide the secret engine                                                | secretsv2     | 
| secretPrefix              | Provide the vault path where the nodekey is stored                                             | ""     |
| keyname                   | Provide the name of the folder containing the nodekey                                             | data  |
| tlsdir                    | Provide the name of the folder containing the tls crypto for besu validator                  | tls            |
| authpath                  | Authentication path for Vault                                             | besunode1  |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| type        | Provide the type of vault    | hashicorp    |


### Genesis


| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------                                    | --------------- |
| genesis        | Provide the genesis.json file in base64 format                         | ""           |


### Metrics

| Name                      | Description                        | Default Value |
| ------------------------- | ---------------------------------- | ------------- |
| enabled             | Enable/disable metrics for the node       | false            |
| port             | Mention the subject for ambassador tls       | 9545           |


<a name = "deployment"></a>
## Deployment
---

To deploy the besu-validator-node Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-validator-node/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./besu-validator-node
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the Besu validator nodes to the Kubernetes cluster based on the provided configurations.

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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-validator-node/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./besu-validator-node
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the besu-validator-node node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Ambassador Certs GoQuorum Deployment Helm Chart](ttps://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-validator-node), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
