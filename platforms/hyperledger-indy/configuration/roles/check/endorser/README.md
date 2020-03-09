## check/endorser
This role is used for waiting to job of Endorser role creation finished.

## Tasks:
### 1. Check if endorser job pod is completed for organization {{ component_name }}
This task is waiting until endorser job pod of organization are completed.
It uses k8s_facts Ansible role.

#### Variables:
 - endorserItem.name: A name of Endorser service.
 - endorsers: A list of Endorser Services in Organization.
 - component_name: A name of component.
 - component_ns: A name of Organization's namespace.
 - kubernetes.config_file: Kubernetes config file from network.yaml file.
 - network.env.retry_count: A repeat wait count.

#### Output Variables:
 - result.resources: It holds number of successful completed kubernetes components.