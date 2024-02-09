[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for R3 Corda components

## About
This folder contains the helm charts which are used for the deployment of the R3 Corda components. Each helm chart that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS is fully supported.

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
  helm dependency update corda-init
  helm dependency update corda-network-service
  helm dependency update corda-node
  ```

### _Without Proxy or Vault_

```bash
helm install init ./corda-init --namespace supplychain-ns --create-namespace --values ./values/noproxy-and-novault/init.yaml

# Install doorman and network-map services
helm install supplychain ./corda-network-service --namespace supplychain-ns --values ./values/noproxy-and-novault/network-service.yaml
# Install a notary service
helm install notary ./corda-node --namespace supplychain-ns --values ./values/noproxy-and-novault/notary.yaml

```
### To setup another node in a different namespace

```bash
# Run init for new namespace
helm install init ./corda-init --namespace manufacturer-ns --create-namespace --values ./values/noproxy-and-novault/init.yaml
# Install a Corda node
helm install manufacturer ./corda-node --namespace manufacturer-ns --values ./values/noproxy-and-novault/node.yaml
```

### _With Ambassador proxy and Vault_
Replace the `global.vault.address`, `global.cluster.kubernetesUrl` and `global.proxy.externalUrlSuffix` in all the files in `./values/proxy-and-vault/` folder. Also update the `nodeConf.networkMapURL` and `nodeConf.doormanURL` as per your `global.proxy.externalUrlSuffix` of corda-network-service.

```bash
kubectl create namespace supplychain-ns # if the namespace does not exist already
# Create the roottoken secret
kubectl -n supplychain-ns create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm install init ./corda-init --namespace supplychain-ns --values ./values/proxy-and-vault/init.yaml

# Install doorman and network-map services
helm install supplychain ./corda-network-service --namespace supplychain-ns --values ./values/proxy-and-vault/network-service.yaml
# Install a notary service
helm install notary ./corda-node --namespace supplychain-ns --values ./values/proxy-and-vault/notary.yaml

```
### To setup another node in a different namespace

Update the `global.proxy.externalUrlSuffix` and `nodeConf.legalName` in file `./values/proxy-and-vault/node.yaml` or pass via helm command line.
```bash
# Get the init and static nodes from existing member and place in corda-init/files
cd ./corda-init/files/
kubectl --namespace supplychain-ns get secret nms-tls-certs -o jsonpath='{.data.tls\.crt}' > nms.crt
kubectl --namespace supplychain-ns get secret doorman-tls-certs  -o jsonpath='{.data.tls\.crt}' > doorman.crt

# Run secondary init
cd ../..
kubectl create namespace manufacturer-ns # if the namespace does not exist already
# Create the roottoken secret
kubectl -n manufacturer-ns create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm install init ./corda-init --namespace manufacturer-ns --values ./values/proxy-and-vault/init-sec.yaml

helm install manufacturer ./corda-node --namespace manufacturer-ns --values ./values/proxy-and-vault/node.yaml --set nodeConf.legalName="O=Manufacturer\,OU=Manufacturer\,L=47.38/8.54/Zurich\,C=CH"
```

### Clean-up

To clean up, just uninstall the helm releases.
```bash
helm uninstall --namespace supplychain-ns notary
helm uninstall --namespace supplychain-ns supplychain
helm uninstall --namespace supplychain-ns init

helm uninstall --namespace manufacturer-ns manufacturer
helm uninstall --namespace manufacturer-ns init

```