## delete/fluxrelease
This role deletes the helm releases and uninstalls Flux
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Deletes the CA server Helmrelease
This task deletes CA server HelmRelease
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "Name of component, Format: {{ component_name }}-ca"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 2. Deletes the CA tools helmrelease
This task deletes CA Tools server HelmRelease
##### Input Variables
    kind: Helmrelease, The kind of component
    namespace: Namespace of the component
    name: "Name of component, Format: {{ component_name }}-ca-tools"
    state: absent ( This deletes any found result)
    kubeconfig: The config file of cluster
    context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 3. Remove Common Helm releases
This task removes commom HelmRelease
##### Input Variables
    namespace: Namespace of the component
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 4. Remove Helm releases for orderer
This task removes HelmRelease for orderer
##### Input Variables
    org_name: Name of the org
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**when**: It runs when the component type is orderer.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 5. Remove Helm releases for peers
This task removes HelmRelease for orderer
##### Input Variables
    org_name: Name of the org
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**when**: It runs when the component type is peers.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 6. Remove Helm releases for channels
This task removes HelmRelease for channels
##### Input Variables
    org_name: Name of the org
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes HelmReleases.
**when**: It runs when the component type is peer.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 7. Uninstall Flux
This task removes FLUX
##### Input Variables
    *KUBECONFIG: The config file of cluster
**shell**: This commands deletes Flux.
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 7. Uninstall Namespaces
This task removes namespaces
##### Input Variables
    kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.