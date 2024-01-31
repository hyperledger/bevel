[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "anchor-peer-hyperledger-fabric-deployment"></a>
# Anchor Peer Hyperledger Fabric Deployment

- [Anchor Peer Hyperledger Fabric Deployment Helm Chart](#anchor-peer-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "anchor-peer-hyperledger-fabric-deployment-helm-chart"></a>
## Anchor Peer Hyperledger Fabric Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-anchorpeer) updates the anchor peers for the Hyperledger Fabric channel.


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
fabric-anchorpeer/
  |- templates/
      |- _helpers.yaml
      |- anchorpeer.yaml
      |- configmap.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `anchorpeer.yaml`: Uses two initContainers to fetch the orderer TLS certificates and the MSP certificates from Vault. The main container then uses the fetched certificates to update the anchor peer for the channel.
- `configmap.yaml`: Stores configuration data for an anchor peer. The file contains two ConfigMaps, one for the configuration data and one for the artifacts. The configuration ConfigMap contains the key-value pairs that are used to configure the peer, and the artifacts ConfigMap contains the base64-encoded transaction that anchors the peer to the channel.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-anchorpeer/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Metadata

| Name                  | Description                                                                       | Default Value                                     |
| ----------------------| ----------------------------------------------------------------------------------| --------------------------------------------------|
| namespace             | Provide the namespace for organization's peer                                     | org1-net                                  |
| images.fabrictools    | Provide the valid image name and version                                          | ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                  |
| images.alpineutils    | Provide the valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                | Provide the custom labels                                                         | ""                                                |

### Peer

| Name          | Description                                                                                             | Default Value                 |
| --------------| --------------------------------------------------------------------------------------------------------| ------------------------------|
| name          | Provide the name of the peer as per deployment yaml                                                     | peer0                         |
| address       | Provide the address of the peer which will update the channel about the anchor peer of the organization | peer0.org1-net:7051   |
| localmspid    | Provide the localmspid for organization                                                                 | org1MSP                       |
| loglevel      | Provide the loglevel for organization's peer                                                            | debug                         |
| tlsstatus     | Provide the value for tlsstatus to be true or false for organization's peer                             | true                          |

### Vault

| Name                 | Description                                                                 | Default Value                |
| ---------------------| ----------------------------------------------------------------------------| -----------------------------|
| role                 | Provide the vaultrole for an organization                                   | vault-role                   |
| address              | Provide the vault server address                                            | ""                           |
| authpath             | Provide the kubernetes auth backed configured in vault for an organization  | devorg1-net-auth |
| adminsecretprefix    | Provide the value for vault secretprefix                                   | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin                     |
| orderersecretprefix  | Provide the value for vault secretprefix                                    | secretsv2/data/data/crypto/peerOrganizations/org1-nets/orderer                     |
| serviceaccountname   | Provide the serviceaccount name for vault                                   | vault-auth                   |
| type        | Provide the type of vault    | hashicorp    |
| imagesecretname      | Provide the imagesecretname for vault                                       | ""                           |
| tls                  | Enable or disable TLS for vault communication                               | ""                           |

### Channel

| Name      | Description                          | Default Value |
| ----------| -------------------------------------|---------------|
| name      | Provide the name of the channel      | mychannel     |

### orderer

| Name       | Description                        | Default Value              |
| -----------| -----------------------------------|----------------------------|
| address    | Provide the address for orderer    | orderer1.org1proxy.blockchaincloudpoc.com:443   |

### anchorstx

| Name           | Description                                              | Default Value |
| ---------------| ---------------------------------------------------------| ------------- |
| anchorstx      | Provide the base64 encoded file contents for anchorstx   | ""            |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-anchorpeer Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-anchorpeer/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-anchorpeer
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-anchorpeer job to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the Job was created. This command will display information about the Job, including the number of completions and the current status of the Job's pods.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-anchorpeer/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-anchorpeer
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-anchorpeer node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Anchor Peer Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-anchorpeer), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
