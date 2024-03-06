[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)


# quorum-genesis

This Helm chart is a component of Hyperledger Bevel, designed to facilitate the creation of the genesis file for a quorum network. If enabled, the cryptographic keys are securely stored on the configured vault and managed as Kubernetes secrets. Refer to the [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for comprehensive details.

### TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/quorum-genesis
```

### Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If HashiCorp Vault is utilized, ensure:
- HashiCorp Vault Server 1.13.1+

> **Note**: Verify the dependent charts for additional prerequisites.

### Installation

To install the chart with the release name `genesis`, execute:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/quorum-genesis
```

This command deploys the chart onto the Kubernetes cluster using default configurations. Refer to the [Parameters](#parameters) section for customizable options.

> **Tip**: Utilize `helm list` to list all releases.

### Uninstallation

To remove the `genesis` deployment, use:

```bash
helm uninstall genesis
```

This command eliminates all Kubernetes components associated with the chart and deletes the release.

### Parameters

#### Global Parameters
These parameters remain consistent across parent or child charts.

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `global.serviceAccountName` | Name of the service account for Vault Auth and Kubernetes Secret management | `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider (e.g., AWS EKS, minikube). Currently tested with `aws` and `minikube`. | `aws` |
| `global.cluster.cloudNativeServices` | Future implementation for utilizing Cloud Native Services (`true` for SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure). | `false`  |
| `global.cluster.kubernetesUrl` | URL of the Kubernetes Cluster  | `""`  |
| `global.vault.type`  | Vault type support for other providers. Currently supports `hashicorp` and `kubernetes`. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Deployed network type | `besu`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix; must start with `data/`   | `data/supplychain`  |

#### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.repository`  | Repository of the Quorum/Besu hooks image  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.tag`  | Tag of the Quorum/Besu hooks image  | `qgt-0.2.12` |
| `image.pullSecret`    | Docker secret name in the namespace  | `""`            |
| `image.pullPolicy`  | Pull policy for Docker images    | `IfNotPresent`    |

#### TLS

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`settings.removeGenesisOnDelete` | Deletes genesis configmaps when uninstalling the release | `true` |
| `settings.secondaryGenesis` | Set to true to skip network initialization from scratch. Useful for deploying additional nodes, possibly in another namespace. Set to false to start the network from scratch.  | `false` |

#### Genesis Config

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `rawGenesisConfig.genesis.config.chainId` | Chain Id of the Besu network  | `1337` |
| `rawGenesisConfig.genesis.config.algorithm.consensus`   | Consensus mechanism of the Besu network: `ibft2`, `qbft`, `clique` | `qbft`         |
| `rawGenesisConfig.genesis.config.algorithm.blockperiodseconds` | Block period in seconds   | `10`    |
| `rawGenesisConfig.genesis.config.algorithm.epochlength`   | Epoch length  | `30000` |
| `rawGenesisConfig.genesis.config.algorithm.requesttimeoutseconds` | Request timeout in seconds  | `20` |
| `rawGenesisConfig.genesis.gasLimit`   | Gas limit for each transaction | `'0xf7b760'`         |
| `rawGenesisConfig.genesis.difficulty` | Difficulty setting  | `'0x1'`         |
| `rawGenesisConfig.genesis.coinbase`   | Coinbase setting | `'0x0000000000000000000000000000000000000000'`         |
| `rawGenesisConfig.genesis.includeQuickStartAccounts`   | Include default accounts flag | `false`         |
| `rawGenesisConfig.blockchain.nodes.generate` | Flag to generate initial nodes as per the specified `count`   | `true`    |
| `rawGenesisConfig.blockchain.nodes.count`   | Number of validators. | `4` |
| `rawGenesisConfig.blockchain.accountPassword` | Default password for new accounts   | `'password'`    |

## License

This chart is licensed under the Apache v2.0 license.

© 2023 Accenture

### Attribution

This chart is adapted from the [charts](https://hyperledger.github.io/bevel/), licensed under the Apache v2.0 License:

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
