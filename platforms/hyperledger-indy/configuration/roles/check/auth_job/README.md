## check/auth_job
This role checks all auth jobs completing.

## Tasks:
### 1. Check if Indy  auth job pod for trustee is completed
This task is waiting until auth job of all trustees of organization are completed.
It uses k8s_facts Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of auth job.

#### Input Variables:
 - identity_name: A name of trustee in organization.
 
#### Output Variables:
 - result: It holds number of running pods.

### 2. Check if Indy  auth job pod for stewards is completed
This task is waiting until auth job of all stewards of organization are completed.
It uses k8s_facts Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of auth job.

#### Input Variables:
 - identity_name: A name of steward in organization.
 
#### Output Variables:
 - result: It holds number of running pods.
 
### 3. Check if Indy  auth job pod for endorser is completed
This task is waiting until auth job of all endorsers of organization are completed.
It uses k8s_facts Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of auth job.

#### Input Variables:
 - identity_name: A name of endorser in organization.
 
#### Output Variables:
 - result: It holds number of running pods.
 
### 4. Check if Indy  auth job pod for baf-ac is completed
This task is waiting until auth job of all  organization baf-ac are completed.
baf-ac is tag for read-only token, service account, auth methods and cluster role binding.
It uses k8s_facts Ansible role.

#### Variables:
 - component_ns: A name of namespace' organization.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - component_name: A name of auth job.

#### Input Variables:
 - identity_name: A name of identity. By default is *baf-ac*
 
#### Output Variables:
 - result: It holds number of running pods.
 