[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

*If spring boot web servers are currently accessible, you can access a swagger ui for the same documentation at /swagger-ui.html

# General #
## Get /api/v1/{trackingID}/history ##
### Return format ###

    [
        {
            party:"O=PartyA,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH",
            timestamp:1549565435354
        },
        {...}
    ]
### Purpose: ###
This maps the custodian changes on the ledger to a list of objects with the timestamp of custodian change and new custodian
### Other ###
Tracking ID is a passed in string and must be a valid UUID (java.util.uuid)

## Get /api/v1/{trackingID}/scan ##
### Return format ###
    {
        status:"owned"
    }
### Purpose: ###
This checks trackable states and sees whether the any state associate to that tracking ID exists and if so returned if you currently own it.
### Other: ###
Tracking ID is a passed in string and must be a valid UUID (java.util.uuid).
The different states are owned, unowned, and new.

## Get /api/v1/node-organization ##
### Return format ###
    {
        organization:"PartyA"
    }

### Purpose: ###
This checks the nodes organization name
### Other: ###
N/A

## Get /api/v1/node-organizationUnit ##
### Return format ###
    {
        organizationUnit:"Manufacturer"
    }
### Purpose: ###
This checks the nodes organization unit name. In the front end this allows the user to access a few different APIS
### Other: ###
N/A
# Products #

## Get /api/v1/product ##
### Return format ###

    [{
        "productName": "Insulin",
        "health": null,
         "sold": false,
        "recalled": false,
        "misc": {
            "name": "Expensive Insulin"
        },
        "custodian": "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
        "trackingID": "53116d75-e884-4d21-bbd8-057a144a30c5",
         "timestamp": 1552583510960,
         "containerID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "linearId": {
            "externalId": null,
            "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
        },
        "participants": [
            "OU=Carrier, O=PartyB, L=51.50/-0.13/London, C=US",
            "OU=Warehouse, O=PartyC, L=42.36/-71.06/Boston, C=US",
            "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
            "OU=Manufacturer, O=PartyA, L=47.38/8.54/Zurich, C=CH"
        ]
    }]

### Purpose: ###
This gets back a list of all products available to node
### Other: ###
N/A

## POST /api/v1/product ##
### Request format ###
    {
    "productName":"Dextrose",
    "misc": {"name":"Expensive Dextrose"},
    "trackingID": "0d15d7b8-caaa-468d-8b83-aae049b40f46",
    "counterparties": ["PartyB","PartyC","PartyD"]
    }

### Return format ###
    {
        "generatedID": "0d15d7b8-caaa-468d-8b83-aae049b40f46"
    }
### Purpose: ###
This gets adds the product to the ledger and returns the trackingID back. It also send the copy to all other counterparties allowed to view the product and handle it
### Other: ###
This data is parse from a QR code on the front end.
misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata.

## PUT /api/v1/product{trackingID} ##
### Request format ###
    {
    "productName":"Dextrose",
    "health":"String",
    "misc": {"name":"Expensive Dextrose"},
    "trackingID": "0d15d7b8-caaa-468d-8b83-aae049b40f46",
    "counterparties": ["PartyB","PartyC","PartyD"]
    }

### Return format ###
    "0d15d7b8-caaa-468d-8b83-aae049b40f46"

### Purpose: ###
This is used to update productName , health,  misc field
### Other: ###
Health is currently unused and it left as a string for IOT sensor placeholder
misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata.

## PUT /api/v1/product/{trackingID}/custodian ##
### Return format ###
    "0d15d7b8-caaa-468d-8b83-aae049b40f46"
### Purpose: ###
This is used to update custodian to node hitting the endpoint
### Other: ###
N/A

## Get /api/v1/product/containerless ##
### Return format ###

    [{
        "productName": "Insulin",
        "health": null,
         "sold": false,
        "recalled": false,
        "misc": {
            "name": "Expensive Insulin"
        },
        "custodian": "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
        "trackingID": "53116d75-e884-4d21-bbd8-057a144a30c5",
         "timestamp": 1552583510960,
         "containerID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
        "linearId": {
            "externalId": null,
            "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
        },
        "participants": [
            "OU=Carrier, O=PartyB, L=51.50/-0.13/London, C=US",
            "OU=Warehouse, O=PartyC, L=42.36/-71.06/Boston, C=US",
            "OU=Store, O=PartyD, L=40.73/-74/New York, C=US",
            "OU=Manufacturer, O=PartyA, L=47.38/8.54/Zurich, C=CH"
        ]
    }]

### Purpose: ###
This gets back a list of all products available to node which are containerless
### Other: ###
N/A

# Containers #
## Get /api/v1/container ##
### Return format ###

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

### Purpose: ###
This gets back a list of all containers available to node
### Other: ###
N/A
## POST /api/v1/container ##

### Request format ###
    {
    "misc": {"name": "Pharma Insulin container"},
    "trackingID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
    "counterparties": ["PartyB","PartyC","PartyD"]
    }

### Return format ###
    {
        "generatedID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6"
    }
### Purpose: ###
This gets adds the container to the ledger and returns the trackingID back. It also send the copy to all other counterparties allowed to view the container and handle it
### Other: ###
This data is parse from a QR code on the front end.
misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata.

## PUT /api/v1/container/{trackingID} ##
### Request format ###

    {
    "health":"String",
    "misc": {"name":"Pharma Insulin Container"},
    "trackingID": "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6",
    "counterparties": ["PartyB","PartyC","PartyD"]
    }

### Return format ###

    "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6"

### Purpose: ###
This is used to update health  and misc field
### Other: ###
Health is currently unused and it left as a string for IOT sensor placeholder
misc field is customizable and doesnt need anything or can be a mapping of any key to any value. Used to store other metadata.

## PUT /api/v1/container/{trackingID}/custodian ##
### Return format ###
    "17219ad9-3e8b-4c79-ab55-79f6ada4a2d6"
### Purpose: ###
This is used to update custodian to node hitting the endpoint
### Other: ###
N/A
## PUT /api/v1/container/{containerTrackingID}/package ##
### Request format ###
    {
        "contents":"{productTrackingID}"
    }

### Return format ###
    "{containerTrackingID}"
### Purpose: ###
This is used to add a product to a container
### Other: ###
Currently only works one at a time but can be modified (should be) to allow multiple
## PUT /api/v1/container/{containerTrackingID}/unpackage ##

### Request format ###
    {
        "contents":"{productTrackingID}"
    }

### Return format ###
    "{containerTrackingID}"

### Purpose: ###
This is used to remove a product from a container
### Other: ###
Currently only works one at a time but can be modified (should be) to allow multiple

