[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/auth_job
This role create the job value file for creating Vault auth methods

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_type: Set, which type of k8s component may be created.
 - component_name: Name of component.

### 2. Get the kubernetes server url
This role get url address of Kubernetes server and store it into variable.

#### Variables:
 - kubernetes.config_file: Kubernetes config file from network.yaml file.

#### Environment Variables:
 - KUBERNETES_CONFIG_FILE: Kubernetes Config file from network.yaml by a variable *{{ kubernetes.config_file }}*
 
#### Output Variables:
 - kubernetes_server_url: Stored url address of Kubernetes server.

### 3. Trustee vault policy and role generating
This task generate vault policy for all trustees in organization.
Value file of Helm release Job is stored.
This task uses template for generating Job.

#### Input Variables:
 - identity_name: Identity name of trustee. It uses a variable *{{ trusteeItem.name }}*
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*
 - policy_path: A path of policy in Vault.
 - policy_capabilities: Permissions of Vault policy.
 - kubernetes_server: A kubernetes address. It uses a variable *kubernetes_server_url.stdout*

#### Template:
 - auth_job.tpl
### 4. Stewards vault policy and role generating
This task generate vault policy for all stewards in organization.
Value file of Helm release Job is stored.
This task uses template for generating Job.

#### Input Variables:
 - identity_name: Identity name of stewards. It uses a variable *{{ stewardItem.name }}*
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*
 - policy_path: A path of policy in Vault.
 - policy_capabilities: Permissions of Vault policy.
 - kubernetes_server: A kubernetes address. It uses a variable *kubernetes_server_url.stdout*

#### Template:
 - auth_job.tpl

### 5. Endorser vault policy and role generating
This task generate vault policy for all endorsers in organization.
Value file of Helm release Job is stored.
This task usesß template for generating Job.

#### Input Variables:
 - identity_name: Identity name of endorsers. It uses a variable *{{ endorserItem.name }}*
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*
 - policy_path: A path of policy in Vault.
 - policy_capabilities: Permissions of Vault policy.
 - kubernetes_server: A kubernetes address. It uses a variable *kubernetes_server_url.stdout*

#### Template:
 - auth_job.tpl
 
### 6. bevel-ac vault policy and role generating
This task generates bevel-ac vault policy value file.
The bevel-ac vault policy is for read-only data from Vault.

#### Input Variables:
 - identity_name: Identity name of policy. It uses *bevel-ac*
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*
 - policy_path: A path of policy in Vault.
 - policy_capabilities: Permissions of Vault policy.
 - kubernetes_server: A kubernetes address. It uses a variable *kubernetes_server_url.stdout*

#### Template:
 - auth_job.tpl
 
## Templates:
 - auth_job.tpl - A template for creation Kubernetes Job to create auth methods in Vault.
## Vars:
 - auth_job: auth_job.tpl