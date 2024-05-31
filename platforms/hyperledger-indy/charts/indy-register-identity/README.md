[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# indy-register-identity

This chart is a component of Hyperledger Bevel. The indy-register-identity chart registers a new Identiy for an existing Indy network; it should be executed by a `trustee`. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for more details.

> **Important**: The public key files for the new identity should already be placed in `files` before installing this chart. Check **Prerequisites**.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install endorser-registration bevel/indy-register-identity
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

Before running indy-register-identity, the public key information for the endorser/identity should be saved in the `files` directory. For example, given an endorser called `university-endorser`, run the following commands to save the public key info. 

> **Important**: The [indy-key-mgmt](../indy-key-mgmt/README.md) chart generates these keys, so should be installed with matching endorser name before this chart.

```bash
cd files
# endorser files are in university-ns namespace
endorser_namespace=university-ns
endorser_name=university-endorser
kubectl --namespace $endorser_namespace get secret $endorser_name-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $endorser_name-did.json
kubectl --namespace $endorser_namespace get secret $endorser_name-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $endorser_name-verkey.json

```

## Installing the Chart
To install the chart with the release name `endorser-registration`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install endorser-registration bevel/indy-register-identity
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `endorser-registration` deployment:

```bash
helm uninstall endorser-registration
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters
### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.cli`  | Indy Cli image repository and tag  | `ghcr.io/hyperledger/bevel-indy-ledger-txn:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`network` | Network Name for Indy | `bevel` |
| `admin` | Trustee name who is running the registration, ensure the chart is installed on this trustee namespace | `authority-trustee` |
| `newIdentity.name` | Name of the new identity | `university-endorser` |
| `newIdentity.role` | Role of the new identity | `ENDORSER` |

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2024 Accenture

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
