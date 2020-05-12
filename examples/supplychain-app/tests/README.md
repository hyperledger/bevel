# Tests

## About
This folder contains the files that are needed for the integration test of a Supplychain Application on a Corda or Fabric network that has been created using the Blockchain Automation Framework. 

## Pre-requisites

* A DLT network with at least 3 participants: Manufacturer, Carrier and Warehouse. Built using BAF by following [these instructions](../../docs/source/operations/setting_dlt.md).
* The Supplychain Application is deployed and the API endpoints are accessible.

## Test Supplychain Application
### Using Postman Client

1. Edit the environment files `SupplychainDemoCorda.postman_environment.json` or `SupplychainDemoFabric.postman_environment.json` according to your test environment and save it.

2. Click "Import", select "Import Folder" and browse to the folder `examples/supplychain-app/tests` and import it.
This will import the "SupplyChainTest" collection and the environments.

3. Click "Runner" from Postman main screen. Select "SupplyChainTest" as the collection and your environment in the "Environment" dropdown and click "Run SupplyChainTest" button.

### Using Newman command line
This is applicable for automation using a CI tool.

1. Install newman using `npm install -g newman`. Please note that npm should be installed before this command is run.

2. Execute the following command with an environment file
```
cd examples/supplychain-app/tests
newman run -k SupplyChainTest.postman_collection.json -e SupplychainDemoCorda.postman_environment.json
```