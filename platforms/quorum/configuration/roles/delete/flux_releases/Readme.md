## delete/fluxrelease
This role deletes the helm releases and uninstalls Flux

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Deletes the CA server Helmrelease
This task deletes the doorman helmreleases
##### Input Variables
    *component_name: name of the resource
**shell** : script to purge the doorman,mongodb-doorman and deletes the helmrelease for the same
**when** : runs this role when organization is doorman
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 2. Deletes the networkmap Helmrelease
This task deletes the networkmap helmrelease
##### Input Variables
    *component_name: name of the resource
**shell** : script to purge the networkmap,mongodb-networkmap and deletes the helmrelease for the same
**when** : runs this role when organization is nms
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 3. Deletes the notary Helmrelease
This task deletes the notary helmrelease
##### Input Variables
    *component_name: name of the resource
**shell** : script to purge the notarydb,notary job,notary and deletes the helmrelease for the same
**when** : runs this role when organization is notary
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 4. Deletes the node Helmrelease
This task deletes the node helmrelease
##### Input Variables
    *component_name: name of the resource
**shell** : script to purge the node-db,node job,node and deletes the helmrelease for the same
**when** : runs this role when organization is node
**ignore_errors**: This flag ignores the any errors and proceeds further.

#### 5. Uninstall Namespaces
This task removes namespaces
##### Input Variables
    kind: Namespace
    *name: Name of Component
    state: absent ( This deletes any found result)
    *kubeconfig: The config file of cluster
    *context: The context of the cluster
**ignore_errors**: This flag ignores the any errors and proceeds further.