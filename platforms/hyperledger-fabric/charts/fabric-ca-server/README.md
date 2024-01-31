[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "ca-server-hyperledger-fabric-deployment"></a>
# CA Server Hyperledger Fabric Deploymen

- [CA Server Hyperledger Fabric Deployment Helm Chart](#ca-server-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "ca-server-hyperledger-fabric-deployment-helm-chart"></a>
## CA Server Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-ca-server) to deploy a CA server.


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
fabric-ca-server/
  |- conf/
      |- fabric-ca-server-config-default.yaml
  |- templates/
      |- _helpers.yaml
      |- configmap.yaml
      |- deployment.yaml
      |- service.yaml
      |- volume.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `fabric-ca-server-config-default.yaml`: Configuration file for the fabric-ca-server command.
- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Store the configuration for the Fabric CA server. The configuration file is stored in the fabric-ca-server-config.yaml file, and it is mounted into the Fabric CA server container. The ConfigMap is optional, and it is only used if the server.configpath value is set. Otherwise, the default configuration for the Fabric CA server will be used.
- `deployment.yaml`: Deploys CA server Pod, allowing it to handle certificate-related operations within the Hyperledger Fabric blockchain network. To ensure the security and proper configuration of the CA server, the included init-container retrieves essential secrets from a Vault server.
- `service.yaml`: Expose a Fabric CA server to the outside world either using HaProxy as a reverse proxy engine.
- `volume.yaml`: Defines a persistent volume that can be used to store the Fabric CA server's database.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-ca-server/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Metadata

| Name                  | Description                                                      | Default Value                                     |
| ----------------------| -----------------------------------------------------------------| --------------------------------------------------|
| namespace             | Namespace for CA server                                          | org1-net                                          |
| images.ca             | image name and version for fabric ca                             | ghcr.io/hyperledger/bevel-fabric-ca:1.4.8                       |
| images.alpineutils    | image name and version to read certificates from vault server    | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                | Provide the custom labels                                        | ""                                                |


### Server

| Name                  | Description                                                      | Default Value                              |
| ----------------------| -----------------------------------------------------------------| -------------------------------------------|
| name                  | Name for CA server deployment                                    | ca                                         |
| tlsstatus             | Specify if TLS is enabled or disabled for the deployment         | true                                       |
| admin                 | Admin name for CA server                                         | admin                                      |
| configpath            | Path for Fabric CA Server Config                                 | conf/fabric-ca-server-config-default.yaml  |

### Storage

| Name                  | Description                           | Default Value |
| ----------------------| --------------------------------------| ------------- |
| storageclassname      | Storage class name for CA server      | aws-storageclass   |
| storagesize           | Size of storage for CA server         | 512Mi         |

### Vault

| Name                  | Description                                                         | Default Value                     |
| ----------------------| --------------------------------------------------------------------| --------------------------------- |
| address               | Vault server address                                                | ""                                |
| role                  | Vault role for deployment                                           | vault-role                        |
| authpath              | Kubernetes auth backend configured in Vault for CA server           | fra-demo-hlkube-cluster-cluster   |
| secretcert            | Path of secret certificate configured in Vault for CA server        | secretsv2/data/crypto/peerOrganizations/org1-net/ca?ca.org1-net-cert.pem                |
| secretkey             | Path of secret key configured in Vault for CA server                | secretsv2/data/crypto/peerOrganizations/org1-net/ca?org1-net-CA.key               |
| secretadminpass       | Secret path for admin password configured in Vault for CA server    | secretsv2/data/credentials/org1-net/ca/org1?user          |
| serviceaccountname    | Service account name for Vault                                      | vault-auth                        |
| type        | Provide the type of vault    | hashicorp    |
| imagesecretname       | Image secret name for Vault                                         | ""                                |
| tls                   | Enable or disable TLS for Vault communication                       | ""                                |
| tlssecret             | Kubernetes secret for Vault CA certificate                          | vaultca                           |

### Service

| Name                      | Description                                        | Default Value  |
| --------------------------| ---------------------------------------------------| ---------------|
| servicetype               | Service type for the pod                           | ClusterIP      |
| ports.tcp.nodeport        | TCP node port to be exposed for CA server          | 30007          |
| ports.tcp.clusteripport   | TCP cluster IP port to be exposed for CA server    | 7054           |

### Annotations

| Name        | Description                            | Default Value |
| ------------| ---------------------------------------| ------------- |
| service     | Extra annotations for the service      | ""            |
| pvc         | Extra annotations for the PVC          | ""            |

### Proxy

| Name                  | Description                                                              | Default Value                  |
| ----------------------| -------------------------------------------------------------------------|--------------------------------|
| provider              | Proxy/ingress provider. Possible values: "haproxy" or "none"             | haproxy                        |
| type                  | Type of the deployment. Possible values: "orderer", "peer", or "test"    | test                           |
| external_url_suffix   | External URL suffix for the organization                                 | org1proxy.blockchaincloudpoc.com    |


<a name = "deployment"></a>
## Deployment
---

To deploy the ca Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-ca-server/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-ca-server
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the ca server node to the Kubernetes cluster based on the provided configurations.


a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get deployments -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of replicas and their current status.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-ca-server/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-ca-server
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the ca server node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [CA Server Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-ca-server), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
