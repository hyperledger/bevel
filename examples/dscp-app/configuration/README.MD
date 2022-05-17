[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Vitalam-app Playbooks

## Overview
This folder contains ansible playbooks and their corresponding roles used for the deployment of APIs for dscp application.
These playbooks enables creation of value files and facilitate deployment of dscp APIs over a managed Kubernetes cluster.

## Prerequisites

To run the playbooks and deploy the APIs, following are the pre-requisites
1. Ansible and Git are required to be setup on the machine.
2. The DLT network setup should be complete using Hyperledger Bevel, which includes the GitOps setup.
3. A complete input configuration file: *network.yaml* as described in samples directory.

## Playbook Description 
There are following playbooks.

* `deploy-dscp-app.yaml` : Deploys the dscp APIs

## To Deploy the Vitalam APIs:

#### Step 1
Configure a `network.yaml` . Follow the comments in the samples folder to create the correct network configuration.

#### Step 2
Run the playbook with the following command

```
ansible-playbook deploy-dscp-app.yaml --extra-vars "@./network-dscp.yaml"
```

For multiple clusters, run the above command for each cluster's network.yaml
```
ansible-playbook deploy-dscp-app.yaml --extra-vars "@./network1.yaml"
ansible-playbook deploy-dscp-app.yaml --extra-vars "@./network2.yaml"
```
