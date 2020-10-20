## ROLE: `create/k8_component`
This role creates deployment files for network-map, doorman, mongodb, namespace,storageclass, service accounts and ClusterRoleBinding. Deployment file for a node is created in a directory with name=nodeName, nodeName is stored in component_name, component_type specifies the type of deployment to be created.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Ensures {{ release_dir }}/{{ component_name }} dir exists
This task creates and/or checks if the target directory exists.
##### Input Variables
- *`component_name` - The resource name and target directory name too.
- `path` - The path to the directory is specified here, formed by the `release_dir` (specificed in the `network.yaml`) and the `component_name`
- `state` - type used in the `file` module, in this case `directory`

---

#### 2. Create {{ component_type }} file for {{ component_name }}
This task creates a value file from a template.
##### Input Variables
- `*component_type` - Specifies the type of deployment to be created, e.g. `networkmap`.
- `*component_name` -  The resource name and target directory name too.
- `values_file` - Absolute path of value file for a `component_type`.

---

#### 3. Helm lint
This task tests the value file for syntax errors/missing values by calling the `shared/configuration/roles/helm_lint` role. 
##### Input Variables
- *`helmtemplate_type` -  Deployment file name.
- *`chart_path` - Path where charts are present for the deployment, e.g. `platforms/r3-corda-ent/charts/networkmap`.
- `value_file`: Exact path to value file.

**when**:  It runs when `helm_lint: true`, i.e. the check for syntax needs to be done for generated value file.

---

#### Notes
- The `vars` folder has environment variables for the `create/k8_component` role. 
- The `templates` folder has `.tpl`-files for `eks_storageclass`, `namespace`, `minikube_storageclass`, `serviceaccounts` and `clusterrolebinding`. If there is any change in the `values.yaml` files, the `.tpl` files inside the `template` folder needs to be updated accordingly.