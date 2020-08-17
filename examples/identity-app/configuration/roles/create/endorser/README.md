## create/endorser
This role generates Helm release of Indy Client Endorsers, which is used for Identity App demo.

## Tasks:
### 1. Check if Indy node are running
This task checking if all of Indy nodes are running.
This task calls role from *{{ playbook_dir }}/../../../platforms/shared/configuration/roles/check/helm_component*
#### Input Variables:
 - namespace: The namespace where this component will be searched.
 - component_type: Set which type of k8s component needs to be checked. Default a value *Pod*.
 - component_name: Name of component, which it may check. It uses a {{ organization.name }}-{{ steward.name }}-node, which is represented of name of node
 - label_selectors: Array of label_selectors that will be applied to the search.
### 2. Create Indy Endorser value file
This task create a value file for Helm release of Indy Aries endorser.
This task calls role from *create/helm_component*
#### Input Variables:
 - type: Is the name of the endorser organization. Must be `university` or `employer` as this example is for Faber university.
 - charts_dir: A path of directory where are stored helm charts. By default for example application is used `examples/identity-app/charts`.
 - component_name: A name for the deployment for current organization.
 - service_account: A name of service account to authorization to vault.
 - auth_method_path: A path of auth_method in vault.
### 3. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_REPO: Url for git repository. It uses a variable *{{ gitops.git_push_url }}* 
 - GIT_USERNAME: Username of git repository. It uses a variable *{{ gitops.username }}*
 - GIT_EMAIL: User's email of git repository. It uses a variable *{{ gitops.email }}*
 - GIT_PASSWORD: User's password of git repository. It uses a variable *{{ gitops.password }}*
 - GIT_BRANCH: A name of branch, where are pushed Helm releases. It uses a variable *{{ gitops.branch }}*
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - msg: A commit message.
### 5. Wait until Indy Endorser is u
This task is waiting until Indy endorser pods will be up.
This task calls role from *{{ playbook_dir }}/../../../platforms/shared/configuration/roles/check/helm_component*
#### Input Variables:
 - namespace: The namespace where this component will be searched.
 - component_name: Name of component, which it may check. It uses a {{ organization.name }}-endorser
 - component_type: Set, which type of k8s component may be created. Default a value *Pod*. 
 - label_selectors: Array of label_selectors that will be applied to the search.