[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy auth"></a>
# Auth Deployment

- [Auth Deployment Helm Chart](#Auth-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Auth-deployment-helm-chart"></a>
## Auth Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-auth) deploys the CENM Auth Service.


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
  ├── cenm-auth
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── deployment.yaml
  │   │   ├── _helpers.tpl
  │   │   ├── pvc.yaml
  |   |   |__ configmap.yaml
  │   │   └── service.yaml  
  │   └── values.yaml
```

Type of files used:

- `templates`       : This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `deployment.yaml` : This deployment file defines the setup and configuration of an authentication service for R3 Corda Enterprise, handling tasks such as retrieving SSL certificates and authentication keys from a Vault server, generating JWT, managing the service configuration, and setting up liveness and readiness checks. 
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `configmap.yaml`  : ConfigMap resource in Kubernetes with a specific name and namespace, along with labels for identification.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, storage, Vault, etc.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-auth/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                                        | Default Value |
| -----------| -------------------------------------------------- | ------------- |
| nodeName   | Provide the name of the node                       |  auth         |

### Metadata

| Name            | Description                                                     | Default Value |
| ----------------| ----------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Corda Enterprise Auth             | cenm          |
| labels          | Provide any additional labels for the Corda Enterprise Auth     | ""            |

### Image

| Name                     | Description                                                                                | Default Value                                 |
| ------------------------ | ---------------------------------------------------------------------------------------    | ----------------------------------------------|
| initContainerName        | Provide the alpine utils image, which is used for all init-containers of deployments/jobs  | ghcr.io/hyperledger                           |
| authContainerName        | Provide the image for the main Corda Enterprise Auth                                       | corda/enterprise-auth:1.5.1-zulu-openjdk8u242 |
| imagePullSecret          | Provide the docker-registry secret created and stored in kubernetes cluster as a secret    | ""                                            |
| pullPolicy               | Pull policy to be used for the Docker image                                                | IfNotPresent                                  |

### storage

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| name                  | Provide the name of the storageclass      | cenm            |
| acceptLicense         | Required parameter to start any files     | yes             |

### Vault

| Name                      | Description                                                               | Default Value                     |
| ------------------------- | --------------------------------------------------------------------------| ----------------------------------|
| address                   | Address/URL of the Vault server                                           | ""                                |
| role                      | Role used for authentication with Vault                                   | vault-role                        |
| authpath                  | Authentication path for Vault                                             | entcordacenm                      |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth                        |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | secret/cenm-org-name/signer/certs |
| retries                   | Number of retries to check contents from vault                            | 10                                |
| sleepTimeAfterError       | Sleep time in seconds when error while registration                       | 15                                |

### Database

| Name                  | Description                                               | Default Value      |
| --------------------- | --------------------------------------------------------  | ------------------ |
| driverClassName       | Java class name to use for the database                   | org.h2.Driver      |
| jdbcDriver            | The DB connection URL                                     | ""                 |
| user                  | DB user                                                   | example-db-user    |
| password              | DB password                                               | example-db-password|
| runMigration          | Option to run database migrations as part of startup      | "true"             |

### Config

| Name                     | Description                                                                          | Default Value   |
| ------------------------ | -------------------------------------------------------------------------------------| --------------- |
| baseDir                  | Provide volume related specifications                                                | "/opt/corda"    |
| jarPath                  | Provide the path where the CENM Idman .jar-file is stored                            | "bin"           |
| configPath               | Provide the path where the CENM Service configuration files are stored               | "etc"           |
| pvc                      | Provide any extra annotations for the PVCs                                           | ""              |
| deployment               | Provide any extra annotations for the deployment                                     | "value"         |
| pod                      | Set memory limits of pod                                                             | ""              |
| podSecurityContext       | Allows you to set security-related settings at the Pod level                         | ""              |
| securityContext          | Securitycontext at pod level                                                         | ""              |  
| replicas                 | Provide the number of replicas for your pods                                         | "1"             |
| logsContainersEnabled    | Enable container displaying live logs                                                | "true"          |
| cordaJar                 | Specify the maximum size of the memory allocation pool                               | ""              |
| sleepTimeAfterError      | Sleep time in seconds, occurs after any error is encountered in start-up             |  "120"          |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| type                  | Provide the type of service               | ClusterIP       |
| port                  | provide the port for service              | 8081            |

<a name = "deployment"></a>
## Deployment
---

To deploy the Auth Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-auth/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./cenm-auth
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./cenm-auth
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
If you encounter any bugs, have suggestions, or would like to contribute to the [Auth Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-auth), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).

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
