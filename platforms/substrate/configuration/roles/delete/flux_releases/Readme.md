[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## delete/flux_releases
This role deletes the helm releases and uninstalls Flux

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Uninstall Flux
This task removes FLUX
##### Input Variables
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes Flux.
**ignore_errors**: This flag ignores any errors and proceeds furthur.

#### 2. Delete the helmrelease for each peer
This task deletes the helmrelease for each peer
##### Input Variables
    kind: Helmrelease, The kind of component
    *namespace: Namespace of the component
    *name: "Name of component, Format: {{ org_name }}{{ peer.name }}tessera"
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 3. Remove node helm releases
This task deletes the helmrelease for each peer
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Remove Node Helm releases
This task deletes node helm releases for Tessera and Constellation Transaction Manager
##### Input Variables
    *namespace: Namespace of the component
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Deletes namespaces
This task removes namespaces
##### Input Variables
    kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.