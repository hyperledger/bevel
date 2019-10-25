## About
This folder contains the common files as prerequisites used for the deployment of a R3 Corda or Hyperledger Fabric network. Deployment of a real R3 Corda or Hyperledger Fabric network should use files within either the path: platforms/r3-corda or platforms/hyperledger-fabric

## Folder structure
```
shared
|-- charts: this folder contains sub folders and various files needed in using Helm charts.
|-- configration: this folder contains a **network.yaml** file as the only input config file to be used in this project. All parameters defined in this file will later be leveraged in commands such as Ansible and Helm. It also contains various folders and files for Ansible playbooks.
|-- images: this folder contains various dockerFiles to pull down different DLT platforms' official docker images.
```
Currently, only the **playbooks** folder have the Ansible playbook files, all other folders are empty. Users new to this repo should go to the readme file in the **playbooks** folder.