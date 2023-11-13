[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy generate-pki-node"></a>
# Generate-pki-node Deployment

- [Generate-pki-node Deployment Helm Chart](#Generate-pki-node-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Generate-pki-node-deployment-helm-chart"></a>
## Generate-pki-node Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-node-pki-gen) generates the corda complaint certificate hierarchy for the node.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the chart please ensure you have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm is installed.

<a name = "chart-structure"></a>
## Chart Structure
---
This chart has following structue:
```
  ├── generate-pki-node
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── job.yaml
  │   │   ├── _helpers.tpl
  │   └── values.yaml
```
Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `job.yaml`        : Defines a Kubernetes Job resource, which is a Kubernetes controller that creates and manages pods to perform task. It creates a deployment file with a specified number of replicas and defines various settings for the deployment. Including volume mounts, environment variables, and initialization tasks using init containers.  
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, Vault, volume, subjects, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-node-pki-gen/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| nodeName   | Provide the name of the node                       |  carrier      |

### Metadata

| Name            | Description                                                          | Default Value |
| ----------------| -------------------------------------------------------------------- | ------------- |
| namespace       | Provide the namespace for the Corda PKI Generator for the node       | carrier-ent   |
| labels          | Provide any additional labels for the Corda PKI Generator for node   | ""            |

### Image

| Name                     | Description                                                                    | Default Value                              |
| ------------------------ | -----------------------------------------------------------------------------  | ----------------------------------         |
| initContainerName        | Information about the Docker container used for the init-containers            | ghcr.io/hyperledger                        |
| pkiContainerName         | Provide the image for the pki container                                        | corda/enterprise-pki:1.2-zulu-openjdk8u242 |
| ImagePullSecret          | Provide the K8s secret that has rights for pulling the image off the registry  | ""                                         |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent       | IfNotPresent                               |

### Vault

| Name                      | Description                                                               | Default Value         |
| ------------------------- | --------------------------------------------------------------------------| -------------------   |
| address                   | Address/URL of the Vault server                                           | ""                    |
| role                      | Role used for authentication with Vault                                   | vault-role            |
| floatVaultAddress         | Provide the float vault address                                           | ""                    |
| authpath                  | Authentication path for Vault                                             | cordaentcarrier       |
| authpathFloat             | Provide the authpath configured to be used                                | cordaentcarrierfloat  |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth            |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | secret/carrier/carrier|
| retries                   | Amount of times to retry fetching from/writing to Vault before giving up  | 10                    |
| sleepTimeAfterError       | Amount of time in seconds to wait after an error occurs                   | 15                    |

### Subjects

| Name                      | Description                                        | Default Value                                                          |
| ------------------------- | ---------------------------------------------------| ---------------------------------------------------------------------- |
| firewallca                | Mention the subject for the firewallCA             |"CN=Test Firewall CA Certificate, OU=HQ, O=HoldCo LLC, L=New York, C=US" |
| float                     | Mention the subject for the float component        |"CN=Test Firewall CA Certificate, OU=HQ, O=HoldCo LLC, L=New York, C=US" |
| bridge                    | Mention the subject for the bridge component       |"CN=Test Bridge Certificate, OU=HQ, O=HoldCo LLC, L=New York, C=US"      |

### volume

| Name              | Description                                 | Default Value   |
| ------------------| ------------------------------------------  | -------------   |
| baseDir           | Provide the base directory for the container| /opt/corda      |


<a name = "deployment"></a>
## Deployment
---

To deploy the Generate-pki-node Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/corda-ent-node-pki-gen/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./corda-ent-node-pki-gen
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./corda-ent-node-pki-gen
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Generate-pki-node Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/corda-ent-node-pki-gen), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
