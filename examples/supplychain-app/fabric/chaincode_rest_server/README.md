[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Supply Chain Fabric

This project contains the hyperledger fabric-network files and smart contracts (chaincodes) for the Supply Chain application. This also includes the Kubernetes and Jenkins details/files which are use for the deployment of the fabric. 


## But first, what is the Supply Chain Application?

Here is a high-level description of the Supply Chain application:

*This application applies to any business area in which participants are going to move products amongst each other. It allows for the packaging of several products into one trackable object and then the transferring of ownership/custodianship of said goods.*

*There are currently 5 Roles/Participants expected by the application, however it can be quickly customized for any supply chain:*
```
(1) Manufacturer: can create products and issue recall notices on products and package products in containers.
(2) Carrier: accepts ownership of goods upon receiving the physical item as well as package products in containers.
(3) Warehouse: accepts ownership of goods upon receiving the physical item as well as package products in containers. 
(4) Store: accepts ownership of goods upon receiving the physical item as well as package products in containers.
(5) Consumer: have a visual on a product once they receive it at the end of the supply chain.
```


### High-Level details regarding the folders this project contains

```
(1) /chaincode - this folder contains all files related to the application's smart contracts. See below "Current Chaincodes this project contains" for further high-level details regarding each of the files inside this folder.
(2) /rest-server - This holds the Rest Server for Fabric Supply Chain App.
```


## Installing the development environment
### Requirements

- Go 1.11.x
- [Dep](https://golang.github.io/dep/docs/installation.html)


### Setup GOPATH

Go requries your sourcecode be within the \$GOPATH environment variable. This causes issues when you try to have your chaincode also with a shared repository. The following commands will symlink your chaincode directory into the GOPATH satifying both requirements.

```
export GOPATH=/opt/gopath
mkdir -p $GOPATH/src/github.com
ln -s $(pwd)/chaincode $GOPATH/src/github.com
```

## Developing Chaincode

### Installing dependencies

Run `dep ensure` to install from within \$GOPATH/src/github.com/chaincode to install the required dependencies.


### Current Chaincodes this project contains

On /chaincode folder you can see the list of files used by this application

#### /chaincode/common
This holds the structure/models used by the application, as well as some functions each uses. 

```
(1) Container.go - models a container in a supply chain. This holds AccessibleBy, UnmarshalJSON and Remove functions.
(2) ContainerRequest.go - models a request body for container creation in a supply chain. 
(3) History.go - models a historical custodian change in the supply chain. 
(4) Identity.go - encapsulates a chaincode invokers identity. This holds GetInvokerIdentity, CanInvoke and isManufacturer functions.
(5) Product.go - models a product in a supply chain. This holds AccessibleBy and UnmarshalJSON functions.
(6) ProductRequest.go - models request body for new product in a supply chain.
(7) UpdateRequest.go - models a product update in a supply chain.
```

#### /chaincode/supplychain/cmd

This holds the "main.go" file. This starts up the chaincode in the container during instantiate.

#### /chaincode/supplychain

This holds all the chaincodes (smart contracts) used by the application including the *_test.go files that can be use for testing purposes.

```
(1) Common.go - contains common functionalities of the application such as:
1.1 updateState - takes health and misc data and allows a user to update the trackingID
1.2 scan - checks to see if state exists and whether it is owned by the current identity
1.3 getIdentity - obtains users current identity
1.4 getHistory - retrieves single items hsitory on the ledger
1.5 isInHistory - helper to check if in history

(2) Container.go - contains functionalities related to the container asset used by the application.
2.1 createContainer - creates a new Container on the blockchain using the request body with the supplied ID
2.2 getAllContainer - retrieves all Container on the ledger
2.3 getSingleContainer - retrieves single Container on the ledger by trackingID
2.4 updateCustodian - claims current user as the custodian
2.5 packageItem - takes product/container and updates its containerID and takes a container and adds to its contents list


(3) Product.go - contains functionalites related to the product asset used by the application.
3.1 createProduct - creates a new Product on the blockchain using the  with the supplied ID
3.2 getAllProducts - retrieves all products on the ledger
3.3 getSingleProducts - retrieves all products on the ledger
3.4 getContainerlessProducts - retrieves all products on the ledger where containerID is empty
3.5 updateCustodian - claims current user as the custodian

(4) supplychain.go - this is holds the Supply Chain Smart Contract's init and invoke functionalities.
4.1 SmartContract - structure of the Smart Contract; this will hold the Smart Contract containing this chaincode
4.2 Init - called during chaincode instantiation to initialize any data
4.3 Invoke - called per transaction on the chaincode.
```

Below are the existing *_test.go files for the above chaincodes.
```
(1) Common_test.go
(2) Container_test.go
(3) Product_test.go
```

#### /chaincode/testdata

This holds data used by /chaincode/supplychain/*_test.go chaincodes. This includes:

```
(1) carrier.pem - test certificate for the role/participant carrier. Used by Product_test.go chaincode.
(2) manufacturer.pem - test certificate for the role/participant manufacturer. Used by Common_test.go,  Container_test.go and Product_test.go chaincodes.
(3) container-input-valid.json - used by Container_test.go chaincode.
(4) container-output.json - used by Container_test.go chaincode.
(5) product-input-valid.json - used by Product_test.go chaincode.
(6) product-output.json - used by Product_test.go chaincode.
(7) update-product-input.json - used by Product_test.go chaincode.
```


### Testing
#### Test using symlink

Run `go test` or `go test -v` from within \$GOPATH/src/github.com/chaincode to run the chaincode unit tests.

#### Test not using symlink

If you ONLY need to test your golang chaincodes (.go) using your golang test chaincodes (*_test.go), you don't need to run the fabric network locally for testing purposes, you can just do the following instead. (This is normally use for quick tests on bug fixes.)

```
(1) copy over to your $GOPATH/src/ the whole supplychain project's chaincode folder
NOTE: $GOPATH is normally $HOME/go

(2) in the $GOPATH/src/<project's chaincode folder> you can use `go get` to get dependencies then `go test -v` to test your chaincode.
NOTE: the test details will be cached so you could use `go clean` if you will be doing another round of test or another test with other chaincodes. This is to ensure that your are reading the correct test details when using `go test`.
```

### Update Chaincode deployed

To update chaincode running on a clusters, use the `platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml` playbook. 
The input network.yaml should be updated with a new version of chaincode. Please do not use dot(.) in chaincode versions.


## Deploying REST-Server and API-Server

The Supplychain Restserver and ExpressAPI server is deployed using the `examples/supplychain-app/configuration/deploy-supplychain-app.yaml` playbook. 
The input network.yaml should be updated correctly with the Chart path `examples/supplychain-app/charts`. Also, please do not use dot(.) in chaincode versions.


### Updating the Fabric REST-Server deployed

To update running Fabric rest-servers, ensure you are logged in to the Azure Docker Registry. Then:

```bash
docker build -t hyperledgerlabs/supplychain_fabric:rest_server_latest rest-server
docker push hyperledgerlabs/supplychain_fabric:rest_server_latest
```

Once the push is complete, Flux-helmoperator should redeploy the restserver pods

## Installing supplychain chaincode over BYFN

[BYFN](https://github.com/hyperledger/fabric-samples.git) (build your first network) is a sample network mentioned by Hyperledger Fabric.
You can deploy the supplychain chaincode over BYFN.
Here's the steps:
1. Clone the repository and install the binaries required  

```
git clone https://github.com/hyperledger/fabric-samples.git  
cd fabric-samples/  
git checkout release-1.4  
curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.4 1.4.4 0.4.18  
```

2. Setup the byfn network with raft consensus and fabric version 1.4.4 
``` 
cd first-network/  
printf '%s\n' y | ./byfn.sh generate -o etcdraft -s couchdb  
printf '%s\n' y | ./byfn.sh up -s couchdb -o etcdraft  
```

3. Copy the chaincode from Hyperledger Bevel repository and put it in the CLI container
```
export CLI_CONTAINER_ID="$(docker ps -a | grep cli | awk '{print $1}')"
git clone https://github.com/hyperledger/bevel.git
cd bevel
git checkout develop
docker cp $PWD/examples/supplychain-app/fabric/chaincode_rest_server/chaincode/ $CLI_CONTAINER_ID:/opt/gopath/src/github.com/chaincode/
```

4. Move chaincode to correct path and install dependencies
```
docker exec -it $CLI_CONTAINER_ID bash
apt-get update
printf '%s\n' y | apt-get install vim
cd /opt/gopath/src/github.com/chaincode
mv chaincode/* .
mkdir -p $GOPATH/bin && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
cd /opt/gopath/src/github.com/chaincode && dep ensure
```

5. Install chaincode
```
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
peer chaincode install -n supplychain -v 1.0 -p github.com/chaincode/supplychain/cmd

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
peer chaincode install -n supplychain -v 1.0 -p github.com/chaincode/supplychain/cmd

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
peer chaincode install -n supplychain -v 1.0 -p github.com/chaincode/supplychain/cmd

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key
export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
peer chaincode install -n supplychain -v 1.0 -p github.com/chaincode/supplychain/cmd
```

6. Instantiate chaincode
```
peer chaincode instantiate -o orderer.example.com:7050 -C mychannel  --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -n supplychain -v 1.0 -c '{"Args":['\"init\",\"\"']}' -P 'AND ('\''Org1MSP.peer'\'','\''Org2MSP.peer'\'')'
```


