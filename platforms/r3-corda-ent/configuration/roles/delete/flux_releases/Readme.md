## delete/flux_releases
This role deletes the helm releases and uninstalls Flux

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. "Deletes all the helmreleases in {{ org.name | lower }}"
This task deletes all helmreleases
**shell** : script to purge and deletes the helmreleases
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 2. Remove all Helm releases of namespace {{ org.name | lower }}
This task deletes all helmreleases of organisation
**shell** : script to purge and deletes the helmreleases

#### 3. Uninstall Namespaces
This task removes namespaces
##### Input Variables
     kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds further.
