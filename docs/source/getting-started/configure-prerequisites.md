[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configure Common Pre-requisites

- [GitOps Authentication](#gitops-authentication)
- [Unseal Hashicorp Vault](#unseal-hashicorp-vault)
- [Docker Images](#docker-images)

## GitOps Authentication

For synchronizing the Git repo with the cluster, Hyperledger Bevel configures Flux for each cluster. The authentication can be via SSH or HTTPS.

For **HTTPS**, generate a git access token and give that read-write access. Keep the token safe for use later. 

For GitHub, you can follow [these instrucitons](https://docs.github.com/en/enterprise-server@3.6/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) on how to create a token.

For **SSH**, run the following command to generate a private-public key pair named **gitops**.

```bash
cd ~/.ssh
ssh-keygen -q -N "" -f ./gitops
```

The above command generates an SSH key-pair: **gitops** (private key) and **gitops.pub** (public key).

!!! warning

    Ensure that the Ansible host has read-access to the private key file (gitops).


And add the public key contents (starts with **ssh-rsa**) as an Access Key (with read-write permissions) in your Github repository by following [this guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Unseal Hashicorp Vault 

The [Hashicorp Vault](../concepts/vault.md) must be initialised and unsealed. Complete the following steps to unseal and access the Vault.

* Install Vault client. Follow the instructions on [Install Vault](https://developer.hashicorp.com/vault/docs/install).

!!! important 

    Vault version should be > **1.13.1** and  <= **1.15.2**

* Set the environment Variable **VAULT_ADDR** as the Vault service. 

    ```bash
    export VAULT_ADDR=http://my-vault-server:9000
    ```
!!! tip

    Do not use 127.0.0.1 or localhost for any services like Kubernetes or Vault
!!! warning

    The port should be accessible from the host where you are running this command from, as well as the Ansible controller and the Kubernetes nodes.


* To initiliase the Vault, execute the following:
    ```bash
    vault operator init -key-shares=1 -key-threshold=1
    ```
    It will give following output:
    ```
    Unseal Key 1: << unseal key>>

    Initial Root Token: << root token>>
    ```
    Save the root token and unseal key in a secure location.

* Unseal with the following command:
    ```bash
    vault operator unseal << unseal-key-from-above >>
    ```
* Run this command to check if Vault is unsealed: 
    ```bash
    vault status
    ```

!!! tip

    It is recommended to use Vault auto-unseal using Cloud KMS for Production Systems. And also, rotate the root token regularly.

## Docker Images

Hyperledger Bevel provides pre-built docker images which are available on [GitHub Repo](https://github.com/orgs/hyperledger/packages?repo_name=bevel). Ensure that the versions/tags you need are available. If not, [ask a question](../contributing/asking-a-question.md).

!!! tip

    Hyperledger Bevel recommends use of private container registry for production use. The username/password for the container registry can be provided in a **network.yaml** file so that the Kubernetes cluster can access the registry.

### Corda Enterprise Docker Images
For Corda Enterprise, the *corda_ent_node* and *corda_ent_firewall* docker images should be built and put in a private docker registry. Please follow [these instructions](https://github.com/Accenture-BAF/corda-kubernetes-deployment/tree/main/docker-images) to build docker images for Corda Enterprise. 

The official Corda images are available on [Docker Hub](https://hub.docker.com/u/corda). These are evaluation only, for production implementation, please aquire licensed images from R3, upload them into your private container registry and update the tags accordingly.

Following Corda Docker Images are used and needed by Hyperledger Bevel.

* [Corda Network Map Service](https://hub.docker.com/r/corda/enterprise-networkmap) (Built as per [these instructions](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/images))
* [Corda Identity Manager Service](https://hub.docker.com/r/corda/enterprise-identitymanager)
* [Corda Signer](https://hub.docker.com/r/corda/enterprise-signer)
* [Corda PKITool](https://hub.docker.com/r/corda/enterprise-pkitool) (Built as per [these instructions](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/images))
* [Corda Notary](https://hub.docker.com/r/corda/notary) (Built as per [these instructions](https://github.com/hyperledger/bevel/tree/main/platforms/r3-corda-ent/images))
* Corda Node (Built as per [these instructions](https://github.com/Accenture-BAF/corda-kubernetes-deployment/tree/main/docker-images))
* Corda Firewall (Built as per [these instructions](https://github.com/Accenture-BAF/corda-kubernetes-deployment/tree/main/docker-images))
