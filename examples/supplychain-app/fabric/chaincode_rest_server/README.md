# Supply Chain Fabric

This project contains the hyperledger fabric-network files and smart contracts (chaincodes) for the Supply Chain application. This also includes the Kubernetes and Jenkins details/files which are use for the deployment of the fabric. 


## But first, what is the Supply Chain Application?

To be able to understand this application's usage you may visit (if you have access): https://alm.accenture.com/wiki/display/BLOCKOFZ/Supply+Chain+App

But if you don't have access to above link, below is the high-level description of the application instead: 

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
(1) /ansible - this folder holds the yaml files used for kubernetes.
(2) /chaincode - this folder contains all files related to the application's smart contracts. See below "Current Chaincodes this project contains" for further high-level details regarding each of the files inside this folder.
(3) /chartvalues - this folder contains the yaml files used by the fabric-network's ca, catools, channel, orderer and peers.
(4) /fabric-network - This holds the .sh files used to generate channel artifacts.
(5) /k8-files - This holds files needed for the kubernetes setup. See /k8-files/minikube-readme.md and /k8-files/README.md for further details.
(6) /rest-server - This holds the Rest Server for Fabric Supply Chain App.
```


## Installing the development environment
### Requirements

- Go 1.11.x
- [Dep](https://golang.github.io/dep/docs/installation.html)


### Setup GOPATH

Go requries your sourcecode be within the \$GOPATH environment variable. This causes issues when you try to have your chaincode also with a shared repository. The following commands will symlink your chaincode directory into the GOPATH satifying both requirements.

```
mkdir -p $GOPATH/src/supplychain-fabric/
ln -s $(pwd)/chaincode $GOPATH/src/supplychain-fabric/
```


## Developing Chaincode

### Installing dependencies

Run `dep ensure` to install from within \$GOPATH/src/supplychain-fabric/ to install the required dependencies.


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

Run `go test` or `go test -v` from within \$GOPATH/src/supplychain-fabric/ to run the chaincode unit tests.

#### Test not using symlink

If you ONLY need to test your golang chaincodes (.go) using your golang test chaincodes (*_test.go), you don't need to run the fabric network locally for testing purposes, you can just do the following instead. (This is normally use for quick tests on bug fixes.)

```
(1) copy over to your $GOPATH/src/ the whole supplychain project's chaincode folder
NOTE: $GOPATH is normally $HOME/go

(2) in the $GOPATH/src/<project's chaincode folder> you can use `go get` to get dependencies then `go test -v` to test your chaincode.
NOTE: the test details will be cached so you could use `go clean` if you will be doing another round of test or another test with other chaincodes. This is to ensure that your are reading the correct test details when using `go test`.
```


### Fabric Network

Connect to a kubernetes cluster running the fabric network or deploy to a local cluster by following the instructions in k8s-files/minikube-readme.md


### Update Chaincode deployed

To update chaincode running on a cluster:

```bash
k8s-files/bin/installChaincode.sh store-net <version>
k8s-files/bin/installChaincode.sh warehouse-net <version>
k8s-files/bin/installChaincode.sh manufacturer-net <version>
k8s-files/bin/installChaincode.sh carrier-net <version>

export CLI=$(kubectl get pods -n manufacturer-net | grep 'cli' | awk '{print $1}')
kubectl exec -n manufacturer-net $CLI -- bash -c 'peer chaincode upgrade -o $ORDERER_URL --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C allchannel -n supplychain -v <version>  -c "{\"Args\":[\"init\"]}"'
```

Where <version> is the new version number of the chaincode, e.g., 1.1 or 2.0.


## Developing the API Server
### Local Access

To access api-servers running on a local kubernetes cluster add the following lines to your `/etc/hosts` file:

```
127.0.0.1       store.fabric.supplychain.blockchaincloudpoc.com
127.0.0.1       carrier.fabric.supplychain.blockchaincloudpoc.com
127.0.0.1       warehouse.fabric.supplychain.blockchaincloudpoc.com
127.0.0.1       manufacturer.fabric.supplychain.blockchaincloudpoc.com
```

Remove or comment the lines to re-enable cloud access.


### Updating the API Server deployed

To update running api servers, ensure you are logged in to the Azure Docker Registry. Then:

```bash
docker build -t adopblockchaincloud0502.azurecr.io/supply_chain_fabric/rest-server rest-server
docker push  adopblockchaincloud0502.azurecr.io/supply_chain_fabric/rest-server:latest
```

Once the push is complete terminate the current pods so they recreate with the new image:

```bash
kubectl del pod -n store-net api-server-xxxxxxxxxx-yyyyy
kubectl del pod -n warehouse-net api-server-xxxxxxxxxx-yyyyy
kubectl del pod -n carrier-net api-server-xxxxxxxxxx-yyyyy
kubectl del pod -n manufacturer-net api-server-xxxxxxxxxx-yyyyy
```