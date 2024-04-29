[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for R3 Corda Enterprise components

## About
This folder contains the helm charts which are used for the deployment of the R3 Corda Enterprise components. Each helm chart that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS is fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://yourkubernetes.com" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: corda   # must be corda for these charts
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
  helm dependency update enterprise-init
  helm dependency update cenm
  helm dependency update enterprise-node
  helm dependency update cenm-networkmap
  ```

### _Without Proxy or Vault_

```bash
helm install init ./enterprise-init --namespace supplychain-ent --create-namespace --values ./values/noproxy-and-novault/init.yaml

# Install cenm services : Zone, Auth, Gateway, Idman and Signer
helm install cenm ./cenm --namespace supplychain-ent --values ./values/noproxy-and-novault/cenm.yaml

# Install the inital set of notary nodes
helm install notary ./enterprise-node --namespace supplychain-ent --values ./values/noproxy-and-novault/notary.yaml

# Install cenm services : Networkmap service
helm install networkmap ./cenm-networkmap --namespace supplychain-ent --values ./values/noproxy-and-novault/cenm.yaml

# Install cenm services : Networkmap service
helm install node ./enterprise-node --namespace supplychain-ent --values ./values/noproxy-and-novault/node.yaml

```
### To setup another node in a different namespace

```bash
# Run init for new namespace
helm install init ./enterprise-init --namespace manufacturer-ent --create-namespace --values ./values/noproxy-and-novault/init.yaml

# This step is an operator task, where the network operator provides the network-root-truststore.jks file and its passwords

mkdir -p ./enterprise-node/build

kubectl get secret -n supplychain-ent cenm-certs -o jsonpath="{.data.network\-root\-truststore\.jks}" | base64 --decode > ./enterprise-node/build/network-root-truststore.jks

kubectl create secret generic -n manufacturer-ent cenm-certs --from-file=network-root-truststore.jks=./enterprise-node/build/network-root-truststore.jks

# Update the ./values/noproxy-and-novault/node.yaml with the given truststore password at network.creds.truststore

# Install a Corda node
helm install manufacturer ./enterprise-node --namespace manufacturer-ent --values ./values/noproxy-and-novault/node.yaml
```

### _With Ambassador proxy and Vault_
TODO

### To setup another node in a different namespace
TODO

### Clean-up

To clean up, just uninstall the helm releases.
```bash
helm uninstall --namespace supplychain-ent node
helm uninstall --namespace supplychain-ent notary
helm uninstall --namespace supplychain-ent cenm
helm uninstall --namespace supplychain-ent networkmap
helm uninstall --namespace supplychain-ent init

helm uninstall --namespace manufacturer-ent manufacturer
helm uninstall --namespace manufacturer-ent init

# Clean up the created namespaces to completly clean up the env.
kubectl delete ns supplychain-ent
kubectl delete ns maunfacturer-ent
```