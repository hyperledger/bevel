# dscp-ipfs

The dscp-ipfs is a component of the DSCP (Digital-Supply-Chain-Platform), a blockchain platform. The dscp-ipfs service is responsible for rotating IPFS swarm keys and storing data, it exposes an IPFS API for this purpose. See [https://github.com/digicatapult/dscp-documentation](https://github.com/digicatapult/dscp-documentation) for details.

## TL;DR

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install my-release bevel/dscp-ipfs-node
```

## Introduction

This chart bootstraps a [dscp-ipfs](https://github.com/inteli-poc/dscp-ipfs/) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install my-release bevel/dscp-ipfs-node
```

The command deploys dscp-ipfs on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                     | Description                                                                             | Default Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |

### IPFS subsystem parameters

| Name                         | Description                                                                                                                                                   | Default Value                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `config.healthCheckPort`                                        | Port for checking the health of the api                                                                                 | `80`                   |
| `config.healthCheckPollPeriod`                           | Health check poll period in milliseconds                                                                                                             | `30000`                  |
| `config.healthCheckTimeout`                              | Health check timeout in milliseconds                                                                                                                 | `2000`                   |
| `config.nodeHost`     | External DSCP-Node hostname to query                                                      | `""`   |
| `config.nodePort`     | External DSCP-Node port to query                                                          | `""`   |
| `config.publicKey`             | Public key for the IPFS subsystem                                                                                                                             | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `config.privateKey`            | Private key for the IPFS subsystem                                                                                                                            | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `config.logLevel`              | logLevel for nodeJS service Allowed values: error, warn, info, debug                                                                                         | `info`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `config.ipfsApiPort`                              | dscp-ipfs IPFS subsystem api container port                                                                                                          | `5001`                   |
| `config.ipfsSwarmPort`                            | dscp-ipfs IPFS subsystem Swarm container port                                                                                                        | `4001`                   |
| `config.ipfsDataPath`     | Path to mount the volume at.                                                                            | `/ipfs`             |
| `config.ipfsCommand`                | Location of the ipfs binary in the container for the IPFS subsystem                                                                                           | `/usr/local/bin/ipfs`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `config.ipfsArgs`           | Arguments to pass to the wasp-ipfs service to spawn the IPFS subsystem                                                                                        | `["daemon","--migrate"]`                                                                                                                                                                                                                                                                                                                                                                                                 |
| `config.ipfsSwarmAddrFilters`      | List of IPFS swarm address filters to apply to the IPFS subsystem                                                                                             | `null` |
| `config.ipfsLogLevel`              | logLevel for IPFS subsystem, Allowed values: error, warn, info, debug                                                                                         | `info`                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `config.ipfsBootNodeAddress`       | IPFS boot node addresses in MultiAddress format for the IPFS subsystem                                                                                        | `""`                                                                                                                                                                                                                                                                                                                                                                                                                     |



### IPFS Service Parameters

| Name                                    | Description                                                                                | Default Value       |
| --------------------------------------- | ------------------------------------------------------------------------------------------ | ----------- |
| `service.swarm.annotations`                          | dscp-ipfs swarm service annotations                                                                     | `{}` |
| `service.swarm.enabled`                    | Enable dscp-ipfs swarm service                                                                | `true`        |
| `service.swarm.port`              | dscp-ipfs swarm service HTTP port                                                          | `4001`      |
| `service.api.annotations`                          | dscp-ipfs api service annotations                                                                     | `{}` |
| `service.api.enabled`                    | Enable dscp-ipfs api service                                                                | `true`        |
| `service.api.port`              | dscp-ipfs api service HTTP port                                                          | `4001`      |
| `statefulSet.annotations`              | dscp-ipfs statefulset annotations                                                | `{}`      |
| `statefulSet.livenessProbe.enabled`              | dscp-ipfs statefulset liveness probe                                                | `true`      |


### IPFS image config parameters

| Name                                              | Description                                                                                                                                          | Default Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `image.repository`                                | dscp-ipfs image repository                                                                                                                 | `ghcr.io/inteli-poc/dscp-ipfs` |
| `image.tag`                                       | dscp-ipfs image tag (immutable tags are recommended)                                                                                                 | `v2.6.2`                |
| `image.pullPolicy`                                | dscp-ipfs image pull policy                                                                                                                          | `IfNotPresent`           |
| `initContainer.image`         | alpine-utils container image                                                  | `ghcr.io/hyperledger/alpine-utils:1.0`   |
| `initContainer.pullPolicy`                   | alpine-utils container image pull policy                                   | `IfNotPresent` |

### Persistence Parameters

| Name                        | Description                                                                                             | Default Value               |
| --------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------- |
| `storage.storageClass`  | Storage class of backing PVC                                                                            | `""`                |
| `storage.dataVolumeSize`          | Size of data volume                                                                                     | `1Gi`               |


### DSCP-Node Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `dscpNode.enabled`          | Enable DSCP-Node subchart                                                                 | `false` |

### Proxy Service Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `proxy.provider`          | The type of proxy provider                          | `ambassador` |
| `proxy.external_url`          | External URL where the DSCP swarm service will be exposed                          | `""` |
| `proxy.port`          | External PORT where the DSCP swarm service will be exposed                          | `15010` |
| `proxy.certSecret`          | Kubernetes secret which stores the CA certificate for the proxy                          | `""` |


### Vault Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `vault.provider`          | The type of secret manager to be used                           | `hashicorp` |
| `vault.address`          | URL of the Vault server                          | `""` |
| `vault.role`          | The Vault role which will access the server                          | `vault-role` |
| `vault.authpath`          | The Auth Path configured on Hashicorp Vault                          | `""` |
| `vault.serviceAccountName`          | The service account that has been authenticated with Hashicorp Vault                     | `vault-auth` |
| `vault.certSecretPrefix`          | The path where certificates are stored                     | `""` |


## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture

### Attribution

This chart is adapted from the [charts](https://github.com/digicatapult/helm-charts/) provided by [DigitalCatapult](https://www.digicatapult.org.uk/) which are licensed under the Apache v2.0 License which is reproduced here:

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
