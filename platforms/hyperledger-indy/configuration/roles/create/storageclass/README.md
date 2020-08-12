## create/storageclass
This role creates a value file of StorageClass

## Tasks:
### 1. Check if storageclass exists
This task check if StorageClass exists in Kubernetes Cluster.
It uses *k8s_info* Ansible role.

#### Variables:
 - storageclass_name: A name of StorageClass.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 
#### Output Variables:
 - storageclass_state: It holds state of StorageClass existence.
 
### 2. Create storageclass
This task creates a value file of StorageClass.
It calls role *create/k8_component*
The value file is created, when StorageClass is missing in Kubernetes cluster.

#### Variable:
 - storageclass_name: A name of StorageClass.
 - organization: A name of organization.

#### Input Variables:
 - component_type: A type of StorageClass. It may be append with provider (AWS, EKS, Minikube)
 - component_type_name: A type for grouping in release dir. By default is *{{ organization }}*
 - release_dir: Release directory, where are stored generated files for gitops. By default is *{{ playbook_dir }}/../../../{{ gitops.release_dir }}*

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
 - msg: A message, which is printed, when the role is running.

### 4. Wait for Storageclass creation for {{ component_name }}
This task is waiting for creation StorageClass.
It calls role *check/k8_component*.
It starts when StorageClass missing in Kubernetes cluster.

#### Variables:
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 
#### Input Variables:
 - component_type: A type of kubernetes component. By default is *StorageClass*
 - kubeconfig: Kubernetes config file from network.yaml file.