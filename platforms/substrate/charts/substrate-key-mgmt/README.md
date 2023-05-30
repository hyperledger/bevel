# substrate-key-mgmt

This helm chart generates the required keys for a substrate based node and stores into Hashicorp Vault. Currently, only Hashicorp Vault is supported, other Secret managers will be added in due course.


## Introduction

This chart generates node key, aura key, grandpa key, and account key (for member nodes) for a [dscp-node](https://github.com/inteli-poc/dscp-node/) network on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager. The DSCP-Node can be replaced by any Substrate based node by updating the `node.image` and `node.command` parameters in the `values.yaml`.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Hashicorp Vault server with access to store the generated Keys

## Installing the Chart

To install the chart with the release name `my-release`, first create a `helm-override.yaml` file with the keys and account details. The file may look like this:
```yaml
node:
  type: member
vault:
  address: http://localhost:8200
  authpath: myauthpath
  certSecretPrefix: secrets/mysecrets

```
Other default values from `values.yaml` can also be overriden in the above file.

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install -f helm-override.yaml my-release bevel/substrate-key-mgmt
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
| `matadata.name`       | The name of the job                                | `substrate-keys-job`            |

### Substrate image config parameters

| Name                                              | Description                                                                                                                                          | Default Value                    |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `node.name`                                | Name of the  member/validator node (this will be included in the Vault Path)                                                                                                       | `substrate` |
| `node.image`                                | The dscp-node or substrate image repository                                                                                                                 | `ghcr.io/inteli-poc/dscp-node:v4.3.1` |
| `node.pullPolicy`                                | dscp-node image pull policy                                                                                                                          | `IfNotPresent`           |
| `node.command`         | The binary that will be executed to generate the genesis (this corresponds to the node.image)             | `./dscp-node`   |
| `node.type`         | The type of node. Allowed values are bootnode, member, validator. Only member type will generate account keys             | `validator`   |

### Vault Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `vault.address`          | URL of the Vault server                          | `""` |
| `vault.role`          | The Vault role which will access the server                          | `vault-role` |
| `vault.authpath`          | The Auth Path configured on Hashicorp Vault                          | `""` |
| `vault.serviceAccountName`          | The service account that has been authenticated with Hashicorp Vault                     | `vault-auth` |
| `vault.certSecretPrefix`          | The path where certificates are stored                     | `""` |

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture
