[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy notary-initial-registration"></a>
# Node Deployment

- [Notary-initial-registration Deployment Helm Chart](#Notary-initial-registration-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "notary-initial-registration-deployment-helm-chart"></a>
## notary-initial-registration Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-notary-initial-registration) helps to deploy the job for initial notory node registration.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- networkmap and Node's database up and running.
- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.


This chart has following structue:
```
  .
  ├── notary-initial-registration
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── _helpers.tpl
  │   │   └── job.yaml
  │   └── values.yaml
```

Type of files used:

- `templates`      : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `job.yaml`       : This file is a configuration file for deployement in Kubernetes.It creates a deployment file with a specified number of replicas and defines various settings for the deployment, Init container is responsible for intial node registration process is completed successfully before the main containers start.It also specifies volume mounts for storing certificates and data.
- `chart.yaml`     : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`    : Contains the default configuration values for the chart. It includes configuration for the image, nodeconfig, credenatials, storage, service , vault, etc.
- `_helpers.tpl`   : A template file used for defining custom labels and ports for the metrics in the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-notary-initial-registration/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| name       | Provide the name of the node                       | bank1         |

### Metadata

| Name            | Description                                                                  | Default Value |
| ----------------| ---------------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace for the Notary-initial-registration Generator          | default       |
| labels          | Provide any additional labels for the Notary-initial-registration Generator  | ""            |

### Image

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | ---------------------------------------------------------------------------------------    | --------------- |
| initContainerName        | Provide the alpine utils image, which is used for all init-containers of deployments/jobs  | ""              |
| containerName            | Provide the containerName of image                                                         | ""              |
| imagePullSecret          | Provide the image pull secret of image                                                     | regcred         |
| privateCertificate       | Provide true or false if private certificate to be added                                   | "true"          |
| doormanCertAlias         | Provide true or false if private certificate to be added                                   | ""              |
| networkmapCertAlias      | Provide true or false if private certificate to be added                                   | ""              |

### NodeConf

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | --------------------------------------------------------------------------------------     | --------------- |
| p2p                      | The host and port on which the node is available for protocol operations over ArtemisMQ    | ""              |
| ambassadorAddress        | Specify ambassador host:port which will be advertised in addition to p2paddress            | ""              |
| legalName                | Provide the legalName for node                                                             | ""              |
| dbUrl                    | Provide the h2Url for node                                                                 | "bank1h2"       |
| dbPort                   | Provide the h2Port for node                                                                | "9101"          |
| networkMapURL            | Provide the nms for node                                                                   | ""              |
| doormanURL               | Provide the doorman for node                                                               | ""              |
| jarVersion               | Provide the jar Version for corda jar and finanace jar                                     | "3.3-corda"     |  
| devMode                  | Provide the devMode for corda node                                                         | "true"          |
| env                      | Provide the enviroment variables to be set                                                 | ""              |

### credentials

| Name            | Description                                   | Default Value  |
| ----------------| ----------------------------------------------| -------------  |
| dataSourceUser  | Provide the dataSourceUser for corda node     | ""             |
| rpcUser         | Provide the rpcUser for corda node            | bank1operations|

### Volume

| Name             | Description            | Default Value |
| -----------------| -----------------------| ------------- |
| baseDir          | Base directory         | /home/bevel   |

### Resources

| Name                     | Description                                             | Default Value   |
| ------------------------ | ------------------------------------------------------- | --------------- |
| limits                   | Provide the limit memory for node                       | "1Gi"           |
| requests                 | Provide the requests memory for node                    | "1Gi"           |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | NodePort        |
| p2p port              | Provide the tcp port for node             | 10007           |
| p2p nodePort          | Provide the p2p nodeport for node         | 30007           |
| p2p targetPort        | Provide the p2p targetPort for node       | 30007           |
| rpc port              | Provide the tpc port for node             | 10008           |
| rpc targetPort        | Provide the rpc targetport for node       | 10003           |
| rpc nodePort          | Provide the rpc nodePort for node         | 30007           |
| rpcadmin port         | Provide the rpcadmin port for node        | 10108           |
| rpcadmin targetPort   | Provide the rpcadmin targetport for node  | 10005           |
| rpcadmin nodePort     | Provide the rpcadmin nodePort for node    | 30007           |

### Vault

| Name                      | Description                                                               | Default Value              |
| ------------------------- | --------------------------------------------------------------------------| -------------------------  |
| address                   | Address/URL of the Vault server                                           | ""                         |
| role                      | Role used for authentication with Vault                                   | vault-role                 |
| authpath                  | Authentication path for Vault                                             | cordabank1                 |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth-issuer          |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | bank1/certs                |
| dbsecretprefix            | Provide the secretprefix                                                  | bank1/credentials/database |
| rpcusersecretprefix       | Provide the secretprefix                                                  | bank1/credentials/rpcusers |
| keystoresecretprefix      | Provide the secretprefix                                                  | bank1/credentials/keystore |
| retires                   | Provide the no of retires                                                 | ""                         |

### Healthcheck

| Name                        | Description                                                                   | Default Value |
| ----------------------------| ------------------------------------------------------------------------------| ------------- |
| readinesscheckinterval      | Provide the interval in seconds you want to iterate till db to be ready       | 5             |
| readinessthreshold          | Provide the threshold till you want to check if specified db up and running   | 2             |


<a name = "deployment"></a>
## Deployment
---

To deploy the notary-initial-registration Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/r3-corda/charts/corda-notary-initial-registration/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade,verify, delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-notary-initial-registration
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-notary-initial-registration
```

To verify the deployment:
```bash
kubectl get jobs -n <namespace>
```
Note : Replace `<namespace>` with the actual namespace where the Job was created. This command will display information about the Job, including the number of completions and the current status of the Job's pods.

To delete the chart: 
```bash
helm uninstall <release-name>
```
Note : Replace `<release-name>` with the desired name for the release.


<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the [notary-initial-registration Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/develop/platforms/r3-corda/charts/corda-notary-initial-registration), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
