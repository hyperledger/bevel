[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "fabric-cli-hyperledger-fabric-deployment"></a>
# Fabric Cli Hyperledger Fabric Deployment

- [Fabric Cli Hyperledger Fabric Deployment Helm Chart](#fabric-cli-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "fabric-cli-hyperledger-fabric-deployment-helm-chart"></a>
## Fabric Cli Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-cli) for Fabric Cli.


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
fabric-cli/
  |- templates/
      |- _helpers.yaml
      |- deployment.yaml
      |- volume.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `deployment.yaml`: The certificates-init retrieves TLS certificates and cryptographic materials from HashiCorp Vault, ensuring secure communication. The cli runs Hyperledger Fabric CLI tools, using the fetched certificates for secure interaction with the network.
- `volume.yaml`: Requests storage resources for the cli container
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-cli/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                                           | Default Value                                     |
| ----------------------| ----------------------------------------------------------------------| --------------------------------------------------|
| namespace             | Namespace for organization's peer deployment                          | org1-net                                         |
| images.fabrictools    | Valid image name and version for fabric tools                         |ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                    |
| images.alpineutils    | Valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-alpine:latest           |

### Storage

| Name        | Description           | Default Value  |
| ------------| ----------------------| ---------------|
| class       | Storage class name    | aws-storageclass      |
| size        | Storage size          | 256Mi          |

### Vault 

| Name                  | Description                                                       | Default Value                  |
| ----------------------| ------------------------------------------------------------------| -------------------------------|
| role                  | Vault role for the organization                                   | vault-role                     |
| address               | Vault server address                                              | ""                             |
| authpath              | Kubernetes auth backend configured in Vault for the organization  | devorg1-net-auth   |
| adminsecretprefix     | Vault secret prefix for admin                                     | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin      |
| orderersecretprefix   | Vault secret prefix for orderer                                   | secretsv2/data/crypto/peerOrganizations/org1-net/orderer    |
| serviceaccountname    | Service account name for Vault                                    | vault-auth                     |
| type                  | Provide the type of vault                                         | hashicorp    |
| imagesecretname       | Image secret name for Vault                                       | ""                             |
| tls                   | TLS status for Vault communication                                | ""                             |

### Peer Configuration

| Name          | Description                                 | Default Value                |
| --------------| --------------------------------------------| -----------------------------|
| name          | Name of the peer as per deployment YAML     | peer0                        |
| localmspid    | Local MSP ID for the organization's peer    | Org1MSP                      |
| tlsstatus     | TLS status for the organization's peer      | true                         |
| address       | Address for the peer                        | peer0.org1-net:7051 |

### Orderer Configuration

| Name        | Description              | Default Value                |
| ------------| -------------------------| -----------------------------|
| address     | Address for the orderer  | orderer1.org1proxy.blockchaincloudpoc.com:443  |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-cli Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-cli/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-cli
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-cli node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-cli/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-cli
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-cli node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Fabric Cli Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-cli), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
