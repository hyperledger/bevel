[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/ledger_txn
This role create the job value file for Indy NYM ledger transactions

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_type: Set, which type of k8s component may be created.
 - component_name: Name of component.

### 2. Create HelmRelease file
This role calls a nested role for HelmRelease Template generation.

#### Variables:
 - identity_name: Name to Identity(Endorser) for which the value file generated.
 - admin_name: AdminIdentity name.
 - role: Auth role for the new Identity to be added.

--------------------------------------------------------------------------------
### nested_main.

### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists

### 2. Get identity data from vault
This task gets the identity data from vault.
It gets the details of admin did, admin verkey as well as the endorser did and the endorser verkey from the vault.

### 3. Inserting file into Variable
This task inserts generated yaml file into a variable.
#### Input Variables:
 - data.yaml: A yaml file, which consists of identity data.
#### Output Variables:
 - file_var: A yaml file, which consists of identity data.

### 4. create value file for {{ new_component_name }} {{ component_type }}
This task creates the value file from the template.

#### Input Variables:
 - identity_name: Identity name of endorser.
 - new_component_name: new Identity's organization name.
 - chart: Chart name for NYm ledger transaction
 - auth-path: Kubernetes Auth Path.

#### Template:
 - ledger_txn.tpl
 This is the template used for creating the value file. It replaces the `{{ variable }}` with its values to generate the final value file.

### 5. Delete file
This task removes yaml file, which constits of identity data.
#### Input Variables:
- data.yaml: A yaml file, which consists of identity data.

### 6. Helm lint
This task tests the value file for syntax errors/ missing values
#### Input Variables:
 - playbook_dir: A path of playbook directory.
 - component_type: A type of component, which will be generated.
 - gitops.chart_source: A path of directory where are charts stored.
 - new_component_name: A name of component.
 - identity_name: A name of identity.
#### Variables:
 - helmtemplate_type: A type of component, which will be generated.
 - chart_path: A path of directory where are charts stored.
 - value_file: A path of generated value file.