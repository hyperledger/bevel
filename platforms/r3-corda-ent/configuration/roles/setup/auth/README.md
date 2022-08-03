[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: `setup/auth`
This role creates deployment files Auth service and pushes the generated value files to into the repository.

### Tasks
(Variables with * are fetched from the playbook whivh is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if auth certificates are present in the vault
This task checks if the auth certificates have already been created (written to the Vault).
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables
- `auth_certs` - Variable that stores the result of the command (`auth_certs.failed` will be `true` when the certs do not exist yet)

---

#### 2. Wait for PKI job to complete
This task waits for the PKI job to complete so the auth certs can be generated.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Job`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when** - This task is only run when there are no auth certificates yet, (e.g. `auth_certs.failed == true`)

---

#### 3. Create Auth helm release files
This task creates deployment file for auth service by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component to deploy, i.e. `auth`
- `chart` - The name of the chart, i.e. `auth`
- `corda_service_version` - The version of the auth service
- `name` - The name of the organisation
- `component_name` - The exact name of the component
- `charts_dir` - The path to auth charts
- `vault` - The information of the Vault for the organisation
- `component_auth` - The auth of the component
- `values_dir` - The directory where the release files are stored
- `helm_lint` - Whether to lint the Helm chart, i.e. `true` 

---

#### 4. Push the created deployment files to repository
This tasks pushes the created value files into repository by calling the shared `git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- `GIT_RESET_PATH` - The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `gitops` - *item.gitops* from `network.yaml`
- `msg` - The commit message to use when pushing deployment files.
