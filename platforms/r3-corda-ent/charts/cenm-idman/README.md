[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy idman"></a>
# Idman Deployment

- [Idman Deployment Helm Chart](#Idman-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

<a name = "Idman-deployment-helm-chart"></a>
## Idman Deployment Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-idman) deploys the identity manager Service.

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
  ├── cenm-idman
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
- `deployment.yaml` : Deploying the "Identity Manager" service as containers in a Kubernetes cluster. The init container is defined to perform certain setup tasks before the main containers start. The main container is the primary application container responsible for running the "Identity Manager" service. Both the main container and log container use volume mounts to access shared storage within the pod.
- `_helpers.tpl`    : A template file used for defining custom labels in the Helm chart.
- `pvc.yaml`        : A PersistentVolumeClaim (PVC) is a request for storage by a user.
- `service.yaml`    : This file defines a Kubernetes Service with multiple ports for protocols and targets, and supports Ambassador proxy annotations for specific configurations when using the "ambassador" proxy provider.
- `configmap.yaml`  : ConfigMap resource in Kubernetes with a specific name and namespace, along with labels for identification.  
- `chart.yaml`      : Provides metadata about the chart, such as its name, version, and description.
- `values.yaml`     : Contains the default configuration values for the chart. It includes configuration for the metadata, image, storage, Vault, etc.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-idman/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Name

| Name       | Description                              | Default Value |
| -----------| -----------------------------------------| ------------- |
| nodeName   | Provide the name of the node             |  idman        |

### Metadata

| Name            | Description                                                     | Default Value |
| ----------------| ----------------------------------------------------------------| ------------- |
| namespace       | Provide the namespace for the Corda Enterprise Idman            | cenm          |
| labels          | Provide any additional labels for the Corda Enterprise Idman    | ""            |

### Image

| Name                     | Description                                                                                | Default Value                                |
| ------------------------ | ------------------------------------------------------------------------------------------ | ---------------------------------------------|
| initContainerName        | Information about the Docker container used for the init-containers                        | ghcr.io/hyperledger                          |
| idmanContainer           | Provide the image for the main Idman container                                             | identitymanager:1.2-zulu-openjdk8u242        |
| enterpriseCliContainer   | Provide the docker-registry secret created and stored in kubernetes cluster as a secret    | corda/enterprise-cli:1.5.1-zulu-openjdk8u242 |
| ImagePullSecret          | Provide the K8s secret that has rights for pulling the image off the registry              | ""                                           |
| pullPolicy               | Provide the pull policy for Docker images, either Always or IfNotPresent                   | IfNotPresent                                 |

### storage

| Name                  | Description                                  | Default Value   |
| --------------------- | ------------------------------------------   | -------------   |
| name                  | Provide the name of the storage class        | cenm            |
| memory                | Provide the memory size for the storage class| 64Mi            |

### Vault

| Name                      | Description                                                               | Default Value |
| ------------------------- | --------------------------------------------------------------------------| ------------- |
| address                   | Address/URL of the Vault server                                           | ""            |
| role                      | Role used for authentication with Vault                                   | vault-role    |
| authpath                  | Authentication path for Vault                                             | entcordacenm  |
| serviceAccountName        | Provide the already created service account name autheticated to vault    | vault-auth    |
| certSecretPrefix          | Provide the vault path where the certificates are stored                  | ""            |
| retries                   | Amount of times to retry fetching from/writing to Vault before giving up  | 10            |
| sleepTimeAfterError       | Amount of time in seconds wait after an error occurs                      | 15            |

### Service

| Name                  | Description                               | Default Value   |
| --------------------- | ------------------------------------------| -------------   |
| external port         | Idman 'main' service                      | 100000          |
| internal port         | Internal service, inside the K8s cluster  | 5052            |
| revocation port       | revocation service                        | 5053            |
| adminListener port    | Provide the admin listener port           | ""              |

### Database

| Name                     | Description                                                                     | Default Value         |
| ------------------------ | --------------------------------------------------------------------------------| ---------------       |
| driverClassName          | Java class name to use for the database                                         | /opt/cenm             |
| jdbcDriver               | JDBC Driver name                                                                | "org.h2.Driver"       |
| url                      | The DB connection URL                                                           | jdbc:h2:file          |
| user                     | DB user name                                                                    | "example-db-user"     |
| password                 | DB password                                                                     | "example-db-password" |
| runMigration             | Option to run database migrations as part of startup                            | "true"                | 

### Config

| Name                     | Description                                                                                | Default Value   |
| ------------------------ | -------------------------------------------------------------------------------------------| --------------- |
| baseDir                  | Provide volume related specifications                                                      | /opt/corda      |
| jarPath                  | Provide the path where the CENM Idman .jar-file is stored                                  | "bin"           |
| configPath               | Provide the path where the CENM Service configuration files are stored                     | "etc"           |
| pvc                      | Provide any extra annotations for the PVCs                                                 | "value"         |
| cordaJar                 | Specify the maximum size of the memory allocation pool                                     | "value"         |
| deployment               | Provide any extra annotations for the deployment                                           | "value"         |
| pod                      | Set memory limits of pod                                                                   | ""              |
| replicas                 | Provide the number of replicas for your pods                                               | "1"             |
| sleepTimeAfterError      | Sleep time in seconds, occurs after any error is encountered in start-up                   | 120             |


### CenmServices

| Name           | Description                               | Default Value |
| ---------------| ------------------------------------------| ------------- |
| gatewayName    | Gateway service name                      | ""            |
| gatewayPort    | Gateway service api endpoint port         | ""            |
| zoneName       | Zone service name                         | ""            |
| zoneEnmPort    | Zone service enm port                     | ""            |
| authName       | Name of the auth service                  | ""            |
| authPort       | Auth Service port                         | ""            |

### Healthcheck

| Name                        | Description                                                | Default Value |
| ----------------------------| -----------------------------------------------------------| ------------- |
| nodePort                    | Health Check node port set to get rid of logs pollution    | 0             |


<a name = "deployment"></a>
## Deployment
---
To deploy the idman Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/charts/cenm-idman/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install, upgrade, verify delete the chart:

To install the chart:
```bash
helm repo add bevel https://hyperledger.github.io/bevel/
helm install <release-name> ./cenm-idman
```

To upgrade the chart:
```bash
helm upgrade <release-name> ./cenm-idman
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
If you encounter any bugs, have suggestions, or would like to contribute to the [idman Deployment Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/charts/cenm-idman), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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
