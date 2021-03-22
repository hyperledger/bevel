## delete/fluxrelease
This role deletes the helm releases and uninstalls Flux
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Deletes all the helmreleases CRD
This task deletes HelmRelease
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 2. Remove all Helm releases
This task removes all HelmRelease
##### Input Variables
**ignore_errors**: This flag ignores the any errors and proceeds furthur.

#### 3. Deletes namespaces
This task removes namespaces
##### Input Variables
    kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds furthur.