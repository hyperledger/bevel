[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/gateway`
This role creates deployment file for gateway and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if the idman certs are already created
This task checks if the idman certificates have already been created (written to the Vault).
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables
- `idman_certs` - Variable that stores the result of the command (`idman_certs.failed` will be `true` when the certs do not exist yet)
    
---

#### 2. Wait for pki-generator job to be completed 
This task waits for the idman service to be deployed before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when** - This task is only run when there are no signer certificates yet, (e.g. `idman_certs.failed == true`)

----

#### 3. Create value file for gateway service
This task creates deployment file for the gateway service component the CENM by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component, i.e. `gateway`
- `name` - The name of the organization
- *`component_name` - The exact name of the component
- *`charts_dir` - The directory where the Helm charts for the component are stored
- `values_dir` - The directory where the release files are stored
- `corda_service_version` - `gateway-{{ org.version }}`, this is used to find the Docker image from `helm_component/vars`
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`

---

#### 4. Push the created deployment files to repository
This task pushes the created value files into repository by calling the `git_push` role from shared.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.