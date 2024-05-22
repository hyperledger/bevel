[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Hyperledger Fabric components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Fabric components. Each helm that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS is fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://yourkubernetes.com" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: fabric  # must be fabric for these charts
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
- Configured Haproxy  (if using Haproxy as proxy)
- Update the dependencies
  ```
  helm dependency update fabric-ca-server
  helm dependency update fabric-orderernode
  helm dependency update fabric-peernode
  ```

### _Without Proxy or Vault_

### To setup Orderer organization
```bash
kubectl create namespace supplychain-net 

helm install supplychain-ca ./fabric-ca-server --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/ca-server.yaml
```

Configure `settings.generateCertificates` field with value `true` for the generation of the cryptographic materials. This value should only be set to `true` in first orderer to be installed and `false` in the others.

```bash
# Install the Orderers
helm install orderer1 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/orderer.yaml --set settings.generateCertificates=true
helm install orderer2 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/orderer.yaml
helm install orderer3 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/orderer.yaml
```

**Note** The orderers will remain waiting in the `Init` state in the deployment of fabric 2.2.2, until we install the `fabric-genesis` chart.

### To setup Peer organization

```bash
kubectl create namespace carrier-net 

helm install carrier-ca ./fabric-ca-server --namespace carrier-net --values ./values/noproxy-and-novault/peerOrganization/ca-server.yaml
```
Configure `settings.generateCertificates` field with value `true` for the generation of the cryptographic materials. This value should only be set to `true` in first peer to be installed and `false` in the others.

```bash
# To use a custom peer configuration, copy core.yaml file into ./fabric-peernode/files
# This step is optional
cp /home/bevel/build/peer0-core.yaml ./fabric-peernode/files

# Get the Orderer tls certificate and place in fabric-catools/files
cd ./fabric-catools/files
kubectl --namespace supplychain-net get configmap orderer-tls-cacert -o jsonpath='{.data.cacert}' > orderer.crt

# Before installing, we must use the dependencies again, due to the addition of the file in the files folder
cd ../..
helm dependency update fabric-peernode

# Install the Peers
helm install peer0-carrier ./fabric-peernode --namespace carrier-net --values ./values/noproxy-and-novault/peerOrganization/peer.yaml --set settings.generateCertificates=true
```

### Generate genesis file
```bash
# Obtain certificates and the configuration file of each peer organization, place in fabric-genesis/files
cd ./fabric-genesis/files
kubectl --namespace carrier-net get configmap admin-msp -o json > carrier.json
kubectl --namespace carrier-net get configmap msp-config-file -o json > carrier-config-file.json

# Install Genesis
cd ../..
helm install genesis ./fabric-genesis --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/genesis.yaml
```

### Create channel for Hyperledger Fabric 2.5.4
```bash
# Install create channel
helm install allchannel ./fabric-osnadmin-channel-create --namespace supplychain-net --values ./values/noproxy-and-novault/ordererOrganization/osn-create-channel.yaml

# Install join channel and anchorpeer
helm install peer0-carrier-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/noproxy-and-novault/peerOrganization/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### Create channel for Hyperledger Fabric 2.2.2
```bash

# Obtain the file channel.tx and place it in fabric-channel-create/files
kubectl --namespace supplychain-net get configmap channel-artifacts-allchannel -o json > channel.tx.json

# Install create channel
helm install allchannel ./fabric-channel-create --namespace carrier-net --values ./values/noproxy-and-novault/peerOrganization/create-channel.yaml

# Get the file anchors.tx and place it in fabric-channel-join/files
kubectl --namespace supplychain-net get configmap anchorpeer-artifacts-allchannel -o json > anchors.tx.json

# Install join channel and anchorpeer
helm install peer0-carrier-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/noproxy-and-novault/peerOrganization/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### _With Haproxy proxy and Vault_

### To setup Orderer organization

Replace the `global.vault.address`, `global.cluster.kubernetesUrl` and `global.proxy.externalUrlSuffix` in all the files in `./values/proxy-and-vault/` folder.

```bash
kubectl create namespace supplychain-net 

kubectl -n supplychain-net create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm install supplychain-ca ./fabric-ca-server --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/ca-server.yaml
```

Configure `settings.generateCertificates` field with value `true` for the generation of the cryptographic materials. This value should only be set to `true` in first orderer to be installed and `false` in the others.

```bash
# Install the Orderers
helm install orderer1 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/orderer.yaml --set settings.generateCertificates=true
helm install orderer2 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/orderer.yaml
helm install orderer3 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/orderer.yaml
```

**Note** The orderers will remain waiting in the `Init` state in the deployment of fabric 2.2.2, until we install the `fabric-genesis` chart.

### To setup Peer organization

```bash
kubectl create namespace carrier-net 

kubectl -n carrier-net create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm install carrier-ca ./fabric-ca-server --namespace carrier-net --values ./values/proxy-and-vault/peerOrganization/ca-server.yaml 

```
Configure `settings.generateCertificates` field with value `true` for the generation of the cryptographic materials. This value should only be set to `true` in first peer to be installed and `false` in the others.

```bash
# To use a custom peer configuration, copy core.yaml file into ./fabric-peernode/files
# This step is optional
cp /home/bevel/build/peer0-core.yaml ./fabric-peernode/files

# Get the Orderer tls certificate and place in fabric-catools/files
cd ./fabric-catools/files
kubectl --namespace supplychain-net get configmap orderer-tls-cacert -o jsonpath='{.data.cacert}' > orderer.crt

# Before installing, we must use the dependencies again, due to the addition of the file in the files folder
cd ../..
helm dependency update fabric-peernode

# Install the Peers
helm install peer0-carrier ./fabric-peernode --namespace carrier-net --values ./values/proxy-and-vault/peerOrganization/peer.yaml --set settings.generateCertificates=true
```

### Generate genesis file
```bash
# Obtain certificates and the configuration file of each peer organization, place in fabric-genesis/files
cd ./fabric-genesis/files
kubectl --namespace carrier-net get configmap admin-msp -o json > carrier.json
kubectl --namespace carrier-net get configmap msp-config-file -o json > carrier-config-file.json

# Install Genesis
cd ../..
helm install genesis ./fabric-genesis --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/genesis.yaml
```

### Create channel for Hyperledger Fabric 2.5.4
```bash
# Install create channel
helm install allchannel ./fabric-osnadmin-channel-create --namespace supplychain-net --values ./values/proxy-and-vault/ordererOrganization/osn-create-channel.yaml

# Install join channel and anchorpeer
helm install peer0-carrier-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/proxy-and-vault/peerOrganization/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### Create channel for Hyperledger Fabric 2.2.2
```bash

# Obtain the file channel.tx and place it in fabric-channel-create/files
kubectl --namespace supplychain-net get configmap channel-artifacts-allchannel -o json > channel.tx.json

# Install create channel
helm install allchannel ./fabric-channel-create --namespace carrier-net --values ./values/proxy-and-vault/peerOrganization/create-channel.yaml

# Get the file anchors.tx and place it in fabric-channel-join/files
kubectl --namespace supplychain-net get configmap anchorpeer-artifacts-allchannel -o json > anchors.tx.json

# Install join channel and anchorpeer
helm install peer0-carrier-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/proxy-and-vault/peerOrganization/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### Clean-up

To clean up, just uninstall the helm releases
```bash
helm uninstall --namespace carrier-net peer0-carrier-allchannel
helm uninstall --namespace supplychain-net allchannel
helm uninstall --namespace carrier-net allchannel
helm uninstall --namespace supplychain-net orderer1
helm uninstall --namespace supplychain-net orderer2
helm uninstall --namespace supplychain-net orderer3
helm uninstall --namespace carrier-net peer0-carrier

helm uninstall --namespace supplychain-net genesis

helm uninstall --namespace supplychain-net supplychain-ca
helm uninstall --namespace carrier-net carrier-ca
```
