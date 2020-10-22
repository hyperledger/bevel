## ROLE: `setup/signer`
This role creates deployment file for signer and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Check if the signer certs are already created
This task checks if the signer certificates have already been created (written to the Vault).
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output variables
- `signer_certs` - Variable that stores the result of the command (`signer_certs.failed` will be `true` when the certs do not exist yet)
    
---

#### 2. Wait for pki-generator job to be completed 
This task waits for the idman service to be deployed before continuing, by calling the shared `check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the component is deployed
- `component_name` - The name of the component which is deployed
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

**when** - This task is only run when there are no signer certificates yet, (e.g. `signer_certs.failed == true`)

----

#### 3. Create the signer deployment file
This task creates deployment file for signer node by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component to deploy, i.e. `signer`
- `chart` - The name of the chart, i.e. `signer`
- `name` - The name of the organisation
- `component_name` - The exact name of the component
- *`charts_dir` - The path to signer charts
- `vault` - The information of the Vault for the organisation
- `component_auth` - The auth of the component
- `values_dir` - The directory where the release files are stored
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`    

---

#### 4. Push the created deployment files to repository
This tasks pushes the created value files into repository by calling the shared `git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
- `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
- `msg` - The commit message to use when pushing deployment files.
