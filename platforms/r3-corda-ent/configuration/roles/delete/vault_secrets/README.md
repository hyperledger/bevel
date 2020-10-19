## ROLE: `delete/vault_secrets`
This role deletes the Vault configurations & secrets.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

---

#### 1. Delete docker creds
This task deletes Docker credentials.
##### Input Variables
- `kind` - The kind of component to delete, in this case `Secret`
- `*namespace` - The namespace in which the secrets are created
- `name` - The name of the secret, in this case `regcred`
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of the K8s cluster
- `*context` -  The context of the K8s cluster

**ignore_errors**: This flag ignores any errors and proceeds further.

---

#### 2. Delete Ambassador creds for idman
This task deletes Ambassador credentials for idman
##### Input Variables
- `kind` - The kind of component to delete, in this case `Secret`
- `*namespace` - The namespace in which the secrets are created
- `*name` - The name of the secret, in this case `{{ org.services.idman.name }}-ambassador-certs`
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of the K8s cluster
- `*context` - The context of the K8s cluster

**when**: runs this task when the `org.type == 'cenm'` 

**ignore_errors**: This flag ignores any errors and proceeds further.

---

#### 3. Delete Ambassador creds for networkmap
This task deletes Ambassador credentials for networkmap
##### Input Variables
- `kind` - The kind of component to delete, in this case `Secret`
- `*namespace` - The namespace in which the secrets are created
- `*name` - The name of the secret, in this case `{{ org.services.networkmap.name }}-ambassador-certs`
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of the K8s cluster
- `*context` - The context of the K8s cluster

**when**: runs this task when the `org.type == 'cenm'` 

**ignore_errors**: This flag ignores any errors and proceeds further.

---

#### 4. Delete Ambassador creds for notary
This task deletes Ambassador credentials for notary
##### Input Variables
- `kind` - The kind of component to delete, in this case `Secret`
- `*namespace` - The namespace in which the secrets are created
- `*name` - The name of the secret, in this case `{{ org.services.notary.name }}-ambassador-certs`
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of the K8s cluster
- `*context` - The context of the K8s cluster

**when**: runs this task when the `org.type == 'cenm'` 

**ignore_errors**: This flag ignores the any errors and proceeds further.

---

#### 5. Delete Ambassador creds for each peer of all nodes
This task deletes Ambassador credentials for each peer of all nodes
##### Input Variables
- `kind` - The kind of component to delete, in this case `Secret`
- `*namespace` - The namespace in which the secrets are created
- `*name` - The name of the secret, in this case `{{ peer.name }}-ambassador-certs`
- `state` - absent (this deletes any found result)
- `*kubeconfig` - The config file of the K8s cluster
- `*context` - The context of the K8s cluster

**when**: runs this task when the `org.type == 'node'` 

**ignore_errors**: This flag ignores any errors and proceeds further.

---

#### 6. Delete vault-auth path for organization
This task deletes Vault auth path for an organization
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
- `org_name` - The name of the organization of which to delete the Vault path

**ignore_errors**: This flag ignores any errors and proceeds furthur.

---

#### 7. Delete Crypto for CENM
This task disables the secret path for the CENM from Vault.
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
- *`org.name` - The name of the organization, fetched from `network.yaml`

---

#### 8. Delete Crypto materials for CENM
This task deletes the crypto materials for the CENM from Vault on the previously disabled path.
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
- *`org.services` - The services of that organization, fetched from `network.yaml`
**shell** : This command deletes the crypto for CENM.

---

#### 9. Delete Crypto materials for nodes
This task deletes the crypto materials for each of the nodes from Vault on the previously disabled path.
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
- *`org.services` - The services of that organization, fetched from `network.yaml`
**shell** : This command deletes the crypto for CENM.

---

#### 10. Delete Crypto for nodes
This task disables the secret path for each of the nodes from Vault.
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
- *`org.name` - The name of the organization, fetched from `network.yaml`

---

#### 11. Delete vault access control policy
This task deletes the Vault policy for the organization from Vault.
##### Input Variables
- `*VAULT_ADDR` - Contains Vault URL, fetched from the `network.yaml`
- `*VAULT_TOKEN` - Contains Vault root token, fetched from the `network.yaml`
