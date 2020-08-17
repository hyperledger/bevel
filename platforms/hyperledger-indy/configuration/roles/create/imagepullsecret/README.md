
## create/imagepullsecret
This role creates secret in Kubernetes for pull docker images from repository.

## Tasks:
### 1. Check for ImagePullSecret for {{ organization }}
This task check if secret of organization exists in Kubernetes.
The task uses k8s_info Ansible role.

#### Variables:
 - organization: A name of organization.
 - component_ns: A name of organization's namespace.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - kubernetes.context: Kubernetes contex from network.yaml file.
 
#### Output Variables:
 - secret_present: There is stored, if secret exists.

### 2. Create the docker pull registry secret for {{ component_ns }}
This task create a new secret of organization in Kubernetes cluster, when doesn't exist.

#### Variable:
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_ns: A name of organization's namespace.
 - network.docker.url: Url address of Docker repository. It is defined in network.yaml file.
 - network.docker.username: A username of Docker repository user. It is defined in network.yaml file.
 - network.docker.password: A password of Docker repository user. It is defined in network.yaml file.
 
#### Input Variables:
 - secret_present: A variable, which contains of secret's existence in Kubernetes cluster.