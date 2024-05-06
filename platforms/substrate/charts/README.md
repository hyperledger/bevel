[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Substrate components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Substrate components. Each helm that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS and Azure both are fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://yourkubernetes.com" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: substrate   # must be substrate for these charts
    # Following are necesupplychain-subsary only when hashicorp vault is used.
    addresupplychain-subs: http://vault.url:8200
    authPath: supplychain
    secretEngine: secretsv2
    secretPrefix: "data/supplychain"
    role: vault-role
```

## Usage

### Pre-requisites

- Kubernetes Cluster (either Managed cloud option like AKS or local like minikube)
- Accessible and unsealed Hahsicorp Vault (if using Vault)
- Configured Ambassador AES (if using Ambassador as proxy)
- Update the dependencies
  ```
  helm dependency update substrate-genesis
  helm dependency update substrate-node
  helm dependency update dscp-ipfs-node
  ```


## `Without Proxy and Vault`

### 1. Install Genesis 
```bash
# Install the genesis node
helm install genesis ./substrate-genesis --namespace supplychain-subs --create-namespace --values ./values/noproxy-and-novault/genesis.yaml
```

### 2. Install Nodes
```bash
# Install bootnode
helm install validator-1 ./substrate-node --namespace supplychain-subs --values ./values/noproxy-and-novault/node.yaml --set node.isBootnode.enabled=false

helm install validator-2 ./substrate-node --namespace supplychain-subs --values ./values/noproxy-and-novault/node.yaml

helm install validator-3 ./substrate-node --namespace supplychain-subs --values ./values/noproxy-and-novault/node.yaml

helm install validator-4 ./substrate-node --namespace supplychain-subs --values ./values/noproxy-and-novault/node.yaml

helm install    member-1 ./substrate-node --namespace supplychain-subs --values ./values/noproxy-and-novault/node.yaml --set node.role=full
```
## 4. Install IPFS Nodes

**4.1.** Retrieve the `NODE_ID` from the Kubernetes secret:

```bash
NODE_ID=$(kubectl get secret "substrate-node-member-1-keys" --namespace supplychain-subs -o jsonpath="{.data['substrate-node-keys']}" | base64 -d | jq -r '.data.node_id')
```

**4.2.** Now, install the IPFS nodes:

```bash
helm install dscp-ipfs-node-1 ./dscp-ipfs-node --namespace supplychain-subs --values ./values/noproxy-and-novault/ipfs.yaml \
--set config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.supplychain-subs/tcp/4001/p2p/$NODE_ID"
```

### _With Ambassador proxy and Vault_

### 1. Install Genesis 

Replace the `global.vault.address`, `global.cluster.kubernetesUrl` and `global.proxy.externalUrlSuffix` in all the files in `./values/proxy-and-vault/` folder.

```bash
# If the namespace does not exist already
kubectl create namespace supplychain-subs 
# Create the roottoken secret
kubectl -n supplychain-subs create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm install genesis ./substrate-genesis --namespace supplychain-subs --values ./values/proxy-and-vault/genesis.yaml
```
### 2. Install Nodes
```bash
helm install validator-1 ./substrate-node --namespace supplychain-subs --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15051

helm install validator-2 ./substrate-node --namespace supplychain-subs --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15052

helm install validator-3 ./substrate-node --namespace supplychain-subs --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15053

helm install validator-4 ./substrate-node --namespace supplychain-subs --values ./values/proxy-and-vault/validator.yaml --set global.proxy.p2p=15054

helm install    member-1 ./substrate-node --namespace supplychain-subs --values ./values/proxy-and-vault/node.yaml --set node.role=full

```

# Spin up a IPFS nodes

```bash
NODE_ID=$(kubectl get secret "substrate-node-member-1-keys" --namespace supplychain-subs -o jsonpath="{.data['substrate-node-keys']}" | base64 -d | jq -r '.data.node_id')
```

```bash
helm install dscp-ipfs-node-1 ./dscp-ipfs-node --namespace supplychain-subs --values ./values/proxy-and-vault/ipfs.yaml \
--set config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.supplychain-subs/tcp/4001/p2p/$NODE_ID"
```

## Clean-up

To clean up, simply uninstall the Helm releases. It's important to uninstall the genesis Helm chart at the end to prevent any cleanup failure.
```bash
helm uninstall validator-1      --namespace supplychain-subs
helm uninstall validator-2      --namespace supplychain-subs
helm uninstall validator-3      --namespace supplychain-subs
helm uninstall validator-4      --namespace supplychain-subs
helm uninstall member-1         --namespace supplychain-subs
helm uninstall dscp-ipfs-node-1 --namespace supplychain-subs
helm uninstall genesis          --namespace supplychain-subs
```
