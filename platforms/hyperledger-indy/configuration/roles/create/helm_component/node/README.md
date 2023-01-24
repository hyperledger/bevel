[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/helm_component/node
This role creates value file for Helm Release of stewards.

## Tasks:
### 1. Ensures {{ release_dir }}/{{ component_name }} dir exists
This task ensure, that release folder for value file exists.
It the folder doesn't exist, then creates them.

#### Variables:
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}
 - gitops: A object, which contains data of organization's gitops from network.yaml file.
 - component_name: A name of component.

### 2. create value file for {{ component_name }} {{ component_type }}
This task creates value file for Helm Release of stewards from template.

#### Variables:
 - component_name: A name of component.
 - component_type: A type of component.
 - release_dir: Release directory, where are stored generated files for gitops. Default value: {{ playbook_dir }}/../../../{{ gitops.release_dir }}

#### Input Variables:
 - values_file: Path for output value file. It uses *{{ release_dir }}/{{ component_name }}/{{ component_type }}.yaml*
 - chart: A name of chart. It uses *indy-node* 
 
#### Template
 - node.tpl

## Templates:
 - node.tpl: A template for generate value file for Helm Release of Stewards

## Vars:
 - node: node.tpl