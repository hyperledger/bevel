[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "orderer-node-hyperledger-fabric-deployment"></a>
# Orderer Node Hyperledger Fabric Deployment

- [Orderer Node Hyperledger Fabric Deployment Helm Chart](#orderer-node-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "orderer-node-hyperledger-fabric-deployment-helm-chart"></a>
## Orderer Node Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-orderernode) for orderer node.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- HAproxy is required as ingress controller.
- Helm installed.


<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
fabric-orderernode/
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

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Defines two ConfigMaps, one for the orderer configuration and one for the genesis block.
- `deployment.yaml`: The kafka-healthcheck checks the health of the Kafka brokers before the main container is started. The certificates-init fetches the TLS and MSP certificates from Vault and stores them in a local directory. The {{ $.Values.orderer.name }} runs the Hyperledger Fabric orderer. The grpc-web exposes the orderer's gRPC API over HTTP/WebSockets. These containers are responsible for ensuring that the orderer is up and running, that it has the necessary certificates, and that it can be accessed by clients.
- `service.yaml`: Ensures internal and external access with exposed ports for gRPC (7050), gRPC-Web (7443), and operations (9443), and optionally uses HAProxy for external exposure and secure communication.
- `servicemonitor.yaml`: Define a ServiceMonitor resource that allows Prometheus to collect metrics from the orderer node's "operations" port. The configuration is conditionally applied based on the availability of the Prometheus Operator's API version and whether metrics are enabled for the orderer service.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-orderernode/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                   | Description                                                           | Default Value                                    |
| ---------------------- | ----------------------------------------------------------------------| -------------------------------------------------|
| namespace              | Namespace for orderer                                                 | org1-net                                      |
| network.version        | HyperLedger Fabric network version                                    | 2.2.2                                             |
| images.orderer         | Valid image name and version for fabric orderer                       | ghcr.io/hyperledger/bevel-fabric-orderer:2.2.2                 |
| images.alpineutils     | Valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-alpine:latest          |
| images.healthcheck     | Valid image name and version for health check of Kafka                | busybox                                          |
| labels                 | Custom labels                                                         | ""                                               |

### Orderer

| Name                        | Description                                                             | Default Value   |
| --------------------------- | ----------------------------------------------------------------------- | ----------------|
| name                        | Name for the orderer node                                               | orderer         |
| loglevel                    | Log level for orderer deployment                                        | info            |
| localmspid                  | Local MSP ID for orderer deployment                                     | OrdererMSP      |
| tlsstatus                   | Enable/disable TLS for orderer deployment                               | true            |
| keepaliveserverinterval     | Interval in which the orderer signals the connection has kept alive     | 10s             |
| address      | Provide the address for orderer    | orderer1.org1proxy.blockchaincloudpoc.com:443  |

### Consensus

| Name     | Description                 | Default Value   |
| ---------| ----------------------------| ----------------|
| name     | Name of the consensus       | raft            |

### Storage

| Name                  | Description                        | Default Value   |
| ----------------------| -----------------------------------| ----------------|
| storageclassname      | Storage class name for orderer     | aws-storageclassname     |
| storagesize           | Storage size for storage class     | 512Mi           |

### Service

| Name                          | Description                               | Default Value   |
| ------------------------------| ------------------------------------------| ----------------|
| servicetype                   | Service type for orderer                  | ClusterIP       |
| ports.grpc.nodeport           | Cluster IP port for grpc service          | ""              |
| ports.grpc.clusteripport      | Cluster IP port for grpc service          | 7050            |
| ports.metrics.enabled         | Enable/disable metrics service            | false           |
| ports.metrics.clusteripport   | Cluster IP port for metrics service       | 9443            |

### Annotations

| Name           | Description                             | Default Value |
| ---------------| --------------------------------------- | --------------|
| service        | Extra annotations for service           | ""            |
| deployment     | Extra annotations for deployment        | ""            |

### Vault

| Name                        | Description                                                         | Default Value                     |
| --------------------------- | --------------------------------------------------------------------| --------------------------------- |
| address                     | Vault server address                                                | ""                                |
| role                        | Vault role for orderer deployment                                   | vault-role                        |
| authpath                    | Kubernetes auth backend configured in vault for orderer deployment  | devorg1-net-auth   |
| type                        | Provide the type of vault                                           | hashicorp    |
| secretprefix                | Vault secretprefix                                                  | secretsv2/data/crypto/ordererOrganizations/org1-net/orderers/orderer.org1-net              |
| imagesecretname             | Image secret name for vault                                         | ""                                |
| serviceaccountname          | Service account name for vault                                      | vault-auth                        |
| tls                         | Enable/disable TLS for vault communication                          | ""                                |

### Kafka

| Name                        | Description                                                             | Default Value   |
| --------------------------- | ------------------------------------------------------------------------| ----------------|
| readinesscheckinterval      | Interval in seconds to check readiness of Kafka services                | 5               |
| readinessthreshold          | Threshold for checking if specified Kafka brokers are up and running    | 4               |
| brokers                     | List of Kafka broker addresses                                          | ""              |

### Proxy

| Name                        | Description                             | Default Value                  |
| --------------------------- | --------------------------------------- | ------------------------------ |
| provider                    | Proxy/ingress provider                  | none                           |
| external_url_suffix         | External URL suffix of the organization | org1proxy.blockchaincloudpoc.com:443    |

### Config

| Name                          | Description                             | Default Value                  |
| ---------------------------   | --------------------------------------- | ------------------------------ |
| pod.resources.limits.memory   | Limit memory for node                   | 512M                           |
| pod.resources.limits.cpu      | Limit CPU for node                      | 1                              |
| pod.resources.requests.memory | Requested memory for node               | 512M                           |
| pod.resources.requests.cpu    | Requested CPU for node                  | 0.25                           |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-orderernode Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-orderernode/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-orderernode
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-orderernode node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-orderernode/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-orderernode
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-orderernode node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Orderer Node Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-orderernode), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
