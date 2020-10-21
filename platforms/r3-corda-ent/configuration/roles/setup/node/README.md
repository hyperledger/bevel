## ROLE: `setup/node`
This role creates deployment file for each of the nodes within the network and also pushes the generated value file into repository. 

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Wait for namespace creation for {{ organisation }}
This task waits for the namespace of the node to be created before continuing, by calling the shared `check/k8_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Namespace`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 2. Wait for vault-auth creation for {{ organisation }}
This task waits for the vault-auth ServiceAccount to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ServiceAccount`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 3. Wait for vault-reviewer creation for {{ organisation }}
This task waits for the vault-reviewer ServiceAccount to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ServiceAccount`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 4. Wait for ClusterRoleBinding creation for {{ organisation }}
This task waits for the token-review ClusterRoleBinding to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ClusterRoleBinding`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 5. Setup Vault access for nodes
This task will set up Vault access for the node by calling the `setup/vault_kubernetes` role.
##### Input variables
- *`component_name` - The name of the component
- *`component_path` - The Vault path for the component
- *`component_auth` - The authentication identifier for the component 
- *`component_type` - The type of component

--- 

#### 6. Create ambassador certificates for node
This task creates the ambassador certificates for the node by calling the `create/certificates/node` role; this is run for each peer service of the node.
##### Input variables
- `node_name` - THe name of the peer 

---

#### 7. Save TLS certificates for orderers to Vault
This task will save the TLS certificates for the orderers to the Vault by calling the `setup/tlscerts` role. This will be called for each of the orderers in the network.

---

#### 8. Write node keystore, truststore and network-root-truststore to the Vault
This task will write some files to the Vault by calling the `setup/credentials` role.

---

#### 9. Create value file for node registration
This task will create the value file for the node registration by calling the `setup/node_registration` role.

----

#### 10. Create value file for node
This task will create the value file for the node by calling the `helm_component` role. 
##### Input variables
- `helm_lint` - Whether to lint the Helm chart, i.e. `true
- `git_url` - The GIT url to the repository
- `git_branch` - The current working branch of the repository
- *`charts_dir` - path to node charts, fetched from network.yaml
- *`component_name` - The exact name of the component
- `node_name` - The exact name of the node
- `values_dir` - The directory where the release files are stored
- *`name` - The name of the organization
- `corda_service_version` - `node`, this is used to find the Docker image from `helm_component/vars`
- `type` - The type of component, i.e. `node`
- `doorman_url` - The URL to the doorman (idman)
- `networkmap_url` - The URL to the networkmap (nmap)

----

#### 11. Create value file for bridge
This task will create the value file for the bridge firewall component by calling the `setup/bridge` role (for each peer in the organisation).

----

#### 12. Create value file for node registration
This task will create the value file for the float firewall component by calling the `setup/float` role (for each peer in the organisation).

----

#### 13. Push the created deployment files to repository
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
- `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `msg` - The commit message to use when pushing deployment files.
