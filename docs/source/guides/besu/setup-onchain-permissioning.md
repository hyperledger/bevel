[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploy-besu-onchain-permissioning-network"></a>
# Deploy Besu Onchain Permissioning Network

- [Prerequisites](#prerequisites)
- [Steps to achieve Besu OnChain Permissioning](#steps-to-achieve-besu-onchain-permissioning)

<a name = "prerequisites"></a>
## Prerequisites

- Metamask installed.
- Truffle installed.

<a name = "steps-to-achieve-besu-onchain-permissioning"></a>
## Steps to achieve Besu OnChain Permissioning

**Step 1: Configure Besu network configuration file.**

1. Edit the Besu network configuration file. Refer to the [guide](../networkyaml-besu.md) for detailed instructions on editing the file.

2. To enable and use onchain permissioning, set the `network.permissioning.enabled` parameter to `true` in the Besu network configuration file. Below is a sample configuration for reference:

```yaml
--8<-- "platforms/hyperledger-besu/configuration/samples/network-besu.yaml:11:18"
```
    For reference, use sample configuration defined in the [network-besu.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/hyperledger-besu/configuration/samples/network-besu.yaml) file.

**Step 2: Deploy Besu network.**

1. Utilize the [site.yaml](https://github.com/hyperledger/bevel/blob/develop/platforms/shared/configuration/site.yaml) playbook to deploy the Besu network:

    ```bash
    ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-besu-network-configuration-file.yaml"
    ```

**Step 3: Clone contracts and install dependencies.**

1. Clone the permissioning-smart-contracts repository:

    ```bash
    git clone https://github.com/ConsenSys/permissioning-smart-contracts.git
    ```

2. Change the directory to permissioning-smart-contracts:

    ```bash
    cd permissioning-smart-contracts/
    ```

3. Create a `.env` file to store environment variables with values defined based on your network configuration:

   ```env
   # Address of the Node Ingress contract in the genesis (ibftPermissionGenesisFile) file.
   NODE_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000009999

   # Address of the Account Ingress contract in the genesis (ibftPermissionGenesisFile) file.
   ACCOUNT_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000008888

   # Account used to deploy the permissioning contracts and become the first admin account.
   BESU_NODE_PERM_ACCOUNT=<Metamask-Account-Address>

   # Private key of the same account defined above, required to deploy the permissioning contracts.
   BESU_NODE_PERM_KEY=<Metamask-Account-Private-Key>

   # Besu uses the specified node to deploy the contracts, which is the first node in the network.
   BESU_NODE_PERM_ENDPOINT=http://<organization-name>.<external-url-suffix>:<rpc-ambassador-port-number>

   # The chain ID from the genesis (ibftPermissionGenesisFile) file.
   CHAIN_ID=2018

   # Enode URLs of permitted nodes. Specify multiple nodes (Node-1, Node-2, Node-3) as a comma-separated list.
   INITIAL_ALLOWLISTED_NODES=<Enode-Address-Node-1>,<Enode-Address-Node-2>

   # Addresses of initially allowed accounts. Specify multiple accounts as a comma-separated list.
   INITIAL_ALLOWLISTED_ACCOUNTS=<Metamask-Account-1-Address>,<Metamask-Account-2-Address>
   ```

**Step 4: Deploy the contracts.**

Use the following command to deploy the contracts:

```bash
truffle migrate --reset --network besu
```

By following these steps, we will be able to successfully deploy a Besu Onchain Permissioning Network.
Post network bootstrap permissioing smartcontract can be installed. Smartcontract installation steps can be found [here](https://besu.hyperledger.org/en/stable/private-networks/tutorials/permissioning/onchain/#11-clone-the-contracts-and-install-dependencies)


