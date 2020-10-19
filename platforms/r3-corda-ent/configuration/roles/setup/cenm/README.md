## ROLE: `setup/cenm`
This role creates all the necessary files for cenm services and also pushes the generated value file into the GIT repository.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variable: fetched from the playbook which is calling this role)

---

#### 1. "Wait for namespace creation for {{ organisation }}"
This task waits for namespace creation by calling the `shared/configuration/check/k8_component` role - in case this role has been called before the namespace has completely created.
##### Input Variables
- `component_type` - The type of component to wait for, i.e. `Namespace`
- *`component_name` - The name of the namespace to wait for
- `type` - `retry`; the task will wait for X amount of times with an interval of 30 seconds. The retry amount is specified in the `network.yaml`

---

#### 2. "Wait for vault-auth creation for {{ organisation }}"
This task waits for the `vault-auth` ServiceAccount creation by calling the `shared/configuration/check/k8_component` role - in case the current role has been called before the ServiceAccount has completely created.
- `component_type` - The type of component to wait for, i.e. `ServiceAccount`
- *`component_name` - The name of the namespace to wait for, i.e. `vault-auth`
- `type` - `retry`; the task will wait for X amount of times with an interval of 30 seconds. The retry amount is specified in the `network.yaml`

---

#### 3. "Wait for vault-reviewer creation for {{ organisation }}"
This task waits for the `vault-reviewer` ServiceAccount creation by calling the `shared/configuration/check/k8_component` role - in case the current role has been called before the ServiceAccount has completely created.
##### Input Variables
- `component_type` - The type of component to wait for, i.e. `ServiceAccount`
- *`component_name` - The name of the namespace to wait for, i.e. `vault-reviewer`
- `type` - `retry`; the task will wait for X amount of times with an interval of 30 seconds. The retry amount is specified in the `network.yaml`

---

#### 4. "Wait for ClusterRoleBinding creation for {{ organisation }}"
This task waits for the ClusterRoleBinding creation by calling the `shared/configuration/check/k8_component` role - in case the current role has been called before the ClusterRoleBinding has completely created.
##### Input Variables
- `component_type` - The type of component to wait for, i.e. `ServiceAccount`
- *`component_name` - The name of the namespace to wait for, i.e. `vault-reviewer`
- `type` - `retry`; the task will wait for X amount of times with an interval of 30 seconds. The retry amount is specified in the `network.yaml`

---

#### 5. "Setup vault access for cenm"
This task creates Vault access policies for CENM by calling the `setup/vault_kubernetes` role.
##### Input Variables
- *`component_name` - name of resource, fetched from `network.yaml`
- *`component_path` - path of resource, fetched from `network.yaml`
- *`component_auth` - auth of resource, fetched from `network.yaml`
- *`component_type` - organisation type

---

#### 6. Check if the root certs are already created
This task checks if the root PKI certificates are already created and stored in the Vault.
##### Input Variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
##### Output Variables:
- `root_certs` - Stores the status of the certificates in the Vault

**ignore_errors** is set to `yes` because certificates are not created for a fresh network deployment and this command will fail.

---

#### 7. "Generate crypto using pki-generator" 
This task creates all the network certificates by calling the `setup/pki-generator` role.

**when** - It runs when **root_certs.failed** variable is true (when the root certs have not been generated yet)

---

#### 8. "Deploy Signer service"
This task creates the Signer service by calling `setup/signer` role.

---

#### 9. "Deploy Idman service"
This task creates the Idman service by calling `setup/idman` role.

---

#### 10. "Deploy Networkmap service"
This task creates the Networkmap service by calling `setup/nmap` role.

---

#### 11. "Deploy Notary service"
This task creates the Notary service by calling `setup/notary` role.
  