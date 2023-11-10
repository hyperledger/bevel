# substrate-genesis

This helm chart generates genesis file for substrate based node and stores into Hashicorp Vault. Currently, only Hashicorp Vault as secure storage is supported, other Secret managers will be added in due course. This chart has been updated to be used with DSCP (Digital-Supply-Chain-Platform) example provided in Hyperledger Bevel. And, so, it needs the aura keys, grandpa keys and the list of members to be passed as parameters

## TL;DR

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install -f helm-override.yaml my-release bevel/substrate-genesis
```

## Introduction

This chart generates a Genesis file for a [dscp-node](https://github.com/inteli-poc/dscp-node/) network on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Hashicorp Vault server with access to store the Genesis
- Aura Keys, Grandpa Keys and Account details of the members

## Installing the Chart

To install the chart with the release name `my-release`, first create a `helm-override.yaml` file with the keys and account details. The file may look like this:
```yaml
aura_keys: 
- '5DyCUqDTSgTXcL1B7i7KMBcVBvGdtxXLXZ6uEi5Ktekj5tQF'
- '5GBbtj2twDjJfncE6RtLibzjezH8xghRoRD1dDbZFxsKQjuk'
- '5EPPujEsETrqJ8v87EwJgLjt2K9RJBkJ7cduVQwUZdPiJ6TX'
- '5H19343NxLc5ssgUCbX5Mgwadk4XfaTrup2Qg37L3GtqQcE1'
grandpa_keys: 
- '5EtJgUviLmr1RCNhb7jttY6bX5VUHneL6Uyno6rLyGtawGzA'
- '5FwRY6PZ1fkyJUcKgVN5Pv6hzzPZZ31A49UuSXjmciL36LH1'
- '5Hqun9H3ugvht2ukj1KdRqV2Pr8ydu6Vs4VKAQHCpfcXf2gN'
- '5FGuiafBZY5MrBUBUfcxeSsG7iQvzNEp2feXtrhnZqAv31cj'
members: 
  - account_id: 5D5c66mYy5B2RVKPfXyCcNqvQ4QHpB5SnTEEXGJ9fEvTu12S
    balance: 1152921504606846976
    nodes:
    - 0024080112204D4DD3B677A3ECF61E926F3E0C7B0F61099D358BDC975700FA9F0881495C6CFB
    - 0024080112201EC4AA69077A06D19ACBCA81FD6990CB93748487A53BEC76B4224815F2FADE20
    - 002408011220BAA87C06CAE76D1FA0DE072E37101897016E372D7F9EDFFC0DA8D262AC930F17
    - 00240801122070BC9485475DEDA36CD4F2A12A4BAD9BF1F751AD67A78C5469E5619619A9EB92
    - 0024080112200B8299C0EA87D40F12A2B94CACAB9EED4B6C6C9F79DCB777DB47DE361C03DB5F
  - account_id: 5EnHWK7eNuFa5K4U4Z74W3yqXp5NEy1mMCmuYvzcQdPxuTmd
    balance: 1152921504606846976
    nodes:
    - 002408011220E4CE21100FACA40C75A332566E48108D2188A86D6E501D6D0B8A6F02AC836955
    - 0024080112208D7E157C0EF197453A7F2A645816AF0C9159167C65D4B224AA39366E870ABB65
    - 0024080112207C660839F1380F035B918F354B58BAC7401E279F76A02F7F69513A6FDD399CFF
  - account_id: 5FnA4xy1yYigBLEYMFxyHy7N3DM1s3iE8USKzKShLvohq8rd
    balance: 1152921504606846976
    nodes:
    - 0024080112204846FBE5A8F5A0FECC569EBEBD6A6F360AAABEC5EE8F782259DEC44B8652C714

```
Other default values from `values.yaml` can also be overriden in the above file.

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install -f helm-override.yaml my-release bevel/substrate-genesis
```

The [Parameters](#parameters) section lists the parameters that can be configured during installation.

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
| `matadata.namespace`       | The namespace where this job will be deployed                                        | `default`            |
| `matadata.name`       | The name of the job                                | `substrate-genesis-job`            |

### Genesis image config parameters

| Name                                              | Description                                                                                                                                          | Default Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `node.image`                                | The dscp-node or substrate image repository                                                                                                                 | `ghcr.io/inteli-poc/dscp-node` |
| `node.imageTag`                                       | The dscp-node or substrate image tag                               | `v4.3.1`                |
| `node.pullPolicy`                                | dscp-node image pull policy                                                                                                                          | `IfNotPresent`           |
| `node.command`         | The binary that will be executed to generate the genesis (this corresponds to the node.image)             | `./dscp-node`   |

### Vault Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `vault.address`          | URL of the Vault server                          | `""` |
| `vault.role`          | The Vault role which will access the server                          | `vault-role` |
| `vault.authpath`          | The Auth Path configured on Hashicorp Vault                          | `""` |
| `vault.serviceAccountName`          | The service account that has been authenticated with Hashicorp Vault                     | `vault-auth` |
| `vault.certSecretPrefix`          | The path where certificates are stored                     | `""` |

### DSCP-Node/Substrate Account Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `chain`          | The name of the chain which is embedded in the genesis               | `inteli` |
| `aura_keys`          | List of aura keys that will be added to the genesis               | `[]` |
| `grandpa_keys`          | List of grandpa keys that will be added to the genesis               | `[]` |
| `members`          | List of members with these attributes: `account_id`, `balance` and `nodes` list.               | `[]` |



## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture
