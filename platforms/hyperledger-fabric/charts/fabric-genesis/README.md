[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-genesis

This chart is a component of Hyperledger Bevel. The fabric-genesis chart createsthe genesis file for fabric network. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/fabric-genesis
```

## Prerequisitess

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `genesis`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/fabric-genesis
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `genesis` deployment:

```bash
helm uninstall genesis
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

These parameters are refered to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `fabric`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `haproxy` | `ambassador` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Besu P2P and RPC service will be available | `test.blockchaincloudpoc.com` |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.ca`    | Provide the image name for the generate-geneis container  | `ghcr.io/hyperledger/bevel-fabric-ca:latest`            |
| `image.alpineUtils`    | Provide the docker secret name in the namespace  | `Provide the valid image name and version to read certificates from vault server`       |
| `image.pullSecret`    | Provide the docker secret name in the namespace  | `""`            |

### Network

| Name   | Description    | Default Value   |
| `network.version`       | HyperLedger Fabric network version               | 2.5.4            |

### Consensus

| Name     | Description                 | Default Value   |
| ---------| ----------------------------| ----------------|
| `consensus.name`        | Name of the consensus          | raft            |

### Organizations

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `organization.name` | Provide the organization's name| `""` |
| `organization.type`| Provide the organization's type (orderer or peer)   | `""` |
| `organization.orderers` | Provide a list of the organization's orderer nodes. This list presents two fields `orderer.name` and `orderer.ordererAddress`  | `""`  |
| `organization.peers` | Provide a list of the organization's peer nodes. This list presents two fields `peer.name` and `peer.peerAddress`  | `""`  |

### Channels

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `channel.channel_name` | Provide the channel's name| `"Allchannel"` |
| `channel.consortium`| Provide the channel's consortium   | `SupplyChainConsortium` |
| `channel.orderers` | Provide a list of orderer type organizations on the network  | `""`  |
| `channel.participants` | provides a list of participating channel organizations. This list presents one field `organization.name` | `""`  |
| `channel.genesis` | Provide the profile name of the genesis file`  | `OrdererGenesis`  |

### Vars

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `vars.install_os`  | Provide the OS            | `"linux"` |
| `vars.install_arch`| Provide the architecture  | `amd64` |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `settings.removeGenesisOnDelete` |  Setting to delete the genesis secret when uninstalling the release | `true` |
| `settings.removeGenesisConfigMapOnDelete` | Setting to delete the genesis configmaps when uninstalling the release  | `true` |

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
