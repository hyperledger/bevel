[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## create/webserver
This role generates Helm release of Indy WebServer, which is used for Identity App demo.

## Tasks:
### 1. Check if Indy node are running
This task checking if all of Indy nodes are running.
This task calls role from *{{ playbook_dir }}/../../../platforms/shared/configuration/roles/check/helm_component*
#### Input Variables:
 - namespace: The namespace where this component will be searched.
 - component_type: Set which type of k8s component needs to be checked. Default a value *Pod*.
 - component_name: Name of component, which it may check. It uses a {{ organization.name }}-{{ steward.name }}-node, which is represented of name of node
 - label_selectors: Array of label_selectors that will be applied to the search.
### 2. Create Indy WebServer value file
This task create a value file for Helm release of Indy WebServer.
This task calls role from *create/helm_component*
#### Input Variables:
 - type: Represents type of which helm chart will be used. By default is used `webserver`.
 - charts_dir: A path of directory where are stored helm charts. By default for example application is used `examples/identity-app/charts`.
 - component_name: A name of web server by name of current organization.
 - component_port: A port which will be used for the WebServer.
 - trustee_name: A name of current trustee service.
 - service_account: A name of service account to authorization to vault.
 - auth_method_path: A path of auth_method in vault.
### 3. Push the created deployment files to repository
This task pushes generated Helm releases into remote branch.
This task calls role from: *{{ playbook_dir }}/../../shared/configuration/roles/git_push*
#### Input Variables:
 - GIT_DIR: A path of git directory. By default "{{ playbook_dir }}/../../../"
 - GIT_RESET_PATH: A path of git directory, which is reseted for committing. Default value is *platforms/hyperledger-indy/configuration*
 - gitops: *item.gitops* from network.yaml
 - msg: A commit message.
### 5. Wait until Indy WebServer will be up
This task is waiting until Indy WebServer pods will be up.
This task calls role from *{{ playbook_dir }}/../../../platforms/shared/configuration/roles/check/helm_component*
#### Input Variables:
 - namespace: The namespace where this component will be searched.
 - component_name: Name of component, which it may check. It uses a {{ organization.name }}-webserver, which is represented of name of WebServer
 - component_type: Set, which type of k8s component may be created. Default a value *Pod*. 
 - label_selectors: Array of label_selectors that will be applied to the search.