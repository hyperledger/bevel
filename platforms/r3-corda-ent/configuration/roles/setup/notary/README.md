[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/notary
This role creates deployments file for notary and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Wait for nmap pod to come up 
This task waits for the nmap service to be deployed before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

---

#### 2. Create ambassador certificates for notary
This task creates the ambassador certificates for the notary by calling the `create/certificates/cenm` role.
##### Input Variables
- `tlscert_path` - The path where the TLS certificates will be stored
- `dest_path` - The destination path for the certificate file
- `service_name` - The name of the service (notary)

---

#### 3. Create value file for notary
This tasks creates deployment files for the notary by calling the `helm_component` role.
##### Input Variables
- `type` - notary
- `notary_service` - The name of the notary service
- `component_name` - The exact name of the component
- `name` - The name of the organisation
- `values_dir` - The directory where the release files are stored
- *`charts_dir` - path to Node registration charts
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `idman_url` - The URL to the idman
- `idman_domain` - The domain of the idman
- `networkmap_url` - The URL to the networkmap (nmap)
- `networkmap_url` - The domain of the networkmap (nmap)
- `corda_service_version` - `notary-{{ network.version }}`
- `p2p_port` - The notary p2p port
- `ambassador_p2pPort` - The notary ambassador p2p port    

---

#### 4. Push the created deployment files to repository
This tasks pushes the created value files into repository by calling the shared `git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.

---

#### 5. "Wait for namespace creation for organisation"
This task waits for the namespace of the node to be created before continuing, by calling the shared `check/k8_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Namespace`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 6. "Wait for vault-auth creation for organisation."
This task waits for the vault-auth ServiceAccount to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ServiceAccount`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 7. "Wait for vault-reviewer creation for organisation."
This task waits for the vault-reviewer ServiceAccount to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ServiceAccount`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 8. "Wait for ClusterRoleBinding creation for organisation."
This task waits for the token-review ClusterRoleBinding to be created before continuing, by calling the shared `check/k8_component` role. 
##### Input variables
- `component_type` - The type of component to check for, i.e. `ClusterRoleBinding`
- `component_name` - The exact name of the component
- `type` - `retry`, the role will keep retrying the check until it exists

---

#### 9. "Setup Vault access for nodes."
This task will set up Vault access for the node by calling the `setup/vault_kubernetes` role.
##### Input variables
- *`component_name` - The name of the component
- *`component_path` - The Vault path for the component
- *`component_auth` - The authentication identifier for the component 
- *`component_type` - The type of component

--- 
#### 10. "Create ambassador certificates for notary"
This task creates the ambassador certificates for notary
##### Input variables
- `tlscert_path` - This refers to the path of tlscert_path
- `node_name` - The name of the peer 
- `service_name` - service name required for creating certificates (in CommonName)
- `dest_path` - This refers to the path of dest_path.

---

#### 11. Save TLS certificates for network services to Vault
This task will save the TLS certificates for the network services to the Vault by calling the `setup/tlscerts` role. This will be called for each of the network service in the network.yaml.

---

#### 12. Write node credentials to Vault
This task will write the following files to the Vault by calling the `setup/credentials` role:
- networkroot-truststore
- node-truststore
- node keystore
- firewall-ca
- float & bridge credentials

---

#### 13. "Create value file for notary registration job"
This task creates value file for notary registration job

---

#### 14. "Create value file for notary"
This task will create the value file for the notary service by calling the `helm_component` role. 
#### Input Variables
- `type` - The type of component, i.e. `notary`
- `notary_service` - The notary service information
- `component_name` -  The exact name of the component
- `values_dir` -The directory where the release files are stored
- `charts_dir` -path to Node registration charts
- `idman_url` -The URL to the idman
- `idman_domain` -The domain of the idman
- `networkmap_url` - The URL to the networkmap (nmap)
- `networkmap_domain` -The domain of the networkmap
- `corda_service_version` -`node`, this is used to find the Docker image from `helm_component/vars`

---

#### 15. Create value files for generate-pki-node
This task will create the value file for the `generate-pki-node` registration by calling the `setup/pki-generator-node` role for each peer in the node organisation.

**when** - This task will only run when the peer has firewall enabled (`peer.firewall.enabled`)

---


#### 16. Create value file for node registration
This task will create the value file for the node registration by calling the `setup/node_registration` role.

----

#### 17. Create value file for node
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
#### 18. Push the created deployment files to repository
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.

#### 19. Create value file for bridge
This task will create the value file for the bridge firewall component by calling the `setup/bridge` role (for each organisation).

----

#### 20. Create value file for float
This task will create the value file for the float firewall component by calling the `setup/float` role (for each organisation).

----