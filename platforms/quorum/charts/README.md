[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Quorum components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Quorum components. Each helm that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS is fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://yourkubernetes.com" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: quorum   # must be quorum for these charts
    # Following are necessary only when hashicorp vault is used.
    address: http://vault.url:8200
    authPath: supplychain
    secretEngine: secretsv2
    secretPrefix: "data/supplychain"
    role: vault-role
```

## Usage

### Pre-requisites

- Kubernetes Cluster (either Managed cloud option like EKS or local like minikube)
- Accessible and unsealed Hahsicorp Vault (if using Vault)
- Configured Ambassador AES (if using Ambassador as proxy)
- Update the dependencies
  ```
  helm dependency update quorum-genesis
  helm dependency update quorum-node
  ```


## `Without Proxy and Vault`

### 1. Install Genesis Node
```bash
# Install the genesis node
helm install genesis ./quorum-genesis --namespace supplychain-quo --create-namespace --values ./values/noproxy-and-novault/genesis.yaml
```

### 2. Install Validator Nodes
```bash
# Install validator nodes
helm install validator-1 ./quorum-node --namespace supplychain-quo --values ./values/noproxy-and-novault/validator.yaml
helm install validator-2 ./quorum-node --namespace supplychain-quo --values ./values/noproxy-and-novault/validator.yaml
helm install validator-3 ./quorum-node --namespace supplychain-quo --values ./values/noproxy-and-novault/validator.yaml
helm install validator-4 ./quorum-node --namespace supplychain-quo --values ./values/noproxy-and-novault/validator.yaml
```

### 3. Deploy Member and Tessera Node Pair
```bash
# Deploy Quorum and Tessera node pair
helm install member-1 ./quorum-node --namespace supplychain-quo --values ./values/noproxy-and-novault/txnode.yaml
```

### Setting Up Another Member in a Different Namespace

```bash
# Get the genesis and static nodes from existing member and and place them in the directory 'besu-genesis/files'
cd ./quorum-genesis/files/
kubectl --namespace supplychain-quo get configmap quorum-peers -o jsonpath='{.data.static-nodes\.json}' > static-nodes.json
kubectl --namespace supplychain-quo get configmap quorum-genesis  -o jsonpath='{.data.genesis\.json}' > genesis.json

# Install secondary genesis node
helm install genesis ./quorum-genesis --namespace carrier-quo --values ./values/noproxy-and-novault/genesis-sec.yaml

# Install secondary member node
helm install member-2 ./quorum-node --namespace carrier-quo --values ./values/noproxy-and-novault/txnode-sec.yaml
```

---

## `With Ambassador Proxy and Vault`

### 1. Create Namespace and Secret
```bash
# Create a namespace
kubectl create namespace supplychain-quo

# Create the roottoken secret
kubectl -n supplychain-quo create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>
```

### 2. Install Genesis Node
```bash
# Install the genesis node
helm install genesis ./quorum-genesis --namespace supplychain-quo --values ./values/proxy-and-vault/genesis.yaml
```

### 3. Install Validator Nodes
```bash
# Install validator nodes
helm install validator-1 ./quorum-node --namespace supplychain-quo --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15011
helm install validator-2 ./quorum-node --namespace supplychain-quo --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15012
helm install validator-3 ./quorum-node --namespace supplychain-quo --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15013
helm install validator-4 ./quorum-node --namespace supplychain-quo --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15014
```

### 4. Deploy Member and Tessera Node Pair
```bash
# Deploy Quorum and Tessera node pair
helm install supplychain ./quorum-node --namespace supplychain-quo --values ./values/proxy-and-vault/txnode.yaml --set global.proxy.p2p=15015
```

### Setting Up Another Member in a Different Namespace

```bash
# Get the genesis and static nodes from existing member and and place them in the directory 'quorum-genesis/files'
cd ./quorum-genesis/files/
kubectl --namespace supplychain-quo get configmap quorum-peers -o jsonpath='{.data.static-nodes\.json}' > static-nodes.json
kubectl --namespace supplychain-quo get configmap quorum-genesis  -o jsonpath='{.data.genesis\.json}' > genesis.json

# Create a new namespace
kubectl create namespace carrier-quo

# Create the roottoken secret
kubectl -n carrier-quo create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

# Install secondary genesis node
helm install genesis ./quorum-genesis --namespace carrier-quo --values ./values/proxy-and-vault/genesis-sec.yaml

# Install secondary member node
helm install carrier ./quorum-node --namespace carrier-quo --values ./values/proxy-and-vault/txnode-sec.yaml --set global.proxy.p2p=15016
```

## `API call`

Once your services are deployed, they can be accessed using the domain name provided in your `global.proxy.externalUrlSuffix`.

1. **Retrieve the Source Host for Your Node**

   Run the following command to get the mapping for your node:

   ```bash
   kubectl get mapping --namespace supplychain-quo
   ```

   From the output, copy the source host for your node.

2. **Make HTTP RPC API Calls**

   You can interact with your node using HTTP RPC API calls. Here's an example of how to do it:

   ```bash
   curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://<source-host>
   ```

   Replace `<source-host>` with the source host you copied earlier.

3. **Verify the Node Syncing Status**

   If the node running the JSON-RPC service is syncing correctly, the previous command should return the following:

   ```json
   {
     "jsonrpc" : "2.0",
     "id" : 1,
     "result" : "0x64"
   }
   ```

   This confirms that your node is syncing as expected.

## `Managing IBFT Validators Deployment`

To deploy the proposed validator chart for IBFT, you first need to set up the Quorum DLT network. Below are the steps you can follow:

1. **Deploy Quorum DLT Network**:
   You have two options for deploying the Quorum DLT network:
   
   - **With Vault and Proxy**
   - **Without Vault and Proxy**

   Choose the appropriate method based on your requirements.

2. **Install Validator Chart**:
   Utilize Helm for installing the validator chart. Ensure to adjust values accordingly:

   ```bash
   helm install validator-5 ./quorum-propose-validator --namespace supplychain-quo --values quorum-propose-validator/values.yaml
   ```

   This chart facilitates the addition or removal of validators through majority voting.

3. **Verify Validator Status**:
   Confirm the validator status by executing:

   ```bash
   curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"istanbul_getValidators","params":["latest"],"id":1}' http://<SOURCE-HOST>
   ```
   
	This command retrieves the current list of validators for the latest block.

	Replace `<SOURCE-HOST>` with the appropriate host address.


## `Clean-up`

To clean up, simply uninstall the Helm releases. It's important to uninstall the genesis Helm chart at the end to prevent any cleanup failure.

```bash
helm uninstall --namespace supplychain-quo validator-1
helm uninstall --namespace supplychain-quo validator-2
helm uninstall --namespace supplychain-quo validator-3
helm uninstall --namespace supplychain-quo validator-4
helm uninstall --namespace supplychain-quo validator-5
helm uninstall --namespace supplychain-quo supplychain
helm uninstall --namespace supplychain-quo genesis

helm uninstall --namespace carrier-quo carrier
helm uninstall --namespace carrier-quo genesis
```
