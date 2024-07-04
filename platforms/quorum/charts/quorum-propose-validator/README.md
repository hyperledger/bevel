[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# goquorum-propose-validator

This chart is a component of Hyperledger Bevel. The goquorum-propose-validator chart injects a new authorization candidate that the validator attempts to push through. If a majority of the validators vote the candidate in/out, the candidate is added/removed in the validator set.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install propose-validator bevel/goquorum-propose-validator
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `propose-validator`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install propose-validator bevel/goquorum-propose-validator
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `propose-validator` deployment:

```bash
helm uninstall propose-validator
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.genesisUtils.repository`  | Quorum hooks image repository  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.genesisUtils.tag`  | Quorum hooks image tag  | `qgt-0.2.12` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""` |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent` |

### validators

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `validators.auth` | Set to 'true' to vote the candidate in and 'false' to vote them out | `true` |
| `validators.authorizedValidatorsURL` | URLs of already authorized validators | `""` |
| `validators.nonAuthorizedValidatorsNodeAddress` | Node addresses of the validators that need to be proposed | `""` |


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
