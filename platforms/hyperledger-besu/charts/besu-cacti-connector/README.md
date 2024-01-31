[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-hyperledger-besu-cactus-connector"></a>
# Deploy Hyperledger Besu Cactus connector

- [Hyperledger Besu Connector Helm Chart](#hyperledger-besu-cacti-connector-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "hyperledger-besu-cacti-connector-helm-chart"></a>
## Hyperledger Besu Connector Helm Chart
---
This Helm chart deploys the Cactus Hyperledger Besu Connector, which connects to a Besu node and exposes its functionality through an API server. The chart includes deployment configurations, services, config maps, and other resources required for deploying the connector.

<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- Hyperledger Besu platform/network should be up and running.
- Members and Validators nodes should be in running state.
- Helm installed

<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
besu-cacti-connector/
  |- templates/
        |- _helpers.yaml
        |- configmap.yaml
        |- deployment.yaml
        |- service.yaml
  |- .helmignore
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `deployment.yaml`: Deploys the Cactus connector as a Kubernetes deployment.
- `service.yaml`: Creates a Kubernetes service for accessing the connector.
- `chart.yaml`: Contains metadata and version information about the Helm chart.
- `values.yaml`: Defines the configurable values for the Helm chart.
- `configmap.yaml`: Creates a config map that provides plugin details for the connector.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `.helmignore`: Specifies patterns to ignore when packaging the Helm chart.

<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-cacti-connector) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Metadata

| Name                        | Description                                             | Default Value         |
| --------------------------- | ------------------------------------------------------- | --------------------- |
| namespace                   | Namespace where the deployment will be created          | default               |

### Replica Count

| Name                     | Description                          | Default Value |
| ------------------------ | ------------------------------------ | ------------- |
| replicaCount             | Number of replicas                   | 1             |

### Image

| Name                     | Description                           | Default Value                                   |
| ------------------------ | ------------------------------------  | ----------------------------------------------  |
| repository               | Docker image of the API server        | ghcr.io/hyperledger/cactus-cmd-api-server:1.1.3 |
| pullPolicy               | Pull policy of the docker image       | IfNotPresent                                    |


### Service


| Name                     | Description                            | Default Value         |
| ------------------------ | ------------------------------------   | --------------------- |
| type                     | Service type for the Cactus API server | ClusterIP             |
| port                     | Port for the above service             | 4000                    |


### Plugins


| Name                              | Description                                                 | Default Value                                        |
| --------------------------------- | ----------------------------------------------------------- | ---------------------------------------------------- |
| besuNode                        | Existing Besu node name where the plugin will connect   | ""                                                   | 
| packageName                       | Package name for the Besu connector plugin              | @hyperledger/cactus-plugin-ledger-connector-besu      |  
| type                              | Type of import for the Besu connector                   | org.hyperledger.cactus.plugin_import_type.LOCAL      |
| action                            | Action to be performed by the Besu connector            | org.hyperledger.cactus.plugin_import_action.INSTALL  |
| instanceId                        | Unique instance ID in case multiple connectors are deployed | 12345678                                             |
| rpcApiHttpHost                    | Existing Besu node RPC API HTTP host address            | ""                                                 |
| rpcApiWsHost                      | Existing Besu node RPC API WS host address              | ""                                                 |


### Envs


| Name                            | Description                                                  | Default Value |
| ------------------------------- | ------------------------------------------------------------ | ------------- |
| authorizationProtocol           | Authorization protocol for the connector                     | "NONE"        |
| authorizationConfigJson         | JSON configuration for the authorization                     | "{}"          |
| grpcTlsEnabled                  | Whether gRPC TLS is enabled for the connector                | "false"       |


### Proxy

| Name                | Description                                                   | Default Value                           |
| ------------------- | ------------------------------------------------------------  | --------------------------------------- |
| provider            | Provider for exposing the Connector service over the internet | ambassador                              |
| external_url        | Complete external URL for accessing the Connector service     | "" |


<a name = "deployment"></a>
## Deployment
---

To deploy the Quorum Connector using this Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-cacti-connector/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./besu-cacti-connector
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the Hyperledger Besu Connector to the Kubernetes cluster based on the provided configurations.

<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get deployments -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of 
replicas and their current status.

<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-cacti-connector/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./besu-cacti-connector
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the Quorum Connector is up to date.

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
If you encounter any bugs, have suggestions, or would like to contribute to the [Ambassador Certs GoQuorum Deployment Helm Chart](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/charts/besu-cacti-connector), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).


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