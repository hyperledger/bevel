<a name = "configuring-prerequisites"></a>
# Configuring pre-requisites for The Blockchain Automation Framework

- [Ansible Inventory file](#Ansible_Inventory)
- [Docker Images](#docker)
- [Vault Initialization and unseal](#vaultunseal)
- [Ambassador](#ambassador)

<a name = "Ansible_Inventory"></a>
## Ansible Inventory file

In The Blockchain Automation Framework, we connect to Kubernetes cluster through the machine that run our Ansible playbooks and do not modify or connect to any other machine directly. The Blockchain Automation Framework's sample inventory file is located [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/inventory/ansible_provisoners). 

Add the contents of this file in your Ansible host configuration file (typically in file /etc/ansible/hosts).

Read more about Ansible inventory [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

<a name = "docker"></a>
## Docker Images

The Blockchain Automation Framework uses some custom-built docker images which are not available publicly (as of this release). These docker images need to be built by you and then uploaded to a docker registry like [https://hub.docker.com/](https://hub.docker.com/).

---
**NOTE:** The Blockchain Automation Framework recommends use of private docker registry for production use. The username/password for the docker registry can be provided in a **network.yaml** file so that the Kubernetes cluster can access the registry.

---
### Alpine Utils ###

Alpine-utils docker image is a light-weight utility image used in The Blockchain Automation Framework. It is mainly used as init-containers in The Blockchain Automation Framework Kubernetes deployments to connect to Hashicorp Vault to download certificates.

* To build the image, execute the following command from [platforms/shared/images](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/images) folder. 
```
sudo docker build -t alpine-utils:1.0 -f alpine-utils.Dockerfile .
```
* The above command will create an image with tag *alpine-utils:1.0*. If you want to upload this image to a registry, update the tag accordingly and then push to docker. Sample command is shown below:
```
sudo docker tag alpine-utils:1.0 adopblockchaincloud0502.azurecr.io/alpine-utils:1.0
sudo docker push adopblockchaincloud0502.azurecr.io/alpine-utils:1.0
```
### LinuxKit Base
Build the LinuxKit Base image from **platforms/r3-corda/images/linuxkit-base** by following [these instructions](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/images/linuxkit-base/Readme.md).

### Corda Doorman
Build the Corda Doorman image from **platforms/r3-corda/images/doorman** by following [these instructions](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/images/doorman/Readme.md).

### Corda Networkmap
Build the Corda Networkmap image from **platforms/r3-corda/images/networkmap** by following [these instructions](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/images/networkmap/Readme.md).

### Corda Node
Build the Corda node image from **platforms/r3-corda/images** by following [these instructions](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/images/README.md).

<a name = "vaultunseal"></a>
## Unseal Hashicorp Vault 

Hashicorp Vault is one of the pre-requisites for The Blockchain Automation Framework. If not initialised and unsealed already, complete the following steps to unseal and access the Vault.

* Install Vault client. Follow the instructions on [Install Vault](https://www.vaultproject.io/docs/install/).

* Set the environment Variable **VAULT_ADDR** to the Vault service. Note that this service should be accessible from the host where you are running this command from, as well as the Ansible controller and the Kubernetes nodes.
```
export VAULT_ADDR=http://my-vault-server:9000
```
* Now execute the following:
```
vault operator init -key-shares=1 -key-threshold=1
```
It will give following output:
```
Unseal Key 1: << unseal key>>

Initial Root Token: << root token>>
```
Save the root token  and unseal key in a secure location. This root token is to be updated in the The Blockchain Automation Framework's network.yaml file before running the Ansible playbook(s) to deploy the DLT network.

* Unseal with the following command:
```
vault operator unseal << unseal-key-from-above >>
```
* Run this command to login and check if Vault is unsealed: 
```
vault login << give the root token >>`
```

You may generate multiple root tokens at the time of initialising the Vault, and delete the one used in the network.yaml file as that may be visible in ansible logs.

<a name = "ambassador"></a>
## Ambassador

The Blockchain Automation Framework uses [Ambassador](https://www.getambassador.io/about/why-ambassador/) for inter-cluster communication. To enable The Blockchain Automation Framework Kubernetes services from one Kubernetes cluster to talk to services in another cluster, Ambassador needs to be configured as per the following steps:

* After Ambassador is deployed on the cluster (manually or using `platforms/shared/configuration/kubernetes-env-setup.yaml` playbook), get the external IP address of the Ambassador service.
```
kubectl get services -o wide
```
The output of the above command will look like this:
![Ambassador Service Output](../_static/ambassador-service.png)

* Copy the **EXTERNAL-IP** for **ambassador** service from the output.
---
**NOTE:** If Ambassador is configured by the playbook, then this configuration has to be done while the playbook is being executed, otherwise the deployment will fail.

---

* Configure your subdomain configuration to redirect the external DNS name to this external IP. For example, if you want to configure the external domain suffix as **test.corda.blockchaincloudpoc.com**, then update the DNS mapping to redirect all requests to ***.test.corda.blockchaincloudpoc.com** towards **EXTERNAL-IP** from above as an ALIAS.
In AWS Route53, the settings look like below (in Hosted Zones).
![Ambassador DNS Configuration](../_static/ambassador-dns.png)

