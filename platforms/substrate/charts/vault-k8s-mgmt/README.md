# vault-k8s-mgmt

This helm chart generates the necessary configurations to enable access from Kubernetes to Hashicorp Vault for Hyperledger Bevel.

## Introduction

Hyperledger Bevel uses Hashicorp Vault to store all secrets and certificates. There are a few configurations needed so that Kubernetes can access Vault over the network, this helm chart creates all those configurations and thus needs the Vault roottoken as a secret in Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Hashicorp Vault server with access to store the Genesis
- Kubernetes Secret `roottoken` which has Vault's roottoken in the same namespace

## Installing the Chart

To install the chart with the release name `my-release`, first create a `helm-override.yaml` file with the keys and account details. The file may look like this:
```yaml
vault:
  address: http://localhost:8200
  authpath: myauthpath
  policy: vault-crypto-substrate-ro
  policydata: "{\n  \"policy\": \"path \\\"secretsv2/data/substrate/*\\\" {\n    capabilities = [\\\"read\\\", \\\"list\\\", \\\"create\\\", \\\"update\\\"]\n  }\n  path \\\"secretsv2/data/substrate/smartContracts/*\\\" {\n    capabilities = [\\\"read\\\", \\\"list\\\"]\n  }\"\n}"
k8s:
  kubernetes_url: "https://10.3.8.5:8443"
  
```
Other default values from `values.yaml` can also be overriden in the above file.

```console
$ helm repo add bevel https://digicatapult.github.io/helm-charts
$ helm install -f helm-override.yaml my-release bevel/vault-k8s-mgmt
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
| `matadata.name`       | The name of the job                                | `substrate`            |
| `matadata.labels`       | Any additional labes for the job                 | `""`            |
| `matadata.images.alpineutils`       | The utils image that will generate the configurations                | `ghcr.io/hyperledger/alpine-utils:1.0`            |

### Vault Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `vault.address`          | URL of the Vault server                          | `""` |
| `vault.role`          | The Vault role which will access the server                          | `vault-role` |
| `vault.reviewer_service`          | The reviewer service account on Kubernetes               | `vault-reviewer` |
| `vault.authpath`          | The Auth Path that will be configured on Hashicorp Vault                          | `substrate` |
| `vault.serviceaccountname`          | The service account that will be authenticated with Hashicorp Vault                     | `vault-auth` |
| `vault.policy`          | The Vault policy name that will be created                     | `vault-crypto-substrate-ro` |
| `vault.policydata`          | The Vault policy data json that will be created                     | `"{\n  \"policy\": \"path \\\"secretsv2/data/substrate/*\\\" {\n    capabilities = [\\\"read\\\", \\\"list\\\", \\\"create\\\", \\\"update\\\"]\n  }\n  path \\\"secretsv2/data/substrate/smartContracts/*\\\" {\n    capabilities = [\\\"read\\\", \\\"list\\\"]\n  }\"\n}"` |
| `vault.secret_path`          | The secret path that has been created on Vault                 | `secretsv2` |
| `vault.imagesecretname`          | The docker/container secret if it is a private image           | `""` |
| `vault.tls`          | If Vault is running as https, this should be the Kubernetes secret which contains the ca cert        | `""` |

### Kubernetes Parameters

| Name                        | Description                                                                               | Default Value  |
| --------------------------- | ----------------------------------------------------------------------------------------- | ------ |
| `k8s.kubernetes_url`          | The URL of the Kubernetes server         | `""` |



## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture
