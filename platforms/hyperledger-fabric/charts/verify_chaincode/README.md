[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "verify-chaincode-hyperledger-fabric-deployment"></a>
# Verify Chaincode Hyperledger Fabric Deployment

- [Verify Chaincode Hyperledger Fabric Deployment Helm Chart](#verify-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "verify-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## Verify Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/verify_chaincode) to Verify a chaincode.


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
verify_chaincode/
  |- templates/
      |- _helpers.yaml
      |- verify_chaincode.yaml   
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `verify_chaincode.yaml`: The certificates-init container retrieves TLS certificates and secrets from Vault, storing them within the pod. The verifychaincode container interacts with the Hyperledger Fabric blockchain, invoking specified chaincode, utilizing the retrieved certificates and necessary configurations for communication and endorsement.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/verify_chaincode/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                                               | Default                           |
|-----------------------|---------------------------------------------------------------------------|-----------------------------------|
| namespace             | Provide the namespace for the organization's peer                         | org1-example-com                           |
| images.fabrictools    | Valid image name and version for fabric tools                             | hyperledger/fabric-tools:2.2.2    |
| images.alpineutils    | Valid image name and version to read certificates from the vault server   | index.docker.io/hyperledgerlabs/alpine-utils:1.0  |
| labels                | Custom labels                                                             | ""                                |

### Peer

| Name          | Description                                          | Default    |
|---------------| -----------------------------------------------------|------------|
| name          | Provide the name of the peer                         | peer0      |
| address       | Address of the peer who creates the channel          | ""         |
| localmspid    | Provide the local MSPID for the organization         | Org1MSP    |
| loglevel      | Provide the log level for the organization's peer    | info       |
| tlsstatus     | Provide the value for TLS status for the peer        | true       |

### Vault

| Name                  | Description                                         | Default                       |
|-----------------------| ----------------------------------------------------|-------------------------------|
| role                  | Vault role for the organization                     | vault-role                    |
| address               | Vault server address                                | ""                            |
| authpath              | Kubernetes auth backend configured in vault         | fra-demo-hlkube-cluster-org1  |
| adminsecretprefix     | Provide the value for vault admin secret prefix     | secret/adminsecretprefix/     |
| orderersecretprefix   | Provide the value for vault orderer secret prefix   | secret/orderersecretprefix/   |
| serviceaccountname    | Provide the service account name for vault          | vault-auth                    |
| imagesecretname       | Provide the image secret name for vault             | ""                            |
| tls                   | Enable or disable TLS for vault communication       | vaultca                       |

### Orderer

| Name       | Description                              | Default   |
|------------|------------------------------------------|-----------|
| address    | Provide the address for the orderer      | ""        |

### Chaincode

| Name                  | Description                                               | Default                           |
|-----------------------|---------------------------------------------------------- |-----------------------------------|
| builder               | Valid chaincode builder image for Fabric                  | hyperledger/fabric-ccenv:1.4.8    |
| name                  | Provide the name of the chaincode to be upgraded          | cc                                |
| version               | Provide the chaincode version to be upgraded              | "1.0"                             |
| upgradearguments      | Provide the upgrade arguments for the chaincode           | ""                                |
| endorsementpolicies   | Provide the endorsement policies for the chaincode        | ""                                |

### Channel

| Name       | Description                        | Default     |
|------------| -----------------------------------|-------------|
| name       | Provide the name of the channel    | mychannel   |


<a name = "deployment"></a>
## Deployment
---

To deploy the verify_chaincode Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/verify_chaincode/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./verify_chaincode
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the verify_chaincode node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/verify_chaincode/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./verify_chaincode
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the verify_chaincode node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Verify Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/verify_chaincode), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
