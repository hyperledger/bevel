[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Hyperledger Indy components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Indy components. Each helm chart that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features to be enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS ans Azure is fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws | azure | gcp
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://kubernetes.url" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: indy   # must be indy for these charts
    # Following are necessary only when hashicorp vault is used.
    address: "http://vault.url:8200"
    authPath: authority
    secretEngine: secretsv2
    secretPrefix: "data/authority"
    role: vault-role
```

## Usage

### Pre-requisites

- Kubernetes Cluster (either Managed cloud option like EKS or local like minikube)
- Accessible and unsealed Hahsicorp Vault (if using Vault)
- Configured Ambassador AES (if using Ambassador as proxy)
- Update the dependencies
  ```
  helm dependency update indy-key-mgmt
  helm dependency update indy-node
  ```

### _Without Proxy or Vault_

> **Important:** As Indy nodes need IP Address, the no-proxy option works only with minikube or cluster with 1 node in nodepool.

Replace the `publicIp` in all the files in `./values/noproxy-and-novault/` folder with the IP address of your Minikube or the single node in your Cloud Cluster.

For Indy, the keys need to be created first for each organisation
```bash
# Create keys for first trustee
helm install authority-keys ./indy-key-mgmt --namespace authority-ns --create-namespace --values ./values/noproxy-and-novault/authority-keys.yaml
# Create keys for endorser and stewards from another org namespace
helm install university-keys ./indy-key-mgmt --namespace university-ns --create-namespace --values ./values/noproxy-and-novault/university-keys.yaml

# Get the public keys from Kubernetes for genesis
cd ../scripts/genesis
chmod +x get_keys.sh
./get_keys.sh

cd ../../charts
# Update the IP address and Ports in ./values/noproxy-and-novault/genesis.yaml
helm install genesis ./indy-genesis --namespace authority-ns --values ./values/noproxy-and-novault/genesis.yaml

# Get the genesis files from existing authority and place in indy-genesis/files
cd ./indy-genesis/files/
kubectl --namespace authority-ns get configmap dtg -o jsonpath='{.data.domain_transactions_genesis}' > domain_transactions_genesis.json
kubectl --namespace authority-ns get configmap ptg  -o jsonpath='{.data.pool_transactions_genesis}' > pool_transactions_genesis.json

# Run secondary genesis
cd ../..
helm install genesis ./indy-genesis --namespace university-ns --values ./values/noproxy-and-novault/genesis-sec.yaml

# Then deploy the stewards
helm install university-steward-1 ./indy-node --namespace university-ns --values ./values/noproxy-and-novault/steward.yaml
helm install university-steward-2 ./indy-node --namespace university-ns --values ./values/noproxy-and-novault/steward.yaml --set settings.node.externalPort=30021 --set settings.client.externalPort=30022 --set settings.node.port=30021 --set settings.client.port=30022
helm install university-steward-3 ./indy-node --namespace university-ns --values ./values/noproxy-and-novault/steward.yaml --set settings.node.externalPort=30031 --set settings.client.externalPort=30032 --set settings.node.port=30031 --set settings.client.port=30032

# Get endorser public keys
cd ./indy-register-identity/files
kubectl --namespace university-ns get secret university-endorser-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> university-endorser-did.json
kubectl --namespace university-ns get secret university-endorser-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > university-endorser-verkey.json
# Register the endorser identity using the trustee's credentials
# Deploy the endorser identity registration Helm chart in the authority namespace, where the trustee resides
cd ../..
helm install university-endorser-id ./indy-register-identity --namespace authority-ns
```

### _With Ambassador proxy and Vault_
Replace the `global.vault.address`, `global.cluster.kubernetesUrl` and `publicIp` of your Ambassador Loadbalancer in all the files in `./values/proxy-and-vault/` folder.

For Indy, the keys need to be created first for each organisation
```bash
kubectl create namespace authority-ns # if the namespace does not exist already
# Create the roottoken secret
kubectl -n authority-ns create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

kubectl create namespace university-ns # if the namespace does not exist already
# Create the roottoken secret
kubectl -n university-ns create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

# Create keys for first trustee
helm install authority-keys ./indy-key-mgmt --namespace authority-ns --values ./values/proxy-and-vault/authority-keys.yaml
# Create keys for endorser and stewards from another org namespace
helm install university-keys ./indy-key-mgmt --namespace university-ns --values ./values/proxy-and-vault/university-keys.yaml

# Get the public keys from Kubernetes for genesis
cd ../scripts/genesis
chmod +x get_keys.sh
./get_keys.sh

cd ../../charts
# Update the IP address and Ports in ./values/proxy-and-vault/genesis.yaml
helm install genesis ./indy-genesis --namespace authority-ns --values ./values/proxy-and-vault/genesis.yaml

# Get the genesis files from existing authority and place in indy-genesis/files
cd ./indy-genesis/files/
kubectl --namespace authority-ns get configmap dtg -o jsonpath='{.data.domain_transactions_genesis}' > domain_transactions_genesis.json
kubectl --namespace authority-ns get configmap ptg  -o jsonpath='{.data.pool_transactions_genesis}' > pool_transactions_genesis.json

# Run secondary genesis
cd ../..
helm install genesis ./indy-genesis --namespace university-ns --values ./values/proxy-and-vault/genesis-sec.yaml

# Then deploy the stewards
helm install university-steward-1 ./indy-node --namespace university-ns --values ./values/proxy-and-vault/steward.yaml
helm install university-steward-2 ./indy-node --namespace university-ns --values ./values/proxy-and-vault/steward.yaml --set settings.node.externalPort=15021 --set settings.client.externalPort=15022
helm install university-steward-3 ./indy-node --namespace university-ns --values ./values/proxy-and-vault/steward.yaml --set settings.node.externalPort=15031 --set settings.client.externalPort=15032
helm install university-steward-4 ./indy-node --namespace university-ns --values ./values/proxy-and-vault/steward.yaml --set settings.node.externalPort=15041 --set settings.client.externalPort=15042

# Get endorser public keys
cd ./indy-register-identity/files
kubectl --namespace university-ns get secret university-endorser-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> university-endorser-did.json
kubectl --namespace university-ns get secret university-endorser-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > university-endorser-verkey.json
# Register the endorser identity using the trustee's credentials
# Deploy the endorser identity registration Helm chart in the authority namespace, where the trustee resides
cd ../..
helm install university-endorser-id ./indy-register-identity --namespace authority-ns
```

### Clean-up

To clean up, simply uninstall the Helm charts. 
> **NOTE**: It's important to uninstall the genesis Helm chart at the end to prevent any cleanup failure.

```bash
helm uninstall --namespace university-ns university-steward-1
helm uninstall --namespace university-ns university-steward-2
helm uninstall --namespace university-ns university-steward-3
helm uninstall --namespace university-ns university-steward-4
helm uninstall --namespace university-ns university-keys
helm uninstall --namespace university-ns genesis

helm uninstall --namespace authority-ns university-endorser-id
helm uninstall --namespace authority-ns authority-keys
helm uninstall --namespace authority-ns genesis
```
