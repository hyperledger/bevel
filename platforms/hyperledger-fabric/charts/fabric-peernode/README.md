[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "peer-node-hyperledger-fabric-deployment"></a>
# Peer Node Hyperledger Fabric Deployment

- [Peer Node Hyperledger Fabric Deployment Helm Chart](#peer-node-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "peer-node-hyperledger-fabric-deployment-helm-chart"></a>
## Peer Node Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-peernode) for peer node.


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
fabric-peernode/
  |- conf/
      |- default_core.yaml
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

- `default_core.yaml`: Default configuration file for the peer node.
- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Provides a way to configure the Hyperledger Fabric peer and enable it to join the network, interact with other nodes. The environment variables that are defined in the peer-config ConfigMap are used to configure the peer's runtime behavior. The configuration for the MSP is defined in the msp-config ConfigMap. The core.yaml file is used to configure the chaincode builder
- `deployment.yaml`: The certificates-init container fetches TLS certificates and other secrets from Vault. The couchdb container runs a CouchDB database that is used to store the ledger state. The {{ $.Values.peer.name }} container runs a Hyperledger Fabric peer that manages the ledger and provides access to the blockchain network. The grpc-web container runs a gRPC-Web proxy that allows gRPC services to be accessed via a web browser.
- `service.yaml`: Ensures internal and external access with exposed ports for gRPC (7051), events (7053), CouchDB (5984), gRPC-Web (7443), and operations (9443), and optionally uses HAProxy for external exposure and secure communication.
- `servicemonitor.yaml`: Define a ServiceMonitor resource that allows Prometheus to collect metrics from the peer node's "operations" port. The configuration is conditionally applied based on the availability of the Prometheus Operator's API version and whether metrics are enabled for the peer service.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-peernode/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                                           | Default Value                                     |
| ----------------------| ----------------------------------------------------------------------| --------------------------------------------------|
| namespace             | Provide the namespace for organization's peer                         | org1-net                                  |
| images.couchdb        | valid image name and version for fabric couchdb                       | ghcr.io/hyperledger/bevel-fabric-couchdb:2.2.2                                       |
| images.peer           | valid image name and version for fabric peer                          | ghcr.io/hyperledger/bevel-fabric-peer:2.2.2                     |
| images.alpineutils    | valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                | Provide custom labels                                                 | ""                                                |

### Annotations

| Name           | Description                             | Default Value |
| ---------------| --------------------------------------- | --------------|
| service        | Extra annotations for service           | ""            |
| pvc            | Extra annotations for pvc               | ""            |
| deployment     | Extra annotations for deployment        | ""            |

### Peer

| Name                                      | Description                                                           | Default Value                                 |
| ------------------------------------------| ----------------------------------------------------------------------| ----------------------------------------------|
| name                                      | Name of the peer as per deployment yaml                               | peer0                                         |
| gossippeeraddress                         | URL of gossipping peer and port for grpc                              | peer1.org1-net.svc.cluster.local:7051 |
| gossipexternalendpoint                    | URL of gossip external endpoint and port for haproxy https service | peer0.org1-net.org1proxy.blockchaincloudpoc.com:443               |
| localmspid                                | Local MSP ID for the organization                                     | Org1MSP                                       |
| loglevel                                  | Log level for organization's peer                                     | info                                          |
| tlsstatus                                 | Set to true or false for organization's peer                          | true                                          |
| builder                                   | Valid chaincode builder image for Fabric                              | hyperledger/fabric-ccenv:2.2.2                |
| couchdb.username                          | CouchDB username (mandatory if provided)                              | org1-user                                     |
| configpath                                | Provide the configuration path                                        | ""                                            |
| core                                      | Provide core configuration                                            | ""                                            |
| mspconfig.organizationalunitidentifiers   | Provide the members of the MSP in organizational unit identifiers     | ""                                            |
| mspconfig.nodeOUs.clientOUidentifier.organizationalunitidentifier  | Organizational unit identifier for client nodes          | client                            |
| mspconfig.nodeOUs.peerOUidentifier.organizationalunitidentifier    | Organizational unit identifier for peer nodes            | peer                              |
| mspconfig.nodeOUs.adminOUidentifier.organizationalunitidentifier   | Organizational unit identifier for admin nodes (2.2.x)   | admin                             |
| mspconfig.nodeOUs.ordererOUidentifier.organizationalunitidentifier | Organizational unit identifier for orderer nodes (2.2.x) | orderer                           |

### Storage

| Name                      | Description                      | Default Value       |
| --------------------------| -------------------------------- | ------------------- |
| peer.storageclassname     | Storage class name for peer      | aws-storageclass         |
| peer.storagesize          | Storage size for peer            | 512Mi               |
| couchdb.storageclassname  | Storage class name for CouchDB   | aws-storageclass         |
| couchdb.storagesize       | Storage size for CouchDB         | 512Mi               |

### Vault

| Name                  | Description                                                           | Default Value                                     |
| ----------------------| ----------------------------------------------------------------------| --------------------------------------------------|
| role                  | Vault role for the organization                                       | vault-role                                        |
| address               | Vault server address                                                  | ""                                                |
| authpath              | Kubernetes auth backend configured in vault for the organization      | devorg1-net-auth                      |
| secretprefix          | Vault secret prefix                                                   | ssecretsv2/data/crypto/peerOrganizations/org1-net/peers/peer0.org1-net                              |
| serviceaccountname    | Service account name for vault                                        | vault-auth                                        |
| type                  | Provide the type of vault                                             | hashicorp    |
| imagesecretname       | Image secret name for vault                                           | ""                                                |
| secretcouchdbpass     | Vault path for secret CouchDB password                                | secretsv2/data/credentials/org1-net/couchdb/org1?user  |
| tls                   | Enable or disable TLS for vault communication                         | ""                                                |

### Service

| Name                          | Description                               | Default Value       |
| ----------------------------- | ------------------------------------------| ------------------- |
| servicetype                   | Service type for the peer                 | ClusterIP           |
| loadBalancerType              | Load balancer type for the peer           | ""                  |
| ports.grpc.nodeport           | Cluster IP port for grpc service          | ""                  |
| ports.grpc.clusteripport      | Cluster IP port for grpc service          | 7051                |
| ports.events.nodeport         | Cluster IP port for event service         | ""                  |
| ports.events.clusteripport    | Cluster IP port for event service         | 7053                |
| ports.couchdb.nodeport        | Cluster IP port for CouchDB service       | ""                  |
| ports.couchdb.clusteripport   | Cluster IP port for CouchDB service       | 5984                |
| ports.metrics.enabled         | Enable/disable metrics service            | false               |
| ports.metrics.clusteripport   | Cluster IP port for metrics service       | 9443                |

### Proxy

| Name                  | Description                                               | Default Value       |
| ----------------------| ----------------------------------------------------------| ------------------- |
| provider              | Proxy/ingress provider ( haproxy or none)     | none                |
| external_url_suffix   | External URL of the organization                          | org1proxy.blockchaincloudpoc.com                  |
| port                  | External port on proxy service                               | 443                 |

### Config

| Name                          | Description                 | Default Value       |
| ----------------------------- | --------------------------- | ------------------- |
| pod.resources.limits.memory   | Limit memory for node       | 512M                |
| pod.resources.limits.cpu      | Limit CPU for node          | 1                   |
| pod.resources.requests.memory | Requested memory for node   | 512M                |
| pod.resources.requests.cpu    | Requested CPU for node      | 0.25                |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-peernode Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-peernode/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-peernode
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-peernode node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-peernode/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-peernode
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-peernode node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Peer Node Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-peernode), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
