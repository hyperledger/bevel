## delete/fluxrelease
This role deletes the helm releases and uninstalls Flux
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Uninstall Flux
This task removes FLUX
##### Input Variables
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes Flux.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 2. Deletes the Tessera TM Helmrelease
This task deletes the helmrelease for each peer for Tessera Transaction Manager
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "Name of component, Format: {{ org_name }}{{ peer.name }}tessera"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 3. Deletes the Constellation TM Helmrelease
This task deletes the helmrelease for each peer for Constellation Transaction Manager
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "Name of component, Format: {{ org_name }}{{ peer.name }}tessera"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Remove Node Helm releases
This task deletes node helm releases for Tessera and Constellation Transaction Manager
##### Input Variables
    namespace: Namespace of the component
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Uninstall Namespaces
This task removes namespaces
##### Input Variables
    kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.