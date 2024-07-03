[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Additional Pre-requisites for own Ansible Controller

!!! tip

    These are not needed when using **bevel-build** container as these comes pre-packaged.

## Ansible

Hyperledger Bevel automation is essentially Ansible scripts, so install Ansible on the machine from which you will deploy the DLT/Blockchain network. This can be a local machine as long as Ansible commands can run on it.

As per our [sequence diagram](../concepts/sequence-diagram.md), this machine (also called **Ansible Controller**) should have connectivity to the Kubernetes cluster(s) and the Hashicorp Vault service(s). And it is essential to install the [git client](https://git-scm.com/download) on the Ansible Controller. 

!!! warning Icon Filename

    Minimum **Ansible** version should be **2.12.6** with **Python3** 


Also, Ansible k8s module requires the **openshift python package (>= 0.12.0)** and some collections and jq. Install them with following commands

```bash
pip3 install openshift==0.13.1
ansible-galaxy install -r platforms/shared/configuration/requirements.yaml
apt-get install -y jq       #Run equivalent for Mac or Linux
```

!!! tip

    Ansible requires GNU tar. Install it on MacOS through Homebrew `brew install gnu-tar`


### Configuring Ansible Inventory file

In Hyperledger Bevel, we connect to Kubernetes cluster through the **Ansible Controller** and do not modify or connect to any other machine directly. Hyperledger Bevel's sample inventory file is located [here](https://github.com/hyperledger/bevel/tree/main/platforms/shared/inventory/ansible_provisioners). 

Add the contents of this file in your Ansible host configuration file (typically in file `/etc/ansible/hosts`).

Read more about Ansible inventory [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

### NPM

Hyperledger Bevel provides the feature of automated validation of the configuration file (network.yaml), this is done using ajv (JSON schema validator) cli. The deployment scripts install ajv using npm module which requires npm as prerequisite.

You can install the latest NPM version from official [site](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).

!!! note

    Bevel needs npm version >= 8.15.0
