## ROLE: `delete/gitops_files`
This role deletes all the GITops release files.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Delete release files
This task deletes all the files from the release directory
##### Input Variables
- `*release_dir` - The release directory path
- `state` - absent (this deletes any found result)

---

#### 2. Git Push
This task pushes the current state to the GIT repo after deleting value files from `release_dir` by calling the `shared/configuration/roles/git_push` role.
##### Input Variables
- `GIT_DIR` - The base path of the GIT repository, default `{{ playbook_dir }}/../../../`
- *`GIT_REPO` - HTTPS URL for GIT repository, used for pushing deployment files; uses the variable `{{ gitops.git_push_url }}` from `network.yaml`
- *`GIT_USERNAME`: Username with access to the GIT repository; uses `{{ gitops.username }}` from `network.yaml`
- *`GIT_EMAIL`: Email associated with the username above; uses `{{ gitops.email }}` from `network.yaml`
- *`GIT_PASSWORD`: Password (most of the time access token) with write access to the GIT repository; uses `{{ gitops.password }}` from `network.yaml`
- *`GIT_BRANCH`: The name of the current branch, where the Helm releases are pushed; uses `{{ gitops.branch }}` from `network.yaml`
 - `GIT_RESET_PATH`: The path of the GIT repository, which is reset before committing. Default value is `platforms/r3-corda-ent/configuration`
 - `msg` - The commit message to use when pushing deployment files.
