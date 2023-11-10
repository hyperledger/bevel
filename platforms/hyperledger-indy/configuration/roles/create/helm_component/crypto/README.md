[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/crypto
This role create the job value file for creating Hyperledger Indy Crypto

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_type: Set, which type of k8s component may be created.
 - component_name: Name of component.

### 2. Trustee crypto generating
This task generate crypto generator job for all trustees in organization.
Value file of Helm release Job is stored.
This task uses template for generating Job.

#### Input Variables:
 - identity_name: Identity name of trustee. It uses a variable *{{ trusteeItem.name }}*
 - vault_path: Path in Vault of this identity. It uses *{{ organization }}.trustees* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*

#### Template:
 - crypto-generate.tpl

### 3. Stewards crypto generating
This task generate crypto generator job for all stewards in organization.
Value file of Helm release Job is stored.
This task uses template for generating Job.

#### Input Variables:
 - identity_name: Identity name of trustee. It uses a variable *{{ stewardsItem.name }}*
 - vault_path: Path in Vault of this identity. It uses *{{ organization }}.stewards* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*

#### Template:
 - crypto-generate.tpl

### 4. Endorser crypto generating
This task generate crypto generator job for all endorsers in organization.
Value file of Helm release Job is stored.
This task uses template for generating Job.

#### Input Variables:
 - identity_name: Identity name of trustee. It uses a variable *{{ endorserItem.name }}*
 - vault_path: Path in Vault of this identity. It uses *{{ organization }}.endorsers* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_type }}/{{ component_name }}/{{ identity_name }}.yaml*
 - chart: A chart name. It uses a variable *{{ chartName }}*

#### Template:
 - crypto-generate.tpl

## Templates:
 - crypto-generate.tpl - A template for creation Kubernetes Job to generate crypto into Vault.

## Vars:
 - crypto: crypto-generate.tpl