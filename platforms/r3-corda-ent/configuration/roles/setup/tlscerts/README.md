## ROLE: `setup/tlscerts`
This role fetches the TLS certificates specified at a given path in the `network.yaml` and then pushes them to the Vault of each node organization.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)

(Loop variables are fetched from the playbook which is calling this role)

---

#### 1. Check if the idman tls certificate is already present in the Vault or not
This task checks if the idman TLS certficate is already present in the Vault or not.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- `org.name` - The name of the node organisation
- `peer.name` - The name of the peer
- `service.name` - The name of the service
##### Output variables
- `vault_tlscert` - Variable that stores the result of the command (`vault_tlscert.failed` will be `true` when the certs do not exist yet)

---

#### 2. Copy the tls certificate to each peer Vault
This task will copy the tls certificates to each of the peer Vault if they do not exist yet.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- `org.name` - The name of the node organisation
- `peer.name` - The name of the peer
- `service.name` - The name of the service

**when** - This task is only called when the idman certificates are not present yet in the Vault (when `vault_tlscert.failed`)

---

#### 3. Check if the networkroottruststore is already present in the given directory
This task checks if the networkroottruststore is already present in the given directory of the `network.yaml`.
##### Input variables
- `path` - The truststore path provided in the service information of the `network.yaml`
##### Output variables
- `file_status` - The status of the file, `file_status.stat.exists` will be `true` if the file exists

---

#### 4. Copy the networkroottruststore to the Vault for each organisation
This task copies the networkroottruststore to the Vault for each organisation.
##### Input variables
- *`VAULT_ADDR` - The Vault address
- *`VAULT_TOKEN` - Vault root/custom token which has the access to the path
- `org.name` - The name of the node organisation
- `peer.name` - The name of the peer

**when** - This task is called when the `service.type == 'networkmap` and when the networkroottruststore is present (`file_status.stat.exists` is `true`)
