[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Hyperledger Fabric components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Fabric components. Each helm that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS and Azure is fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws | azure
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
  proxy:
    provider: haproxy # choose from haproxy | none
    externalUrlSuffix: test.yourdomain.com
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

#### Setup Orderers and Peers in an organization
```bash
# Install the CA Server
helm upgrade --install supplychain-ca ./fabric-ca-server --namespace supplychain-net --create-namespace --values ./values/noproxy-and-novault/ca-orderer.yaml

# Install the Orderers after CA server is running
helm upgrade --install orderer1 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/orderer.yaml
helm upgrade --install orderer2 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/orderer.yaml --set certs.settings.createConfigMaps=false
helm upgrade --install orderer3 ./fabric-orderernode --namespace supplychain-net --values ./values/noproxy-and-novault/orderer.yaml --set certs.settings.createConfigMaps=false
```

**Note** The orderers will remain waiting in the `Pending` state for Fabric 2.2.x, until we install the `fabric-genesis` chart.

```bash
# OPTIONAL: To use a custom peer configuration, copy core.yaml file into ./fabric-peernode/files
cp /home/bevel/build/peer0-core.yaml ./fabric-peernode/conf/default_core.yaml
# Install the peers
helm upgrade --install peer0 ./fabric-peernode --namespace supplychain-net --values ./values/noproxy-and-novault/peer.yaml
helm upgrade --install peer1 ./fabric-peernode --namespace supplychain-net --values ./values/noproxy-and-novault/peer.yaml --set peer.gossipPeerAddress=peer0.supplychain-net:7051 --set peer.cliEnabled=true
```

#### Setup Peers in another organization

```bash
# Install the CA Server
helm upgrade --install carrier-ca ./fabric-ca-server --namespace carrier-net --create-namespace --values ./values/noproxy-and-novault/ca-peer.yaml

# Get the Orderer tls certificate and place in fabric-peernode/files
cd ./fabric-peernode/files
kubectl --namespace supplychain-net get configmap orderer-tls-cacert -o jsonpath='{.data.cacert}' > orderer.crt

# Install the Peers
cd ../..
helm upgrade --install peer0 ./fabric-peernode --namespace carrier-net --values ./values/noproxy-and-novault/carrier.yaml
```

#### Create Genesis file and other channel artifacts
```bash
# Obtain certificates and the configuration file of each peer organization, place in fabric-genesis/files
cd ./fabric-genesis/files
kubectl --namespace carrier-net get secret admin-msp -o json > carrier.json
kubectl --namespace carrier-net get configmap peer0-msp-config -o json > carrier-config-file.json

# OPTIONAL: If additional orderer from a different organization is needed in genesis
kubectl --namespace carrier-net get secret orderer5-tls -o json > orderer5-orderer-tls.json

# Generate the genesis block
cd ../..
helm install genesis ./fabric-genesis --namespace supplychain-net --values ./values/noproxy-and-novault/genesis.yaml
```

#### Create channel for Hyperledger Fabric 2.5.x
```bash
# Create channel
helm install allchannel ./fabric-osnadmin-channel-create --namespace supplychain-net --set global.vault.type=kubernetes

# Join peer to channel and make it an anchorpeer
helm install peer0-allchannel ./fabric-channel-join --namespace supplychain-net --set global.vault.type=kubernetes
helm install peer1-allchannel ./fabric-channel-join --namespace supplychain-net --set global.vault.type=kubernetes --set peer.name=peer1 --set peer.address=peer1.supplychain-net:7051

# Join peer from another organization to channel and make it an anchorpeer
helm install peer0-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/noproxy-and-novault/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

#### Create channel for Hyperledger Fabric 2.2.x

```bash
# Obtain the file channel.tx and place it in fabric-channel-create/files
cd ./fabric-channel-create/files
kubectl --namespace supplychain-net get configmap allchannel-channeltx -o jsonpath='{.data.allchannel-channeltx_base64}' > channeltx.json

# Install create channel
cd ../..
helm install allchannel ./fabric-channel-create --namespace carrier-net --set global.vault.type=kubernetes

# Join peer to channel and make it an anchorpeer. Repeat for each peer organization.
# Get the file anchors.tx and place it in fabric-channel-join/files
cd ./fabric-channel-join/files
kubectl --namespace supplychain-net get configmap allchannel-supplychain-anchortx -o jsonpath='{.data.allchannel-supplychain-anchortx_base64}' > anchortx.json

# Install join channel and anchorpeer
cd ../..
helm install peer0-allchannel ./fabric-channel-join --namespace supplychain-net --set global.vault.type=kubernetes --set global.version=2.2.2
helm install peer1-allchannel ./fabric-channel-join --namespace supplychain-net --set global.vault.type=kubernetes --set global.version=2.2.2 --set peer.name=peer1 --set peer.address=peer1.supplychain-net:7051 --set peer.type=general

# Join peer from another organization to channel and make it an anchorpeer
cd ./fabric-channel-join/files
kubectl --namespace supplychain-net get configmap allchannel-carrier-anchortx -o jsonpath='{.data.allchannel-carrier-anchortx_base64}' > anchortx.json
cd ../..
helm install peer0-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/noproxy-and-novault/join-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### _With Haproxy Proxy and Vault_

#### Setup Orderers and Peers in an organization

Replace the `"http://vault.url:8200"`, `"https://yourkubernetes.com"` and `"test.yourdomain.com"` in all the files in `./values/proxy-and-vault/` folder and this file.

```bash
kubectl create namespace supplychain-net 

kubectl -n supplychain-net create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>

helm upgrade --install supplychain-ca ./fabric-ca-server --namespace supplychain-net --values ./values/proxy-and-vault/ca-orderer.yaml

# Install the Orderers after CA server is running
helm upgrade --install orderer1 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/orderer.yaml
helm upgrade --install orderer2 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/orderer.yaml --set certs.settings.createConfigMaps=false
helm upgrade --install orderer3 ./fabric-orderernode --namespace supplychain-net --values ./values/proxy-and-vault/orderer.yaml --set certs.settings.createConfigMaps=false
```

**Note** The orderers will remain waiting in the `Pending` state for Fabric 2.2.x, until we install the `fabric-genesis` chart.

```bash
# OPTIONAL: To use a custom peer configuration, copy core.yaml file into ./fabric-peernode/files
cp /home/bevel/build/peer0-core.yaml ./fabric-peernode/conf/default_core.yaml
# Install the peers
helm upgrade --install peer0 ./fabric-peernode --namespace supplychain-net --values ./values/proxy-and-vault/peer.yaml
helm upgrade --install peer1 ./fabric-peernode --namespace supplychain-net --values ./values/proxy-and-vault/peer.yaml --set peer.gossipPeerAddress=peer0.supplychain-net.hlf.blockchaincloudpoc-develop.com:443 --set peer.cliEnabled=true
```

#### Setup Peers in another organization

```bash
kubectl create namespace carrier-net 
kubectl -n carrier-net create secret generic roottoken --from-literal=token=<VAULT_ROOT_TOKEN>
# Install the CA Server
helm upgrade --install carrier-ca ./fabric-ca-server --namespace carrier-net --values ./values/proxy-and-vault/ca-peer.yaml

# Get the Orderer tls certificate and place in fabric-peernode/files
cd ./fabric-peernode/files
kubectl --namespace supplychain-net get configmap orderer-tls-cacert -o jsonpath='{.data.cacert}' > orderer.crt

# Install the Peers
cd ../..
helm upgrade --install peer0 ./fabric-peernode --namespace carrier-net --values ./values/proxy-and-vault/carrier.yaml
```

#### Create Genesis file and other channel artifacts
```bash
# Obtain certificates and the configuration file of each peer organization, place in fabric-genesis/files
cd ./fabric-genesis/files
kubectl --namespace carrier-net get secret admin-msp -o json > carrier.json
kubectl --namespace carrier-net get configmap peer0-msp-config -o json > carrier-config-file.json

# OPTIONAL: If additional orderer from a different organization is needed in genesis
kubectl --namespace carrier-net get secret orderer5-tls -o json > orderer5-orderer-tls.json

# Generate the genesis block
cd ../..
helm install genesis ./fabric-genesis --namespace supplychain-net --values ./values/proxy-and-vault/genesis.yaml
```

#### Create channel for Hyperledger Fabric 2.5.x
```bash
# Create channel
helm install allchannel ./fabric-osnadmin-channel-create --namespace supplychain-net --values ./values/proxy-and-vault/osn-create-channel.yaml

# Join peer to channel and make it an anchorpeer
helm install peer0-allchannel ./fabric-channel-join --namespace supplychain-net --values ./values/proxy-and-vault/join-channel.yaml
helm install peer1-allchannel ./fabric-channel-join --namespace supplychain-net --values ./values/proxy-and-vault/join-channel.yaml --set peer.name=peer1 --set peer.address=peer1.supplychain-net.test.yourdomain.com:443

# Join peer from another organization to channel and make it an anchorpeer
helm install peer0-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/proxy-and-vault/create-channel.yaml --set global.version=2.5.4
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

#### Create channel for Hyperledger Fabric 2.2.x
```bash
# Obtain the file channel.tx and place it in fabric-channel-create/files
cd ./fabric-channel-create/files
kubectl --namespace supplychain-net get configmap allchannel-channeltx -o jsonpath='{.data.allchannel-channeltx_base64}' > channeltx.json

# Install create channel
cd ../..
helm install allchannel ./fabric-channel-create --namespace carrier-net --values ./values/proxy-and-vault/create-channel.yaml

# Join peer to channel and make it an anchorpeer. Repeat for each peer organization.
# Get the file anchors.tx and place it in fabric-channel-join/files
cd ./fabric-channel-join/files
kubectl --namespace supplychain-net get configmap allchannel-supplychain-anchortx -o jsonpath='{.data.allchannel-supplychain-anchortx_base64}' > anchortx.json

# Install join channel and anchorpeer
cd ../..
helm install peer0-allchannel ./fabric-channel-join --namespace supplychain-net --values ./values/proxy-and-vault/join-channel.yaml
helm install peer1-allchannel ./fabric-channel-join --namespace supplychain-net --values ./values/proxy-and-vault/join-channel.yaml --set peer.name=peer1 --set peer.address=peer1.supplychain-net.test.yourdomain.com:443 --set peer.type=general

# Join peer from another organization to channel and make it an anchorpeer
cd ./fabric-channel-join/files
kubectl --namespace supplychain-net get configmap allchannel-carrier-anchortx -o jsonpath='{.data.allchannel-carrier-anchortx_base64}' > anchortx.json
cd ../..
helm install peer0-allchannel ./fabric-channel-join --namespace carrier-net --values ./values/proxy-and-vault/create-channel.yaml
```
**Note** Anchorpeer job is only executed if `peer.type` is set to `anchor`

### Clean-up

To clean up, just uninstall the helm releases
```bash
helm uninstall --namespace supplychain-net peer1-allchannel peer0-allchannel
helm uninstall --namespace supplychain-net peer0 peer1
helm uninstall --namespace supplychain-net orderer1 orderer2 orderer3
helm uninstall --namespace supplychain-net genesis allchannel
helm uninstall --namespace supplychain-net supplychain-ca

helm uninstall --namespace carrier-net peer0 peer0-allchannel allchannel
helm uninstall --namespace carrier-net carrier-ca
```
