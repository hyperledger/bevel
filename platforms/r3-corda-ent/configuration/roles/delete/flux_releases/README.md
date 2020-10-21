## ROLE: `delete/flux_releases`
This role deletes all Helm releases.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Deletes all the helmreleases in {{ namespace }}
This task deletes all helmreleases in a namespace of an organisation.
##### Input Variables
- `component_ns` - The namespace from which to delete all helmreleases (CRD) from the Kubernetes Cluster.

**ignore_errors**: This flag ignores the any errors and proceeds further.

---

#### 2. Remove all Helm releases of {{ org.name }}
This task deletes all Helm releases for an organisation from Helm.
##### Input Variables
- `org.name` - The organisation name, used to filter all Helm release for the once to delete

**ignore_errors**: This flag ignores the any errors and proceeds further.

---

#### 3. Delete namespace
This task removes a namespace after all resources in it have been deleted.
##### Input Variables
- `kind` - The kind of resource to delete, in this case a `Namespace`
- `*name` - The name of the namespace to delete
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of K8s cluster
- `*context` - The context of the K8s cluster

**ignore_errors**: This flag ignores the any errors and proceeds further.
