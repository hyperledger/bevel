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


#### 3. "Push the created deployment files to repository"
This tasks push the created value files into repository by calling git_push role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
 - `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
 - `msg` - The commit message to use when pushing deployment files.
