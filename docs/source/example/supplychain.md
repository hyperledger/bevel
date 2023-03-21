[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Supplychain

One of the two reference applications for Bevel, is the Supplychain usecase. On this page, we will describe the usecase and its models, as well as pre-requisites to set it up yourself.

## Use case description
The Supplychain reference application is an example of a common usecase for a blockchain; the supplychain. The application defines a consortium of multiple organizations. The application allows nodes to track products or goods along their chain of custody. It provides the members of the consortium all the relevant data to their product. 

The application has been implemented for Hyperledger Fabric, Quorum and R3 Corda, with support for Hyperledger Besu coming soon. The platforms will slightly differ in behavior, but follow the same principles. 

---

In the context of the supplychain, there are two types of items that can be tracked, products and containers. Below you will find a definition of the item and its properties:

**Product**

| Field  | Description                                                          |
|----------|------------------------------------------------------------------------------------|
| `trackingID`           | A predefined unique UUID                                                                                                                                      |
| `type`                 | The type for the object, in this case `product`                                                                                                               |
| `productName`          | The name of the product                                                                                                                                       |
| `health`*              | Data from IOT sensors regarding condition of the item                                                                                                         |
| `location`             | The current location of the product, included in any requests sent to the blockchain                                                                          |
| `sold`                 | Boolean value that tracks if the product has been sold, `false` by default                                                                                    |
| `recalled`             | Boolean value that tracks if the product has been recalled, `false` by default                                                                                |
| `containerID`          | The ID of the container which a product can be packaged in. <br> If there is a container, additional info is read from the `ContainerState` (described below) |
| `custodian`            | Details of the current holder of the item.  <br> In the supplychain, a product will change custodian multiple times in the chain of custody                   |
| `timestamp`            | Timestamp at which most recent change of custodian occurred                                                                                                   |
| `participants`         | List of parties that have been part of the chain of custody for the given product                                                                             |


\* `health` - The blockchain will only store `min`, `max` and `average` values. The value currently is obsolete and not used, but in place for any future updates should these enable the value.

The creator of the product will be marked as its initial custodian.  As a custodian, a node is able to package and unpackage goods. 

---

**Container/ContainerState**

When handling an item, you can package it. It then stores data in an object called `ContainerState`, which is structured as such:

| Field                  | Description                                                                                                                                                   |
|-------------|-----------------------------------------------------------------------------------|
| `trackingID`           | A predefined unique UUID                                                                                                                                      |
| `type`                 | The type for the object, in this case `container`                                                                                                             |
| `health`*              | Data from IOT sensors regarding condition of the item                                                                                                         |
| `location`             | The current location of the product, included in any requests sent to the blockchain                                                                          |
| `containerID`          | The ID of the current container, which the product is packaged in                                                                                            |
| `custodian`            | Details of the current holder of the item.  <br> In the supplychain, the container will change custodian multiple times in the chain of custody               |
| `timestamp`            | Timestamp at which most recent change of custodian occurred                                                                                                   |
| `contents`             | List of items that are currently in the container                                                                                                             |
| `participants`         | List of parties that have been part of the chain of custody for the given container                                                                             |

\* `health` - The blockchain will only store `min`, `max` and `average` values. The value currently is obsolete and not used, but in place for any future updates should these enable the value.

Products being packaged will have their `trackingID` added to the contents list of the container. The product will be updated when its container is updated. If a product is contained it can no longer be handled directly (i.e. transfer ownership of a single product while still in a container with others).

Any of the participants can execute methods to claim custodianship of a product or container. History can be extracted via transactions stored on the ledger/within the vault.

---

## Prerequisites

* The supplychain application requires that nodes have subject names that include a location field in the x.509 name formatted as such:
`L=<lat>/<long>/<city>`
* DLT network of 1 or more organizations; a complete supplychain network would have the following organizations
    - Supplychain (admin/orderer organization) 
    - Carrier
    - Store
    - Warehouse
    - Manufacturer

## Setup Guide

The setup process has been automated using Ansible scripts, GitOps, and Helm charts. 

The files have all been provided to use and require the user to populate the `network.yaml` file accordingly, following these steps:
1. Create a copy of the `network.yaml` you have used to set up your network.
2. For each organization, navigate to the `gitops` section. Here, the `chart_source` field will change. The value needs to be changed to `examples/supplychain-app/charts`.
This is the relative location of the Helm charts for the supplychain app.
3. Make sure that you have deployed the smart contracts for the platform of choice; along with the correct `network.yaml` for the DLT.
    - For R3 Corda, run the `platforms\r3-corda\configuration\deploy-cordapps.yaml`
    - For Hyperledger Fabric, run the `platforms/hyperledger-fabric/configuration/chaincode-ops.yaml`
    - For Quorum, no smart contracts need to be deployed beforehand.

## Deploying the supplychain-app
When having completed the Prerequisites and setup guide, deploy the supplychain app by executing the following command from [bevel-samples repository](https://github.com/hyperledger/bevel-samples):

`ansible-playbook examples/supplychain-app/configuration/deploy-supplychain-app.yaml -e "@/path/to/application/network.yaml"`

## Testing/validating the supplychain-app
For testing the application, there are API tests included. For instructions on how to set this up, follow the `README.md` [here](https://github.com/hyperledger/bevel-samples/tree/main/examples/supplychain-app/tests).
