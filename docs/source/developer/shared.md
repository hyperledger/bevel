[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Common Configurations
Hyperledger Bevel installs the common pre-requisites when the `site.yaml` playbook is run. To read more about setting up
DLT/Blockchain networks, refer [Setting up a Blockchain/DLT network](../operations/setting_dlt).

Following playbooks can be executed independently to setup the enviornment and can be found [here](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration)

1. **enviornment-setup.yaml**
Playbook enviornment-setup.yaml executes the roles which has tasks to install the binaries for:

    * kubectl
    * helm
    * vault client
    * aws-authenticator

2. **setup-k8s-enviorment.yaml**
Playbook setup-k8s-enviorment.yaml executes the roles which has tasks to configure the following on each Kubernetes cluster:

    * flux
    * ambassador    (if chosen)
    * haproxy-ingress   (if chosen)

All the common Ansible roles can be found at [platforms/shared/configuration/roles](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/roles)

* setup/ambassador
* setup/aws-auth
* setup/aws-cli
* setup/flux
* setup/haproxy-ingress
* setup/helm
* setup/kubectl
* setup/vault

Follow [Readme](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/roles/) for detailed information on each of these roles.
