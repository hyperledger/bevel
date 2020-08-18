## create/namespace
This role create value files for namespace.

## Tasks:
### 1. Check namespace is created
This task check if namespace exists in Kubernetes cluster.
It uses k8s_info Ansible role.

#### Variables:
 - component_name: A name of namespace.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes contex from network.yaml file.

#### Output Variables:
 - get_namespace: A variables, which stores status if namespace exists or not.
 
### 2. Create namespaces
This task create a value file of namespace if namespace doesn't exist in Kubernetes cluster.
It calls role *create/k8_component*.

#### Input Variables:
 - component_type: A variable for select, which Kubernetes component may be created. Default value is *namespace*

### 3. Git Push
This task push a value file into remote branch.
It calls role *{{ playbook_dir }}/../../shared/configuration/roles/git_push*

#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_REPO: Url for git repository. It uses a variable *{{ gitops.git_push_url }}* 
 - GIT_USERNAME: Username of git repository. It uses a variable *{{ gitops.username }}*
 - GIT_EMAIL: User's email of git repository. It uses a variable *{{ gitops.email }}*
 - GIT_PASSWORD: User's password of git repository. It uses a variable *{{ gitops.password }}*
 - GIT_BRANCH: A name of branch, where are pushed Helm releases. It uses a variable *{{ gitops.branch }}*
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - msg: A message, which is printed, when the role is running.