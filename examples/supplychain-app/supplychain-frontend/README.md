[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Web - Reference Application for Supply Chain

This is the reference web application for supply chain. It is built on React and interfaces with
existing Springboot webserver for your desired blockchain platform (currently only available with Corda)

## Deployment

### `npm install`

Install dependencies.

### `npm run build`

Builds the app for production to the `build` folder.

### `/usr/bin/nginx -g daemon off`

Serves using nginx as configured in nginx.conf. The nginx.conf file would need to be updated with the correct proxy for api calls.

NGINX is not the only way to deploy.. this is just one way and can be used as an example for configuring other methods

# Docker
Pass the following environment variables to the image while running:
     * REACT_APP_GMAPS_KEY: <your Google Maps API Key>

## Development

Go to root directory of the project and create a .env.local file.  
Add `REACT_APP_GMAPS_KEY=<google maps api key>` and save it.  

### `npm install`

Install dependencies.

### `npm run start <Desired Party's name>`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.

The desired party names currently available are PartyA, PartyB, and PartyC which redirect api calls to ports 8080, 8082, or 8084 respectively. (This would only work if the parties webservers are running on those ports but can be configured in the package.json in nodes)

### `npm test`

Tests not yet implemented, will update here with additional details.

Launches the test runner in the interactive watch mode.<br>
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.

## Use
Demo information is detailed with rpi-scanner/README.md
### Manufacturer

As a Manufacturer you have a mobile view and a desktop view.

Within the mobile screen you are presented with a QR scanner. The QR screen allows you to add products, create containers, and view details on existing items in current possession.
From the Desktop view, the user has an end to end view on the containers in transit. from both Desktop and mobile you can see the contents on a container and a map of its location and where it has been. You can also add products to a container. On desktop you can issue recalls as well (yet to be implemented)

### Carrier/ Wholesale / Store

As any of these given roles you have a mobile view with a QR scanner as your main screen. This scanner allows you to scan an item to claim ownership, scan item you own to review details and create containers to re-organize other containers you received. If you scan an item and it has been marked for recall, you will be prompted with the notification (yet to be implemented).

### Consumer

As a consumer you only have the ability to view an items detail and location history. This gives the consumer visibility of the product history without allows them to make changes to the blockchain's ledger.
