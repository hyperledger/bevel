[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: setup/nms
This role creates namespace, vault-auth, vault-reviewer, ClusterRoleBinding, certificates, deployments file for networkmap service and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Wait for namespace creation for {{ organisation }}"
This tasks creates namespace for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Namespace' for resource type
    *component_name: Contains component name fetched network.yaml

#### 2. "Wait for vault-auth creation for {{ organisation }}"
This tasks creates vault-auth for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-auth'

#### 3. "Wait for vault-reviewer creation for {{ organisation }}"
This tasks creates vault-reviewer for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-reviewer'

#### 4. "Wait for ClusterRoleBinding creation for {{ organisation }}"
This tasks creates clusterrolebinding for nms by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ClusterRoleBinding' for resource type
    *component_name: Contains name of resource, fetched from network.yaml

#### 5. "Setup vault for nms"
This tasks creates valut access policies for nms by calling setup/vault_kubernetes role.
##### Input Variables

    *component_name: name of resource, fetched from network.yaml
    *component_path: path of resource, fetched from network.yaml
    *component_auth: auth of resource, fetched from network.yaml

#### 6. "Create image pull secret for nms" 
This tasks used to pull the valut secret for nms image by calling create/imagepullsecret role.

#### 7. "Create certificates for nms" 
This tasks creates certificate for nms by calling create/certificates/nms role.
##### Input Variables

    *root_subject: legalName of the organization, fetched from network.yaml
    *cert_subject: legalName of the organization, fetched from network.yaml
    *nms:  legalName of nms organization, fetched from network.yaml

#### 8. "create mongodb for networkmap"
This tasks creates deployment file for nms mongodb node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "mongodb".
    org_name: organization name's.
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository
**when**: *services.nms.tls* == 'off', i.e tls for nms is off.

#### 9. "create mongodb for networkmap"
This tasks creates deployment file for nms mongodb node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "mongodb".
    org_name: organization name's.
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository

**when**: *services.nms.tls* == 'on', i.e tls for nms is on.

#### 10. "create nms"
This tasks creates deployment file for nms node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "nms".
    org_name: organization name's.
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository
**when**: *services.nms.tls* == 'off', i.e tls for nms is off.

#### 11. "create nms"
This tasks creates deployment file for nms node by calling create/k8_component role.
##### Input Variables

    component_name: name of the component
    component_type: type of the component. In this case value is "nms".
    org_name: organization name's.
    helm_lint:  flag value to check/uncheck syntax for helm value files
    *nodename: organization name for nms
    *charts_dir: path to nms charts
    *component_auth: name of the component
    *org: variable contains entire nms component which is being used in role
    *release_dir: path where value files are stored inside repository
**when**: *services.nms.tls* == 'on', i.e tls for nms is on.

#### 12. "Push the created deployment files to repository"
This tasks push the created value files into repository by calling git_push from shared.
##### Input Variables
    GIT_DIR: "The path of directory which needs to be pushed"    
    GIT_RESET_PATH: "This variable contains the path which wont be synced with the git repo"
    gitops: *item.gitops* from network.yaml
    msg: "Message for git commit"
