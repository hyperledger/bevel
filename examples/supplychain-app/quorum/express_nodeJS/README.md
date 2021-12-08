[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Supplychain Quorum Api microservice
This project contains an Express Node.js application which does request transformation for API requests from the front end react application for supplychain to the appropriate format for a smartcontract deployed on a private Quorum network. 

## Requirements 

1. If you need to install Node.js run the command 

        brew install node 

     For **Ubuntu** OS:

        sudo apt-get update
        sudo apt-get install nodejs

     You will need to install npm, which is Node.js package manager.  

        sudo apt-get install npm

1. This application requires Express. Run the command to install express:
        
        npm install express

## Starting the Supply Chain API from command-line

1. In terminal, go to this directory i.e. examples/supplychain-app/quorum/express_nodeJS/ directory and install the dependencies 

        npm install

1. You will need a minimum of 3 nodes running for the supply chain app. The manufacturer, carrier and warehouse will each have a node. Rename the `PartyAEnv.list` file to `.env`

        mv PartyAEnv.list .env
        
1. Update the .env file with correct parameters and run the following command to start the node for the manufacturer:

        node app.js

1. Open a new terminal, go to this directory i.e. examples/supplychain-app/quorum/express_nodeJS/ directory. Run the command below to start another node. This node will be for the carrier. Use another address from the Ganache CLI that have not been used already. Update the NODE_SUBJECT to reflect the carrier.

        PORT=8081 NODE_IDENTITY=0x.... NODE_ORGANIZATION=Carrier NODE_ORGANIZATIONUNIT=Carrier node app.js 

1. Repeat step 5. This node is for the warehouse.

        PORT=8082 NODE_IDENTITY=0x... NODE_ORGANIZATION=PartyC NODE_ORGANIZATIONUNIT=Warehouse node app.js

Once you have 3 nodes running, you should be ready to able to use Postman to test the APIs.

## Docker Deployment

The deployment has been made easy for Docker. The provided dockerfile will create the image that can be run multiple times by passing the envfile.

The following command will create the image called supplychain_quorum and then run the service on port 8080 for the manufacturer. Edit the `PartyAEnv.list` with correct environment parameters according to your Quorum network first.
```
docker build -t supplychain_quorum .
docker run --detach --env-file PartyAEnv.list -p 8080:3000 supplychain_quorum
```
Similarly use `PartyBEnv.list` and `PartyCEnv.list` env files to run the service for Carrier and Warehouse. Remember to use a different host port (instead of 8080, use 8082 and 8084).

## Available Api
The list of all supplychain api requests are listed below:

### General ###
#### Get /api/v1/{trackingID}/history ###
##### Return format #####
```json
    [
        {
            "party": "0xcCdd8AA32944992B7489718e213c9547F1640980,O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            "time": 1549565435354,
            "location": "O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH"
        },
        {...}
    ]
```
##### Purpose: #####
This maps the custodian changes on the ledger to a list of objects with the timestamp of custodian change and new custodian
##### Other #####
Tracking ID is a passed in string and must be a valid UUID (java.util.uuid)

#### Get /api/v1/{trackingID}/scan ####
##### Return format #####
```json
    {
        "status": "owned"
    }
```
##### Purpose: #####
This checks trackable states and sees whether the any state associate to that tracking ID exists and if so returned if you currently own it.
##### Other: #####
Tracking ID is a passed in string and must be a valid UUID (java.util.uuid).
The different states are `owned`, `unowned`, and `new`.

#### Get /api/v1/node-organization ####
##### Return format #####
```json
    {
        "organization": "Manufacturer"
    }
```
##### Purpose: #####
This checks the nodes organization name
##### Other: #####
N/A

#### Get /api/v1/node-organizationUnit ####
##### Return format #####
```json
    {
        "organizationUnit": "manufacturer"
    }
```
##### Purpose: #####
This checks the nodes organization unit name. In the front end this allows the user to access a few different APIs.
##### Other: #####
N/A
### Products ###

#### Get /api/v1/product ####
##### Return format #####
```json
    [{
        "productName": "Insulin",
        "health": null,
        "sold": false,
        "recalled": false,
        "misc": {
            "name": "Expensive Insulin"
        },
        "custodian": "0xaEd9744684F9185AaF82A235BBBBb5408D881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US",
        "trackingID": "53116d75-e884-4d21-bbd8-057a144a30c5",
        "timestamp": 1552583510960,
        "containerID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "linearId": {
            "externalId": null,
            "id": "53116d75-e884-4d21-bbd8-057a144a30c5"
        },
        "participants": [
            "0xccdd8aa32944992b7489718e213c9547f1640980,O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            "0x71402dd5e14d8d17ce9d051aded639a2cbcaa78b,O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB",
            "0xaed9744684f9185aaf82a235bbbbb5408d881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US"
            "0xafe4671684f9185aaf82a235bbbbb5408d881592,OU=Store, O=PartyD,L=40.73/-74/New York,C=US"
        ]
    }]
```
##### Purpose: #####
This gets back a list of all products available to node
##### Other: #####
N/A

#### Get /api/v1/product/{trackingID} ####
##### Return format #####
```json
    {
        "productName": "Insulin",
        "health": null,
        "sold": false,
        "recalled": false,
        "misc": {
            "name": "Expensive Insulin"
        },
        "custodian": "0xaEd9744684F9185AaF82A235BBBBb5408D881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US",
        "trackingID": "53116d75-e884-4d21-bbd8-057a144a30c5",
        "timestamp": 1552583510960,
        "containerID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "linearId": {
            "externalId": null,
            "id": "53116d75-e884-4d21-bbd8-057a144a30c5"
        },
        "participants": [
            "0xccdd8aa32944992b7489718e213c9547f1640980,O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            "0x71402dd5e14d8d17ce9d051aded639a2cbcaa78b,O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB",
            "0xaed9744684f9185aaf82a235bbbbb5408d881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US"
            "0xafe4671684f9185aaf82a235bbbbb5408d881592,OU=Store, O=PartyD,L=40.73/-74/New York,C=US"
        ]
    }
```
##### Purpose: #####
This gets back the single product with tracking id from url param
##### Other: #####
N/A

#### POST /api/v1/product ####
##### Request format #####
```json
    {
    "productName":"Dextrose",
    "misc": {"name":"Expensive Dextrose"},
    "trackingID": "0d15d7b8-caaa-468d-8b83-aae049b40f46",
    "counterparties": ["PartyA","PartyB","PartyC","PartyD"]
    }
```
##### Return format #####
```json
    {
        "generatedID": "0d15d7b8-caaa-468d-8b83-aae049b40f46"
    }
```
##### Purpose: #####
This POST adds the product to the ledger and returns the trackingID back. It also send the copy to all other counterparties allowed to view and handle the product.
##### Other: #####
This data is parsed from a QR code on the front end.
The misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata. 

**NOTE:** For Quorum, the calling party must be in the "counterparties" list in the request.

#### PUT /api/v1/product/{trackingID}/custodian ####
##### Return format #####
    "0d15d7b8-caaa-468d-8b83-aae049b40f46"
##### Purpose: #####
This is used to update custodian to node hitting the endpoint
##### Other: #####
N/A

#### Get /api/v1/product/containerless ####
##### Return format #####
```json
    [{
        "productName": "Insulin",
        "health": null,
        "sold": false,
        "recalled": false,
        "misc": {
            "name": "Expensive Insulin"
        },
        "custodian": "0xaEd9744684F9185AaF82A235BBBBb5408D881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US",
        "trackingID": "53116d75-e884-4d21-bbd8-057a144a30c5",
        "timestamp": 1552583510960,
        "containerID": "",
        "linearId": {
            "externalId": null,
            "id": "53116d75-e884-4d21-bbd8-057a144a30c5"
        },
        "participants": [
            "0xccdd8aa32944992b7489718e213c9547f1640980,O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            "0x71402dd5e14d8d17ce9d051aded639a2cbcaa78b,O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB",
            "0xaed9744684f9185aaf82a235bbbbb5408d881592,O=Warehouse,OU=Warehouse,L=42.36/-71.06/Boston,C=US"
            "0xafe4671684f9185aaf82a235bbbbb5408d881592,OU=Store, O=PartyD,L=40.73/-74/New York,C=US"
        ]
    }]
```
##### Purpose: #####
This gets back a list of all products available to node which are containerless
##### Other: #####
N/A

### Containers ###
#### Get /api/v1/container ####
##### Return format #####
```json
    [{
        "health": null,
        "sold": false,
        "recalled": false,
        "misc": {
            "name": "Pharma Insulin container"
        },
        "custodian": "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
        "trackingID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "timestamp": 1552583510960,
        "containerID": null,
        "contents": [
             "53116d75-e884-4d21-bbd8-057a144a30c5",
             "0d15d7b8-caaa-468d-8b83-aae049b40f46"
        ],
        "linearId": {
            "externalId": null,
            "id": "2059484c-0c3b-43a7-9604-4a61d3039639"
        },
         "participants": [
            "OU=Carrier, O=PartyB, L=51.50/-0.13/London, C=US",
            "OU=Warehouse, O=PartyC, L=42.36/-71.06/Boston, C=US",
            "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
            "OU=Manufacturer, O=PartyA, L=47.38/8.54/Zurich, C=CH"
            ]
        }]
```
##### Purpose: #####
This gets back a list of all containers available to node
##### Other: #####
N/A
#### POST /api/v1/container ####

##### Request format #####
```json
    {
    "misc": {"name": "Pharma Insulin container"},
    "trackingID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
    "counterparties": ["PartyA", "PartyB","PartyC","PartyD"]
    }
```
##### Return format #####
```json
    {
        "generatedID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6"
    }
```
##### Purpose: #####
This adds the container to the ledger and returns the trackingID back. It also send the copy to all other counterparties allowed to view and handle the container.
##### Other: #####
This data is parsed from a QR code on the front end. The
misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata. 

**NOTE:** For Quorum, the calling party must be in the "counterparties" list in the request.

#### Get /api/v1/container/{trackingID} ####
##### Return format #####
```json
    {
        "health": null,
         "sold": false,
        "recalled": false,
        "misc": {
            "name": "Pharma Insulin container"
        },
        "custodian": "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
        "trackingID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "timestamp": 1552583510960,
        "containerID": null,
        "contents": [
             "53116d75-e884-4d21-bbd8-057a144a30c5",
             "0d15d7b8-caaa-468d-8b83-aae049b40f46"
        ],
        "linearId": {
            "externalId": null,
            "id": "2059484c-0c3b-43a7-9604-4a61d3039639"
        },
         "participants": [
            "OU=Carrier, O=PartyB, L=51.50/-0.13/London, C=US",
            "OU=Warehouse, O=PartyC, L=42.36/-71.06/Boston, C=US",
            "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
            "OU=Manufacturer, O=PartyA, L=47.38/8.54/Zurich, C=CH"
        ]
    }
```
##### Purpose: #####
This gets back the container with the id passed in the url param.
##### Other: #####
N/A

#### PUT /api/v1/container/{trackingID}/custodian ####
##### Return format #####
    "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6"
##### Purpose: #####
This is used to update custodian to node hitting the endpoint
##### Other: #####
N/A

#### PUT /api/v1/container/{containerTrackingID}/package ####
##### Request format #####
```json
    {
        "contents":"{productTrackingID}"
    }
```
##### Return format #####
    "{containerTrackingID}"
##### Purpose: #####
This is used to add a product to a container
##### Other: #####
Currently only works one at a time but can be modified (should be) to allow multiple.

#### PUT /api/v1/container/{containerTrackingID}/unpackage ####

##### Request format #####
```json
    {
        "contents":"{productTrackingID}"
    }
```
##### Return format #####
    "{containerTrackingID}"

##### Purpose: #####
This is used to remove a product from a container
##### Other: #####
Currently only works one at a time but can be modified (should be) to allow multiple.
