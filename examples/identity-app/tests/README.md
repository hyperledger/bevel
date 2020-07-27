# Tests

## About
This folder contains the files that are needed for the integration test of a Identity Application on an Indy network that has been created using the Blockchain Automation Framework. 

## Pre-requisites

* A Indy network and Faber and Alice Agents built using BAF by following [these instructions](../README.md).
* The Faber and Alice Agents' API endpoints are accessible.

## Test Identity Application
### Using Postman Client

1. Edit the given environment file `IdentityIndyDemo.postman_environment.json` according to your test environment and save it.

2. Click "Import", select "Import Folder" and browse to the folder `examples/identity-app/tests` and import it.
This will import the "IdentityAppTest" collection and the environments.

3. Click "Runner" from Postman main screen. Select "IdentityAppTest" as the collection and your environment in the "Environment" dropdown, Enter a "Delay" of 100 ms and click "Run IdentityAppTest" button.

### Using Newman command line
This is applicable for automation using a CI tool.

1. Install newman using `npm install -g newman`. Please note that npm should be installed before this command is run.

2. Execute the following command with an environment file
```
cd examples/identity-app/tests
newman run -k IdentityAppTest.postman_collection.json -e IdentityIndyDemo.postman_environment.json --delay-request 150
```
