## ROLE: `setup/pki-generator-node`
This role creates deployment file for the `generate-pki-node` chart and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. "Checking if generate-pki job is already completed for the node"
This tasks checks if the pki-generator job is already ran for the node or not
##### Input Variables
- `job_title` - The exact title of the `Job` to check
- `component_type` - The type of component to check for, i.e. `OneTimeJob`
- `component_name` - The name of the component to check for
##### Output variables
- `generate_pki` - Variable that stores the result of the command (`generate_pki.resources` will be more than `0` when the job is complete)

---

#### 2. "Create value file for pki generator for the node"
This task will create the deployment files for the generate-pki-node job by calling the `helm_component` file.
##### Input variables
- `type` - The type of component to deploy, i.e. `pki-generator`
- `corda_service_version`- `pki{{ org.version }}`, this is used to find the Docker image from `helm_component/vars`
- `values_dir` - The directory where the release files are stored
- `name` - The name of the organisation
- `component_name` - The exact name of the component to deploy
- *`charts_dir` - path to Node registration charts
- `chart` - The name of the chart to deploy

**when** - This task is called only when `generate_pki.resources|length == 0`, i.e. only when the `generate-pki` job has not run yet.

---

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

**when** - This task is called only when `generate_pki.resources|length == 0`, i.e. only when the `generate-pki` job has not run yet.
