#### [ROLE] generate_crypto
This role consists of the following tasks

- **Create directory path on CA Tools for Orderers:**  This task creates directories on CA Tool CLI for placing crypto material and scripts for Orderer.

- **Create directory path on CA Tools for Orgs:**  This task creates directories on CA Tool CLI for placing crypto material and scripts for Organizations.

- **Copy the generate_crypto.sh file into the orderer CA Tools:** This task puts the generate_crypto.sh script into CA Tools CLI for Orderers from Ansible container.

- **Copy the generate_crypto.sh file into the organization CA Tools:** This task puts the generate_crypto.sh script into CA Tools CLI for Organizations from Ansible container.

- **Copy the Orderer CA certificates to the Orderer CA Tools:** This task copies the initial CA certs from Ansible container to the CA Tools CLI for orderer.

- **Copy the Orderer CA certificates to the org CA Tools:** This task copies the initial CA certs from Ansible container to the CA Tools CLI for organizations.

- **Generate crypto material for organization peers:** This task generates the cryto material for the organizations by consuming the generate_crypto.sh script.

- **Generate crypto material for orderer:** This task generates the cryto material for the orderer by consuming the generate_crypto.sh script.

- **Backing up crypto config folder:** This task creates a backup of initial certs in the ansible directory.

- **Copy the crypto config folder from the orderer ca tools:** This task transfer the crypto material from the CA Tools CLI to the ansible container for orderer.

- **Copy the crypto config folder from the org ca tools:** This task transfer the crypto material from the CA Tools CLI to the ansible container for organizations.

- **Create the MSP config.yaml file for orgs:** This task creates NOdeOUs for organization which contain information to tell apart clients, peers and orderers based on OU's. As it is enabled, the MSP will consider an identity valid if it is an identity of a client, a peer or an orderer.

- **Copy the crypto material for orderer:** This task puts the newly generated crypto material to the vault.

- **Copy the crypto material for organizations:** This task puts the newly generated crypto material to the vault.

- **Copy organization level certificates for orderers:** This task puts the organization level certificates for orderer in vault.

- **Copy organization level certificates for orgs:** This task puts the organization level certificates for organizations in the vault.