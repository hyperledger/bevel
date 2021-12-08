[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/float
This role creates deployment file for float and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Create value file for float
This tasks creates deployment file for the Float component of the Node firewall by calling the `helm_component` role.
##### Input Variables
- *`component_name` - The exact name of the component
- `type` - The type of component, i.e. `bridge`
- `name` - The name of the organization
- `corda_service_version` - `firewall`, this is used to find the Docker image from `helm_component/vars`
- `component_ns` - The namespace where the resource will be deployed to
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `charts_dir` - The directory where the Helm charts for the component are stored
- `values_dir` - The directory where the release files are stored
- `float_name` - The name of the `float` component
- `init_container_name` - The name of the Docker image used for the `init-container`s
- `image_pull_secret` - The image pull secret used to pull Docker images from registry
- *`vault_addr` - The Vault address
- *`vault_role` - The Vault role that has been configured with access to the Vault
- `auth_path` - The Vault auth path for the organisation
- `vault_serviceaccountname` - The service account linked to the Vault
- `vault_cert_secret_prefix` - The Vault path prefix used in every Vault request for this component
- `storageclass`- The name of the storage class
- *`float_address` - The internal address of the Float component
- *`float_port` - The port of the Float component
- *`bridge_subject` - The subject of the Bridge component
- *`bridge_tunnel_port` - The tunnel port of the Bridge component
- `dmz_internal` - The internal IP of DMZ
- `dmz_external` - The external IP of DMZ


#### 2. "Push the created deployment files to repository"
This tasks push the created value files into repository by calling git_push role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.

#### 3. "Wait for float pod to come up"
This task waits till the float pod is running.
##### Input Variables
- *`component_type` - The exact type of the component for whom the value file is created.
- *`namespace` - namespace is the variable called component_ns.
- *`component_name` - The exact name of the component for whom the value file is created.
- *`kubernetes` - item.k8s can be found in your network yaml.

---

##############################################

#### 4. "Copy the network-parameter file into the float pod"
This task copies network-parameter file into the float pod.
