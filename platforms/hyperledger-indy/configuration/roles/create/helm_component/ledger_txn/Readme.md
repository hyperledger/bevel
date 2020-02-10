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

### 1. Get identity data from vault
This tasks gets the identity data from vault.
It gets the details of admin did, admin verkey as well as the endorser did and the endorser verkey from the vault.

### 2. create value file for {{ new_component_name }} {{ component_type }}
This tasks creates the value file from the template.

#### Input Variables:
 - identity_name: Identity name of endorser.
 - new_component_name: new Identity's organization name.
 - chart: Chart name for NYm ledger transaction
 - auth-path: Kubernetes Auth Path.

#### Template:
 - ledger_txn.tpl
 This is the template used for creating the value file. It replaces the `{{ variable }}` with its values to generate the final value file.
