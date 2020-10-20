## ROLE: `create/namespace_serviceaccount`
This role creates the namespace and serviceaccounts needed for the complete deployment to work.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---
#### 1. Checking if the namespace {{ component_ns }} already exists
This task checks if the namespace already exists.
##### Input Variables
- `component_type` - The type of component to check, in this case `Namespace`
- *`component_name` - The resource name, e.g. `cenm-ent`
- `type` - `no_retry`; this task will only check once for the namespace.

---

#### 2. Set Variable
This task sets the result of the previous task to a variable.
##### Output Variables
- `get_namespace` - The result of the previous task (stores all namespaces that fit the above requirement)

--- 

#### 3. Create namespace for {{ organisation }}
This task creates a namespace for a certain organisation. Calls the `create/k8_component` role.
##### Input Variables
- `*component_type` - Specifies the type of deployment to be created, e.g. `namespace`.
- `*component_name` -  The name of the namespace to create.
- `helm_lint` - Specifies if the chart needs to be checked with `helm lint`, e.g. `false`.
- `release_dir` - The release directory for the `.yaml` files.

---

#### 4. Create Vault Auth serviceaccount for {{ organisation }}
This task creates a Vault Auth serviceaccount with Vault authentication for a certain organisation. Calls the `create/k8_component` role.
##### Input Variables
- `*component_type` - Specifies the type of deployment to be created, e.g. `vaultAuth`.
- `*component_name` -  The name of the namespace to create.
- `helm_lint` - Specifies if the chart needs to be checked with `helm lint`, e.g. `false`.
- `release_dir` - The release directory for the `.yaml` files.

---

#### 5. Create Vault Reviewer serviceaccount for {{ organisation }}
This task creates a serviceaccount with Vault Reviewer access (can call the Vault API) for a certain organisation. Calls the `create/k8_component` role.
##### Input Variables
- `*component_type` - Specifies the type of deployment to be created, e.g. `vault-reviewer`.
- `*component_name` -  The name of the namespace to create.
- `helm_lint` - Specifies if the chart needs to be checked with `helm lint`, e.g. `false`.
- `release_dir` - The release directory for the `.yaml` files.

---

#### 6. Create ClusterRoleBinding for {{ organisation }}
This task creates a ClusterRoleBinding for a certain organisation. Calls the `create/k8_component` role.
##### Input Variables
- `*component_type` - Specifies the type of deployment to be created, e.g. `reviewer_rbac`.
- `*component_name` -  The name of the namespace to create.
- `helm_lint` - Specifies if the chart needs to be checked with `helm lint`, e.g. `false`.
- `release_dir` - The release directory for the `.yaml` files.

---

### 7. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: `{{ playbook_dir }}/../../shared/configuration/roles/git_push`
#### Input Variables:
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
 - `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
 - `msg` - The commit message to use when pushing deployment files.
