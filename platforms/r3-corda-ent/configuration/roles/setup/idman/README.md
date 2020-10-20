## ROLE: `setup/idman`
This role creates deployment file for the Identity Manager and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. Wait for Signer pod to come up
This task will wait for the Signer pod to come up before starting to deploy the Identity Manager, as the service is dependent on Signer. It does this by calling the `shared/configuration/roles/check/helm_component` role.
##### Input variables
- `component_type` - The type of component to check for, i.e. `Pod`
- `namespace` - The namespace where the Signer pod is deployed
- `component_name` - The name of the Signer pod
- `kubernetes` - The resources of the K8s cluster (context and configuration file)

---

#### 2. Create idman ambassador certificates
This task will create the ambassador certificates for Idman by calling the `create/certificates/cenm` role.
##### Input variables
- `tlscert_path` - The path where the TLS certificates will be stored
- `dest_path` - The destination path for the certificate file
- `service_name` - The name of the service (idman)

---

#### 3. Create value file for Idman
This task creates deployment file for the Idman component the CENM by calling the `helm_component` role.
##### Input Variables
- `type` - The type of component, i.e. `bridge`
- `name` - The name of the organization
- *`component_name` - The exact name of the component
- *`charts_dir` - The directory where the Helm charts for the component are stored
- `values_dir` - The directory where the release files are stored
- `corda_service_version` - `idman{{ org.version }}`, this is used to find the Docker image from `helm_component/vars`
- `helm_lint` - Whether to lint the Helm chart, i.e. `true`

---

#### 4. Push the created deployment files to repository
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
