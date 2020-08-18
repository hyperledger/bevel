# Supplychain-App

## About
This folder contains the files that are needed for the deployment of a Supplychain Application on a Corda or Fabric network that has been created using the Blockchain Automation Framework. 

## Folder structure
```
supplychain-app
|-- charts: this folder contains the Helm charts that are needed for the deployment of the Supplychain Application.
|-- configuration: this folder contains all the Ansible playbooks and roles needed for the deployment of the Supplychain Application.
|-- corda: this folder contains the code for Corda CorDapps, Springboot and Express-API for the Supplychain Application.
|-- fabric: this folder contains the code for Fabric chaincode, Restserver and Express-API for the Supplychain Application.
|-- supplychain-frontend: this folder contains the code for the Supplychain Application GUI.
|-- tests: this folder contains various Postman collections to test the Supplychain Application end-to-end.
```

## Pre-requisites

* A DLT network with 4 participants: Manufacturer, Carrier, Warehouse and Store. Built using BAF by following [these instructions](../../docs/source/operations/setting_dlt.md).
* A Docker repository
* A Google Maps API key

## Deploy Supplychain Application
### Step 1
Build the following docker images from the respective folders and store in the docker repository. You can follow the pipeline samples in `automation` folder.
* supplychain_frontend:latest (from `examples/supplychain-app/supplychain-frontend/` folder)
* supplychain_corda:springboot_latest (from `examples/supplychain-app/corda/cordApps_springBoot/` folder) for Corda
* supplychain_corda:express_app_latest (from `examples/supplychain-app/corda/express_nodeJS/` folder) for Corda
* supplychain_fabric:rest_server_latest (from `examples/supplychain-app/fabric/chaincode_rest_server/rest-server/` folder) for Fabric
* supplychain_fabric:express_app_latest (from `examples/supplychain-app/fabric/express_nodeJs/` folder) for Fabric

### Step 2
Edit the Supplychain application configuration file (from `examples\supplychain-app\configuration\samples` depnding on your choice of DLT Platform). This file will be similar to the BAF Configuration File which few additional changes like the `frontend: enabled` and `google_maps_api: XYZ123`, also the chart location must be `chart_source: "examples\supplychain-app\charts"`

### Step 3
Ensure that following are completed already:
* For Corda platform, the CorDapps are installed by using `platforms\r3-corda\configuration\deploy-cordapps.yaml` playbook.
* For Fabric platform, the chaincodes are installed by using `platforms\hyperledger-fabric\configuration\chaincode-install-instantiate.yaml` playbook.

### Step 4
Execute the ansible playbook

` ansible-playbook examples\supplychain-app\configuration\deploy-supplychain-app.yaml -e "@path-to-app.yaml"`

### Step 5
Wait for the pods to come up. Then access the frontend and API endpoints at:
* For Corda Manufacturer Frontend (using Ambassador): https://manufacturerweb.rc.demo.aws.blockchaincloudpoc.com:8443/
* For Corda Manufacturer API (using Ambassador): https://manufacturerapi.rc.demo.aws.blockchaincloudpoc.com:8443/
* For Fabric Manufacturer Frontend (using HAProxy): https://manufacturerweb.hf.demo.aws.blockchaincloudpoc.com/
* For Fabric Manufacturer API (using HAProxy): https://manufacturerapi.hf.demo.aws.blockchaincloudpoc.com/

---

**NOTE**: Replace `manufacturer` with other organization names for the other API and frontends. 

The domain suffix depends on what you have configured while setting up the DLT platform.
