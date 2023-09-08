[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "ca-tools-hyperledger-fabric-deployment"></a>
# CA Tools Hyperledger Fabric Deployment

- [CA Tools Hyperledger Fabric Deployment Helm Chart](#ca-tools-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "ca-tools-hyperledger-fabric-deployment-helm-chart"></a>
## CA Tools Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/catools) to deploy Fabric CA tools.


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
catools/
  |- templates/
      |- _helpers.yaml
      |- configmap.yaml
      |- deployment.yaml
      |- volume.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Contains definitions for six different configmaps. These configmaps will be used by the main and store-vault containers through volume mounting to support their respective tasks.
- `deployment.yaml`: The init-container generates the cryptographic material for the Fabric CA server and checks if the cryptographic material already exists in Vault. If it does, the init-container will skip the generation process. The main container runs the Fabric CA server, issues certificates to clients in the organization, and has a liveness probe that checks if the Fabric CA server is running. The store-vault container stores the cryptographic material in Vault, Checks if any certificates have not been stored correctly.
- `volume.yaml`: Defines 2 persistent volume to store the data. 
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-fabric/charts/catools/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                       | Default Value       |
| ----------------------| --------------------------------------------------| ------------------- |
| namespace             | Namespace for CA deployment                       | example-com         |
| name                  | Name for CA server deployment                     | ca-tools            |
| component_type        | Organization's type (orderer or peer)             | orderer             |
| org_name              | Organization's name in lowercase                  | org1                |
| proxy                 | Proxy/ingress provider (ambassador or haproxy)    | haproxy             |

### Replica

| Name                  | Description                 | Default Value  |
| ----------------------| --------------------------- | ---------------|
| replicaCount          | Number of replica pods      | 1              |

### Image

| Name          | Description                                                             | Default Value                                       |
| --------------| ------------------------------------------------------------------------| ----------------------------------------------------|
| repository    | Image name for the server container                                     | hyperledger/fabric-ca-tools                         |
| tag           | Image tag for the server container                                      | 1.3.0                                               |
| pullPolicy    | Image pull policy                                                       | IfNotPresent                                        |
| alpineutils   | Valid image name and version to read certificates from the vault server | ghcr.io/hyperledger/bevel-alpine:latest             |


### Annotations

| Name           | Description                           | Default Value   |
| ---------------| --------------------------------------|-----------------|
| pvc            | Extra annotations for PVC             | ""              |
| deployment     | Extra annotations for Deployment      | ""              |

### Storage

| Name                  | Description                 | Default Value       |
| ----------------------| --------------------------- | ------------------- |
| storageclassname      | Storage class name          | aws-storage         |
| storagesize           | Storage size for CA         | 512Mi               |

### Vault

| Name                  | Description                                                       | Default Value                     |
| ----------------------| ------------------------------------------------------------------|-----------------------------------|
| role                  | Vault role for an organization                                    | org1-vault-role                   |
| address               | Vault server address                                              | ""                                |
| authpath              | Kubernetes auth backend configured in vault for an organization   | fra-demo-hlkube-cluster-org1      |
| secretmsp             | Path configured in vault for admin MSP                            | secret/secretmsp/                 |
| secrettls             | Path configured in vault for admin TLS                            | secret/secrettls/                 |
| secretorderer         | Path configured in vault for orderers                             | secret/secretorderer/             |
| secretpeerorderertls  | Path configured in vault for peer orderer TLS                     | secret/secretpeerorderertls/      |
| secretambassador      | Path configured in vault for ambassador credentials               | secret/secretambassador/          |
| secretcert            | Path configured in vault for CA server certificate                | secret/secretcert/                |
| secretkey             | Path configured in vault for CA server private key                | secret/secretkey/                 |
| secretconfigfile      | Path configured in vault for MSP config.yaml file                 | secret/secretconfigfile/          |
| secretcouchdb         | Path configured in vault for CouchDB credentials                  | secret/secretcouchdb/             |
| serviceaccountname    | Service account name for Vault                                    | vault-auth                        |
| imagesecretname       | Image secret name for Vault                                       | ""                                |

### HealthCheck

| Name                  | Description                                                               | Default Value  |
| ----------------------| --------------------------------------------------------------------------| ---------------|
| retries               | Number of times to retry fetching from/writing to Vault before giving up  | 10             |
| sleepTimeAfterError   | Time in seconds to wait after an error occurs when interacting with Vault | 15             |

### Org_data

| Name                  | Description                       | Default Value   |
| ----------------------| ----------------------------------| ----------------|
| external_url_suffix   | External URL of the organization  | ""              |
| component_subject     | Organization's subject            | ""              |
| cert_subject          | Organization's subject            | ""              |
| component_country     | Organization's country            | UK              |
| component_state       | Organization's state              | London          |
| component_location    | Organization's location           | London          |
| ca_url                | Organization's CA URL             | ""              |

### Orderers

| Name           | Description                           | Default Value  |
| ---------------| --------------------------------------| ---------------|
| name           | Orderer's name                        | orderer1       |
| orderers_info  | Orderer's names and CA certificates   | ""             |

### Peers

| Name          | Description                 | Default Value    |
| --------------| --------------------------- | -----------------|
| name          | Peer's name                 | peer1            |
| peer_count    | Total number of peers       | 4                |

### Users

| Name                  | Description                   | Default Value   |
| ----------------------| ---------------------------   | ----------------|
| users_list            | Base64 encoded list of users  | ""              |
| users_identities      | List of user identities       | ""              |

### Checks

| Name                  | Description                 | Default Value       |
| ----------------------| --------------------------- | ------------------- |
| refresh_cert_value    | Refresh user certificates   | ""                  |


<a name = "deployment"></a>
## Deployment
---

To deploy the catools Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/catools/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./catools
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the catools node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get deployments -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of replicas and their current status.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/catools/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./catools
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the catools node is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [CA Tools Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/catools), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
