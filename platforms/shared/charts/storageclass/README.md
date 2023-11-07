[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-storageclass"></a>
# Deploy StorageClass

- [StorageClass Helm Chart](#storageclass-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "storageclass-helm-chart"></a>
## StorageClass Helm Chart
---
This [Helm chart](https://github.com/hyperledger/bevel/tree/main/platforms/shared/charts/storageclass) deploys a StorageClass that can be used to provision persistent volumes for nodes. The StorageClass supports encryption and can be configured to be used in specific topologies.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- Helm installed.
- An AWS account with EBS enabled.


<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
storageclass/
  |- templates/
      |- _heplers.tpl
      |- storageclass.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `_heplers.tpl`: It is a resuable template file to support the Helm chart. The provisioner function in this file can be used to get the appropriate provisioner name for a given cloud provider.
- `templates/`: This directory contains the Kubernetes manifest templates that define the resources to be deployed.
- `storageclass.yaml`:This file defines the StorageClass that is deployed by the chart. It specifies the name of the StorageClass, the storage provisioner to use, the reclaim policy, the volume binding mode, and any other parameters that are needed to configure the StorageClass.
- `Chart.yaml`: This file contains metadata about the chart, such as its name, version, description, and dependencies.
- `README.md`: This file provides information and instructions about the Helm chart.
- `values.yaml`: This file contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/charts/storageclass/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### metadata

| Name    | Description                     | Default Value      |
| --------| --------------------------------| -------------------|
| name    | The name of the StorageClass.   | bevel-storageclass |

### cloud_provider

| Name              | Description                                                                    | Default Value     |
| ------------------| ------------------------------------------------------------------------------ | -------------     |
| cloud_provider    | The name of the cloud provider. Supported values are: aws, gcp, or minikube.   | aws               |

### provisioner

| Name         | Description                                                                                                        | Default Value     |
| -------------| -------------------------------------------------------------------------------------------------------------------| -------------     |
| provisioner  | Optional field. Fill it only if you want to use a specific provisioner of your choice.<br>Otherwise, leave it empty to use the default provisioner based on the value of "cloud_provider" field.                                                                                             | ""                |

### reclaimPolicy

| Name            | Description                                                                                                    | Default Value |
| ----------------| -------------------------------------------------------------------------------------------------------------- | ------------- |
| reclaimPolicy   | The reclaim policy for persistent volumes created by the StorageClass. Supported values are: Delete or Retain. | Delete        |

### volumeBindingMode

| Name             | Description                                                                                                                      | Default Value |
| -----------------| ----------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| volumeBindingMode| The volume binding mode for persistent volumes created by the StorageClass. Supported values are: Immediate or WaitForFirstConsumer.| Immediate  |

### parameters

| Name                 | Description                                    | Default Value                                              |
| ---------------------| -----------------------------------------------| -----------------------------------------------------------|
| parameters.aws       | Parameters for AWS storage provisioner.        | encrypted: "true"                                          |
| parameters.aws       | Parameters for GCP storage provisioner.        | type: pd-standard<br>fstype: ext4<br>replicationtype: none |
| parameters.minikube  | Parameters for Minikube storage provisioner.   | encrypted: "true"                                          |

### allowedTopologies

| Name                          | Description                                       | Default Value                             |
| ------------------------------| --------------------------------------------------| ------------------------------------------|
| matchLabelExpressions         | Label expression to specify the allowed zones.    | ""                                        |
| matchLabelExpressions.key     | Key of the label used for matching.               | failure-domain.beta.kubernetes.io/zone    |
| matchLabelExpressions.values  | List of values for the specified label key.       | eu-east-1a, eu-east-1b                    |

a name = "deployment"></a>
## Deployment
---

To deploy the storageclass Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/charts/storageclass/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./storageclass
    ```
Replace `<release-name>` with the desired name for the release.
This will deploy the StorageClass to the Kubernetes cluster based on the provided configurations.
<a name = "verification"></a>
## Verification
---
To verify the deployment, we can use the following command:
```
$ kubectl get storageclasses <storageclass-name>
```
Replace `<storageclass-name>` with the name of the StorageClass provided in the values.yaml.
This will list the StorageClass that was deployed. The output of the command will include the name of the StorageClass, the storage provisioner that is used, the reclaim policy, and the volume binding mode.
<a name = "updating-the-deployment"></a>
## Updating the Deployment
---
If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/charts/storageclass/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./storageclass
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the StorageClass is up to date.
<a name = "deletion"></a>
## Deletion
---
To delete the deployed StorageClass, run the following Helm command:
```
$ helm uninstall <release-name>
```
Replace `<release-name>` with the name of the release. This command will remove the StorageClass.
<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the [StorageClass Helm Chart](https://github.com/hyperledger/bevel/tree/main/platforms/shared/charts/storageclass), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger/bevel).
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
