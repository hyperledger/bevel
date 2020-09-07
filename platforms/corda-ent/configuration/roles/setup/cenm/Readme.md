## ROLE: setup/cenm
This role creates all the necessary files for cenm services and also pushes the generated value file into repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
(Loop variable: fetched from the playbook which is calling this role)
#### 1. "Wait for namespace creation for {{ organisation }}"
This tasks waits for namespace creation by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'Namespace' for resource type
    *component_name: namespace value we are waiting for
    type: "retry"

#### 2. "Wait for vault-auth creation for {{ organisation }}"
This tasks waits for vault-auth SA creation by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-auth'
    type: "retry"

#### 3. "Wait for vault-reviewer creation for {{ organisation }}"
This tasks waits for vault-reviewer creation by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ServiceAccount' for resource type
    component_name: Contains hardcoded value 'vault-reviewer'
    type: "retry"

#### 4. "Wait for ClusterRoleBinding creation for {{ organisation }}"
This tasks waits for clusterrolebinding creation by calling check/k8_component role.
##### Input Variables

    component_type: Contains hardcoded value 'ClusterRoleBinding' for resource type
    *component_name: Contains name of resource, fetched from network.yaml
    type: "retry"

#### 5. "Setup vault access for cenm"
This tasks creates valut access policies for cenm by calling setup/vault_kubernetes role.
##### Input Variables

    *component_name: name of resource, fetched from network.yaml
    *component_path: path of resource, fetched from network.yaml
    *component_auth: auth of resource, fetched from network.yaml
    *component_type: organisation type

#### 6. Check if the root certs are already created
This tasks checks if the pki certificates are already created and stored in the vault
##### Input Variables

    VAULT_ADDR: The vault address
    VAULT_TOKEN: Vault root/custom token which has the access to the path
##### Output Variables:

    root_certs: Stores the status of the certificates in the vault
ignore_errors is yes because certificates are not created for a fresh network deployment and this command will fail.

#### 7. "Generate crypto using pki-generator" 
This tasks creates all the network certificates by calling setup/pki-generator role.
**when**: It runs when **root_certs.failed** variable is true

#### 8. "Deploy Signer service"
This tasks creates the Signer service by calling setup/signer role.

#### 9. "Deploy Idman service"
This tasks creates the Idman service by calling setup/idman role.

#### 10. "Deploy Networkmap service"
This tasks creates the Networkmap service by calling setup/nmap role.

#### 11. "Deploy Notary service"
This tasks creates the Notary service by calling setup/notary role.
  