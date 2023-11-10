[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: create/console_assets
 This role creates the json files and zip for importing into Fabric Operations Console

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Create CA directory if it does not exist
This task creates the Directory needed for CA files
##### Input Variables
    path: <path of the directory>
    state: directory

#### 2. Get CA data info
This task gets CA info from public url
##### Input Variables
    url: Public URL of the CA server    
    validate_certs: no (so that https can be accessed without certs)
    return_content: yes (so that the response is returned as is)
##### Output Variables
    url_output: contains the response from the CA Server

#### 3. Set ca_info variable
This task sets the ca_info with the json output from above task
##### Output Variables
    ca_info: contains the json from the CA Server

#### 4. Create json file for ca components
This task creates the json files for CA servers
##### Input Variables
    type: ca    
    conponent_name: <name of the ca file>
##### when
    item.services.ca is defined (only when ca server are there in network.yaml)

#### 5. Create Orderer directory if it does not exist
This task creates the Directory needed for Orderer json files
##### Input Variables
    path: <path of the directory>
    state: directory

#### 6. Create json file for orderer components
This task creates the json files for Orderers
##### Input Variables
    type: orderer    
    conponent_name: <name of the orderer file>
##### loop
    item.services.orderers (on all orderers)
##### when
    item.type == orderer

#### 7. Create Org directory if it does not exist
This task creates the Directory needed for OrgMSP json files
##### Input Variables
    path: <path of the directory>
    state: directory

#### 8. Create json file for orgmsp components
This task creates the json files for Org MSP
##### Input Variables
    type: org    
    conponent_name: <name of the msp>

#### 9. Create Peer directory if it does not exist
This task creates the Directory needed for peer json files
##### Input Variables
    path: <path of the directory>
    state: directory

#### 10. Create json file for peer components
This task creates the json files for Peers
##### Input Variables
    type: peer    
    conponent_name: <name of the peer file>
##### loop
    item.services.peers (on all peers)
##### when
    item.type == peer

#### 11. Create zip file
This task creates a single zip for bulk import on console
##### Input Variables
    path: <path of the directory to be zipped>
    dest: <destination zip file path>
    format: zip
