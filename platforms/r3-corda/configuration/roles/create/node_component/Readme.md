## ROLE: create/node-component
This role creates the job value file for notaries and nodes

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensures {{ release_dir }}/{{ component_name }} dir exists
This task  create and/or check if the target directory exists.
##### Input Variables

    *component_name: The resource name and target directory name too.
    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.

#### 2. create value file for {{ component_name }} {{ component_type }}
This task creates value file from a template.
##### Input Variables

    *component_type: It specifies the type of deployment to be created.
    *component_name: The resource name and target directory name too.
    values_file: Absolute path of value file for a node.

**when**:  It runs when *node_type*==notary, i.e. creates deployment file for notaries .

#### 3. create value file for {{ component_name }} {{ component_type }}
This task creates value file from a template.
##### Input Variables

    *component_type: It specifies the type of deployment to be created.
    *component_name: The resource name and target directory name too.
    values_file: Absolute path of value file for a node.

**when**:  It runs when *node_type*==node, i.e. creates deployment file for nodes .

#### 3. Helm lint
This task tests the value file for syntax errors/ missing values by calling role shared/configuration/roles/helm_lint role. 
##### Input Variables

    *helmtemplate_type: Deployment file name.
    chart_path: Path where charts are present.
    value_file: Exact path to value file.

**when**:  It runs when *helm_lint*==true, i.e. the check for syntax needs to be done for generated value file .

#### Note:
 vars folder has enviornment variable for node_component role. Templates folder has tpl files for h2, node and job. Any change to be reflected in the final value file then these tpl files inside template folder needs to be updated accordingly.