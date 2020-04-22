## ROLE: setup/springboot_services
This role create springboot webserver helm value files for each node.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensures {{ release_dir }}/{{ component_type_name }} dir exists
This task checks whether springboot helm release directory present or not.If not present,creates one.
##### Input Variables
  
    path: The path where to check is specified here
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory.

#### 2. "create value file for {{ component_type_name }} {{ type }}"
This task creates helm release value files for each node
##### Input Variables
    *component_type_name: type of resource, fetched from network.yaml
    component_name: name of the resource, contains hardoded name 'node'
    type: type of resource, contains hardcoded value type 'node'
    *values_file: path where the generated value file are getting pushed
    *config: contains configuration item
    *vault_addr: address of the vault, fetched from network.yaml

#### Note:
 vars folder has enviornment variable for springboot_services role. Templates folder has tpl files for web. Any change to be reflected in the final value file then this tpl file inside template folder needs to be updated accordingly.
