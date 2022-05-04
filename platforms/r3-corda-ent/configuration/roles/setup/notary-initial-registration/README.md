[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/notary-initial-registration`
This role creates deployments file for notary and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1 ."Check if the notary-registration is already completed."
This task will check if the notary-registration is already completed or not.
#### Input Variables
- `VAULT_ADDR` -The Vault address
- `VAULT_TOKEN` - Vault root/custom token which has the access to the path.
##### Output variables 
- `notary_certs` - Variable that stores the result of the command (`notary_certs.failed` will be `true` when the certs do not exist yet)
 
**ignore_errors** is set to `yes` because when first setting up of network, this call will fail.

---

#### 2. "Create value file for notary registration job."
This task will create value file for notary registration job
**when** notary_certs are failed.

---

#### 3. "waiting for notary initial registration job to complete"
This task will wait for notary initial registration job to complete.
#### Input variables
 - `component_type` - The type of component to check for, i.e. `job`
 - `namespace` -  The namespace where the component is deployed
 - `component_name` - The exact name of the component
    kubernetes: The resources of the K8s cluster (context and configuration file).
  **when** notary_certs are failed.

---

#### 4. Wait for idman pod to come up 
This task waits for the idman service to be deployed before continuing, by calling the shared `check/helm_component` role.
#### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

---

#### 5. Create DB for notary
This task creates deployment files for the notary DB by calling the `helm_component` role.
##### Input Variables
- `component_name` - The exact name of the component
- `type` - db
- `values_dir` - The directory where the release files are stored
- `name` - The name of the organisation
- *`charts_dir` - path to Node registration charts
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `node_name` - The name of the notary service
- `image_pull_secret` - regcred, used to pull Docker images from the (private) repository
- `storageclass` - The name of the storageclass
- `container_name` - The name of the Docker image for the container
- `tcp_port` - The TCP port of the DB
- `tcp_targetport` - The TCP target port of the DB
- `web_port` - The web port of the notary
- `web_targetport` - The web target port of the notary
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`    

---

#### 6. Check if nodekeystore is already created
This task checks if the nodekeystore already created for for the notary by checking in the Vault.
##### Input Variables
- *`org.services.notary.name` -  Name of the notary which is also the Vault secret path
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output Variables
- `nodekeystore_result` - Variable that stores the result of the command (`nodekeystore_result.failed` will be `true` when the certs do not exist yet)
    
**ignore_errors** is set to `yes` because when first setting up of network, this call will fail.

---

#### 7. Create notary initial-registration job file
This task creates deployment files for job for notary by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component to deploy, i.e. `notary-initial-registration`
- *`component_name` - The name of the component to deploy
- `name` - The name of the organization
- `notary_service` - The notary service information
- `notary_name` - The name of the notary service
- `values_dir` - The directory where the release files are stored
- *`charts_dir` - path to Node registration charts
- `git_url` - The SSH URL of the GIT repository
- `git_branch` - The current working branch of the GIT repository
- `idman_url` - The URL of the idman 
- `idman_domain` - The domain of the idman
- `networkmap_url` - The URL of the networkmap
- `networkmap_domain` - The domain of the networkmap
- `corda_service_version` - `notary-{{ network.version }}`, this is used to find the Docker image from `helm_component/vars`

**when** - This task is called only when `nodekeystore_result` is failed, i.e. only when first time set-up of network.

---

#### 8. Push the created deployment files to repository
This task pushes the created value files into repository by calling git_push role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.
