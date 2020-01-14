## create/helm_component/domain_genesis
This role create the config map value file for storing domain genesis for Indy cluster.

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_type }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - component_name: Name of component.

### 2. Generate domain genesis for organization
This task generate domain genesis with data from crypto, which is in Vault.
This task need baf-ac token for getting public data from Vault.
Result is a jsons for each organizations' stewards

#### Variables:
 - ac_vault_tokens - A map of baf-ac tokens, which are stored by organization's name.
 - organization.vault.url - A url address of Vault for a organization.
 - organization.name - An organization name.

#### Output Variables:
 - domain_genesis: A variable, which contains generated domain genesis.

### 3. create value file for {{ component_name }} {{ component_type }}
This task generate config map for domain genesis of Indy cluster.
Value file of Helm release Config Map is stored.
This task uses template for generating Config Map.

#### Input Variables:
 - organization: A name of organization.
 - component_ns: A name of organization's namespace.
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - component_name: A name of config map. It uses *{{ organizationItem.name }}-dtg*
 - domain_genesis_values: A variable, which contains domain genesis. It uses a variable *domain_genesis.stdout* 
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_name }}/{{ component_type }}.yaml*
 - chart: A chart name. Default value is *indy-domain-genesis* 

#### Template:
 - domain-genesis.tpl

## Templates:
 - domain_genesis.tpl: A template for creation Kubernetes ConfigMap to store domain genesis for a cluster.

## Vars:
 - domain_genesis: domain_genesis.tpl