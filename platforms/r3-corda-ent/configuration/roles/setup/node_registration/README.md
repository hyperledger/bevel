## ROLE: `setup/node_registration`
This role creates deployment file for node registration and also pushes the generated value file into repository. There is a `nested_main.yaml` which contains some tasks that are created per peer in the organisation.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if the node-registration is already completed
This task will check if the node-registration is already completed by checking if the truststore is already present in Vault.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables 
- `node_certs` - Variable that stores the result of the command (`node_certs.failed` will be `true` when the certs do not exist yet)

---

#### 2. "Create value file of db for node registration"
This task creates deployment file for the node DB by calling the `helm_component` role.
##### Input Variables
- *`component_name` - The exact name of the component
- `type` - The type of component, i.e. `node`
- `values_dir` - The directory where the release files are stored
- *`name` - The name of the organization
- *`charts_dir` - path to Node DB charts
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `node_name` - The name of the node
- `container_name` - The image name of the Node DB container
- `tcp_port` - The TCP port of the node
- `tcp_targetport` - The TCP targetport of the node
- `web_port` - The web port of the peer
- `web_targetport` - The web target port of the peer

---

#### 3. "Create value file for node registration"
This task creates deployment file for node registration by calling the `helm_component` role.
##### Input Variables
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- *`charts_dir` - path to Node registration charts
- *`component_name` - The exact name of the component
- `node_name` - The name of the node
- `values_dir` - The directory where the release files are stored
- `name` - The name of the node
- `corda_service_version` - `node`, this is used to find the Docker image from `helm_component/vars`
- `image_pull_secret` - `regcred`, used to pull Docker images from the (private) repository
- `type` - The type of component, i.e. `node_registration`
- `doorman_url` - The URL to the doorman (idman)
- `networkmap_url` - The URL to the networkmap (nmap)

---

#### 4. "Push the created deployment files to repository"
This task pushes the created value files into repository by calling the `git_push` role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
- `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `msg` - The commit message to use when pushing deployment files.

---

#### 5. Wait for node initial registration job 
This task waits for the node initial registration to be complete before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Job`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when**: It runs when **node_certs.failed** variable is `true`