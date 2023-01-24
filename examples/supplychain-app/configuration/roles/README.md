[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Supplychain Ansible Roles

## Overview
This folder contains ansible roles used for the deployment of APIs for supplychain application.

## Roles description ##

### 1. create_node_files_corda ###
- This role creates the Springboot-server and ExpresseAPI server value files for a Corda network for all Corda nodes as defined by the configuration file.
### 2. gen_api_components_corda ###
- This role generates the tempporary components.yaml file from the configuration file for Corda nodes. This components.yaml file contains the specification for springboot and expressapi services for each Corda nodes as defined by the configuration file.



