[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Using Raspberry Pi device to interface with AWS Deployment

## Introduction
Hyperledger Bevel has a sample supplychain application deployed via express-NodeJS and is exposed on a few endpoints. The available endpoints are as follows:

### User application
Manufacturer: https://partya.blockchaincloudpoc.com

Carrier: https://partyb.blockchaincloudpoc.com

Warehouse: https://partyc.blockchaincloudpoc.com

Store: https://partyd.blockchaincloudpoc.com

### Springboot Rest api
Manufacturer: https://partyaapi.blockchaincloudpoc.com

Carrier: https://partybapi.blockchaincloudpoc.com

Warehouse: https://partycapi.blockchaincloudpoc.com

Store: https://partydapi.blockchaincloudpoc.com

These are subject to change and will be updated in here when they do.

By loading the User web application on a mobile device, a user is able to scan products and container QR codes which store formatted JSON information. The Json is to be defined as such for products:
```json
{
  "productName": "Thing",
  "misc": {
    "details": "Expensive Drug",
    "type": "dextrose",
    "description":{
    	"weight":"500lbs",
    	"height":"10ft"
    }
  },
  "trackingID": "99f5d7b8-caaa-468d-8b83-aae049b40f46",
  "counterparties": [
    "Carrier",
    "Warehouse",
  ]
}
```

The json for a containers QR requires the following minimum field:
```json
{
  "misc": {
    "name": "Container of Products",
    "type": "medicine",
  },
  "trackingID": "99f5d7b8-caaa-468d-8b83-aae049b40f46",
  "counterparties": [
    "Carrier",
    "Warehouse",
  ]
}
```
The fields within misc are customizable. On the deskstop site you can go to /generate/qr to create and download customizable QR codes. Currently the front end application is configured to show png images corresponding to the type field. If you create a QR code with a new type, make sure to add the image in the public folder at the root of this repo.
The items within misc.description will be mapped to display under a product description page.

Sample QR codes have been included in the docs folder at the root of the repo. The available 'types' are see by the list of png files in the public folder.

In order to use the Raspberry Pi to interface with the available API we have provided a python script, app.py and scanner.py. Raspberry Pi only support capability to claim ownership of a product aka move a container from one location to another.

## Setup

First clone this repo somewhere on the Raspberry Pi and get the location of the app.py script. Modify your /etc/rc.local to run the pythons script on startup with the appropriate args.
i.e.

```bash
cd rpi-scanner/
pwd # Note this down as the full path to the app.py script
nano /etc/rc.local  
```
Add a line at the bottom of this for the following

```bash
python <complete/path/to/the/rpi-scanner/dir>/app.py partyb &
```
This allows the Raspberry to run as the carrier. Repeat this step for second raspery pi and use party c to indicate the Warehouse.

For demo purpose, we also use two android devices loaded with the website for Manufacturer and one for Store. We also load the desktop site on a large screen above the demo. One can go with the Store user application loaded on a desktop browser.

## Demo Overview

Use the mobile devices and Raspberry Pis to move a container from end to end. Note that the status of the container will be updated realtime on the desktop site so make sure to redirect attention to the screen showing a desktop browser with one of the parties user applications on it whenever scanning items.

### Product Creation at Manufacturer
1) Use Manufacturer phone to scan a Product QR. Use the hamburger menu button to return to QR scanner
2) Use Manufacturer phone to scan a Container QR. Use the add to container feature to add the previously created product to the new container. Use the hamburger menu button to go back.
3) You can add more products to the same container if desired. To do add to an existing container, first take an existing container and scan it. The option to add to container will be presented above a list of current products in container. The button redirects to a QR scanner which will allow you to scan existing products into a container if they don't already have one.

### Send to Warehouse

1) Use a QR scanner device connected to the first RPI running the code as partyb. This will scan the Container and move it to the Carrier

2) Use a QR scanner device connected to the second RPI running the code as partyc. This will scan the Container and move it to the Warehouse

### Send to Store

1) Use the second mobile device loaded with Store web application to scan the Container. The store can then view the location history, products within the container, unpackage products from the container, etc.
