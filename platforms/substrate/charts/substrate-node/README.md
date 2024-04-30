[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# substrate-node
This Helm chart deploys the nodes to initiate the Substrate network.

## TL;DR

```console
$ helm repo add bevel https://hyperledger.github.io/bevel
$ helm install Validator-1 bevel/substrate-node
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
helm install Validator-1 bevel/substrate-node
```

This command deploys the chart onto the Kubernetes cluster using default configurations. Refer to the [Parameters](#parameters) section for customizable options.

> **Tip**: Utilize `helm list` to list all releases.

### Uninstallation

To remove the `Validator-1` deployment, use:

```bash
helm uninstall Validator-1
```

This command eliminates all Kubernetes components associated with the chart and deletes the release.

## Parameters

#### Global Parameters
These parameters remain consistent across parent or child charts.

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `global.serviceAccountName` | Name of the service account for Vault Auth and Kubernetes Secret management | `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider (e.g., AWS EKS, minikube). Currently tested with `aws` and `minikube`. | `aws` |
| `global.cluster.cloudNativeServices` | Future implementation for utilizing Cloud Native Services (`true` for SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure). | `false`  |
| `global.cluster.kubernetesUrl` | URL of the Kubernetes Cluster  | `""`  |
| `global.vault.type`  | Vault type support for other providers. Currently supports `hashicorp` and `kubernetes`. | `hashicorp` |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role` |
| `global.vault.network`  | Deployed network type | `substrate` |
| `global.vault.address`| URL of the Vault server.    | `""` |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain` |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2` |
| `global.vault.secretPrefix` | Vault secret prefix; must start with `data/`   | `data/supplychain` |

### Common parameters

| Parameter           | Description                                  | Default                        |
|---------------------|----------------------------------------------|--------------------------------|
| `nameOverride`      | String to partially override node.fullname   | `nil`                          |
| `fullnameOverride`  | String to fully override node.fullname       | `nil`                          |
| `imagePullSecrets`  | Labels to add to all deployed objects        | `[]`                           |
| `podAnnotations`    | Annotations to add to pods                   | `{}` (evaluated as a template) |
| `nodeSelector`      | Node labels for pod assignment               | `{}` (evaluated as a template) |
| `tolerations`       | Tolerations for pod assignment               | `[]` (evaluated as a template) |
| `affinity`          | Affinity for pod assignment                  | `{}` (evaluated as a template) |
| `storaceClass`      | The storage class to use for volumes         | `default`                      |

### Node parameters

| Parameter | Description | Default |
| - | - | - |
| `node.chain` | Network to connect the node to (ie `--chain`) | `polkadot` |
| `node.command` | Command to be invoked to launch the node binary | `polkadot` |
| `node.isBootnode` | Set to false to start the first node as a Bootnode. Set to true for subsequent nodes to connect to an existing Bootnode | `false` |
| `node.bootnodeName` | Name of the Bootnode deployed | `` |
| `node.bootnodeAddr` | Address to access the Bootnode | `` |
| `node.bootnodePort` | Port for communication with other peers/nodes | `30333` |
| `node.flags` | Node flags other than `--name` (set from the helm release name), `--base-path` and `--chain` (both set with `node.chain`) | `--prometheus-external --rpc-external --ws-external --rpc-cors all` |
| `node.keys` | The list of keys to inject on the node before startup (object{ type, scheme, seed }) | `{}` |
| `node.persistGeneratedNodeKey` | Persist the auto-generated node key inside the data volume (at /data/node-key) | `false` |
| `node.customNodeKey` | Use a custom node-key, if `node.persistGeneratedNodeKey` is true then this will not be used.  (Must be 64 byte hex key) | `nil` |
| `node.enableStartupProbe` | If true, enable the startup probe check | `true` |
| `node.enableReadinessProbe` | If true, enable the readiness probe check | `true` |
| `node.dataVolumeSize` | The size of the chain data PersistentVolume | `100Gi` |
| `node.replica` | Number of replica in the node StatefulSet | `1` |
| `node.role` | Set the role of the node: `full`, `authority`/`validator`, `collator` or `light` | `full` |
| `node.chainDataSnapshotUrl` | Download and load chain data from a snapshot archive http URL | `` |
| `node.chainDataSnapshotFormat` | The snapshot archive format (`tar` or `7z`) | `tar` |
| `node.chainDataGcsBucketUrl` | Sync chain data files from a GCS bucket (eg. `gs://bucket-name/folder-name`) | `` |
| `node.chainPath` | Path at which the chain database files are located (`/data/chains/${CHAIN_PATH}`) | `nil` (if undefined, fallbacks to the value in `node.chain`) |
| `node.chainDataKubernetesVolumeSnapshot` | Initialize the chain data volume from a Kubernetes VolumeSnapshot | `` |
| `node.customChainspecUrl` | Download and use a custom chainspec file from a URL | `nil` |
| `node.collator.isParachain` | If true, configure the node as a parachain (set the relay-chain flags after `--`) | `nil` |
| `node.collator.relayChainCustomChainspecUrl` | Download and use a custom relay-chain chainspec file from a URL | `nil` |
| `node.collator.relayChainDataSnapshotUrl` | Download and load relay-chain data from a snapshot archive http URL | `nil` |
| `node.collator.relayChainDataSnapshotFormat` | The relay-chain snapshot archive format (`tar` or `7z`) | `nil` |
| `node.collator.relayChainPath` | Path at which the chain database files are located (`/data/polkadot/chains/${RELAY_CHAIN_PATH}`) | `nil` |
| `node.collator.relayChainDataKubernetesVolumeSnapshot` | Initialize the relay-chain data volume from a Kubernetes VolumeSnapshot | `nil` |
| `node.collator.relayChainDataGcsBucketUrl` | Sync relay-chain data files from a GCS bucket (eg. `gs://bucket-name/folder-name`) | `nil` |
| `node.collator.relayChainFlags` | Relay-chain node flags other than `--name` (set from the helm release name), `--base-path` and `--chain` | `nil` |
| `node.resources.limits` | The resources limits (cpu/memory) for nodes | `{}` |
| `node.podManagementPolicy` | The pod management policy to apply to the StatefulSet, set it to `Parallel` to launch or terminate all Pods in parallel, and not to wait for pods to become Running and Ready or completely terminated prior to launching or terminating another pod | `{}` |
| `node.resources.requests` | The resources requests (cpu/memory) for nodes | `{}` |
| `node.serviceMonitor.enabled` | If true, creates a Prometheus Operator ServiceMonitor | `false` |
| `node.serviceMonitor.namespace` | Prometheus namespace | `nil` |
| `node.serviceMonitor.internal` | Prometheus scrape interval | `nil` |
| `node.serviceMonitor.scrapeTimeout` | Prometheus scrape timeout | `nil` |
| `node.tracing.enabled` | If true, creates a jaeger agent sidecar | `false` |
| `node.subtrateApiSiecar.enabled` | If true, creates a substrate api sidecar | `false` |
| `node.perNodeServices.createApiService` | If true creates a clusterIP API service | `true` |
| `node.perNodeServices.createP2pService` | If true creates a p2p NodePort service, if `node.collator.isParachain` also true, creates a NodePort p2p service for the parachain | `false` |
| `node.perNodeServices.relayServiceAnnotations` | Annotations to be inserted into the relay chain service | `{}` |
| `node.perNodeServices.paraServiceAnnotations` | Annotations to be inserted into the para chain service | `{}` |
| `node.perNodeServices.setPublicAddressToExternal.enabled` | If true sets the `--public-addr` flag to be the NodePort p2p services external address | `false` |
| `node.perNodeServices.setPublicAddressToExternal.ipRetrievalServiceUrl` | The external service to return the NodePort IP | `https://ifconfig.io` |

### Other parameters

| Parameter                          | Description                                                                                            | Default             |
|------------------------------------|--------------------------------------------------------------------------------------------------------|---------------------|
| `image.repository`                 | Node image name                                                                                        | `parity/polkadot`   |
| `image.tag`                        | Node image tag                                                                                         | `latest`            |
| `image.pullPolicy`                 | Node image pull policy                                                                                 | `Always`            |
| `initContainer.image.repository`   | Download-chain-snapshot init container image name                                                      | `crazymax/7zip`     |
| `initContainer.image.tag`          | Download-chain-snapshot init container image tag                                                       | `latest`            |
| `googleCloudSdk.image.repository`  | Sync-chain-gcs init container image name                                                               | `google/cloud-sdk`  |
| `googleCloudSdk.image.tag`         | Sync-chain-gcs init container image tag                                                                | `slim`              |
| `googleCloudSdk.serviceAccountKey` | Service account key (JSON) to inject into the Sync-chain-gcs init container using a Kubernetes secret  | `nil`               |
| `ingress.enabled`                  | If true, creates an ingress                                                                            | `false`             |
| `ingress.annotations`              | Annotations to add to the ingress (key/value pairs)                                                    | `{}`                |
| `ingress.rules`                    | Set rules on the ingress                                                                               | `[]`                |
| `ingress.tls`                      | Set TLS configuration on the ingress                                                                   | `[]`                |
| `podSecurityContext`               | Set the pod security context for the substrate node container                                          | `{ runAsUser: 1000, runAsGroup: 1000, fsGroup: 1000 }`|
| `jaegerAgent.image.repository`     | Jaeger agent image repository                                                                          | `jaegertracing/jaeger-agent` |
| `jaegerAgent.image.tag`            | Jaeger agent image tag                                                                                 | `1.28.0`            |
| `jaegerAgent.ports.compactPort`    | Port to use for jaeger.thrift over compact thrift protocol                                             | `6831`              |
| `jaegerAgent.ports.binaryPort`     | Port to use for jaeger.thrift over binary thrift protocol                                              | `6832`              |
| `jaegerAgent.ports.samplingPort`   | Port for HTTP sampling strategies                                                                      | `5778`              |
| `jaegerAgent.collector.url`        | The URL which jaeger agent sends data                                                                  | `nil`               |
| `jaegerAgent.collector.port   `    | The port which jaeger agent sends data                                                                 | `14250`             |    
| `extraContainers   `               | Sidecar containers to add to the node                                                                  | `[]`                |   

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
