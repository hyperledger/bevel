## About
This folder contains the common files as prerequisites used for the deployment of a DLT network using BAF. Please follow instructions in the actual platforms folder for DLT specific setup.

## Folder structure
```
shared
|-- charts: this folder contains the common Helm charts.
|-- configuration: this folder contains the common Ansible playbooks and roles. It also has the single `site.yaml` playbook which is the main playbook to be run to deploy a DLT Platform using BAF.
|-- images: this folder contains the common dockerfiles.
|-- inventory: this folder contains the sample Ansible inventory file.
```
