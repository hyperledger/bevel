[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/k8_component
This role creates deployment files for network-map, doorman, mongodb, namespace,storageclass, service accounts and clusterrolebinding. Deployment file for a node is created in a directory with name=nodeName, nodeName is stored in component_name , component_type specifies the type of deployment to be created.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Ensures {{ release_dir_path }} dir exists
This task  create and/or check if the target directory exists.
##### Input Variables

    *component_name: The resource name and target directory name too.
    path: The path to the directory is specified here.
    recurse: Yes/No to recursively check inside the path specified.
    state: Type i.e. directory

#### 2. create {{ component_type }} file for {{ component_name }}
This task creates value file from a template.
##### Input Variables

    *component_type: It specifies the type of deployment to be created.
    *component_name: The resource name and target directory name too.
    values_file: Absolute path of value file for a component_type.

#### 3. Helm lint
This task tests the value file for syntax errors/ missing values by calling role shared/configuration/roles/helm_lint role. 
##### Input Variables

    *helmtemplate_type: Deployment file name.
    *chart_path: Path where charts are present.
    value_file: Exact path to value file.

**when**:  It runs when *helm_lint*==true, i.e. the check for syntax needs to be done for generated value file .

#### Note:
 vars folder has enviornment variable for k8_component role. Templates folder has tpl files for network-map, doorman, mongodb, namespace,storageclass, service accounts and clusterrolebinding. Any change to be reflected in the final value file then these tpl files inside template folder needs to be updated accordingly.
