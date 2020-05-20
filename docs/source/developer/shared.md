# Common Configurations
The Blockchain Automation Framework installs the common pre-requisites when the `site.yaml` playbook is run. To read more about setting up
DLT networks, refer [Setting up a Blockchain/DLT network](../operations/setting_dlt).

Following playbooks can be executed independently to setup the enviornment and can be found [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration)

1. **enviornment-setup.yaml**
Playbook enviornment-setup.yaml executes the roles which has tasks to install the binaries for:

    * kubectl
    * helm
    * vault client
    * aws-authenticator
    * tiller

2. **kubernetes-env-setup.yaml**
Playbook kubernetes-env-setup.yaml executes the roles which has tasks to configure the following on each Kubernetes cluster:

    * flux
    * ambassador    (if chosen)
    * haproxy-ingress   (if chosen)

All the common Ansible roles can be found at [platforms/shared/configuration/roles](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/roles)

* setup/ambassador
* setup/aws-auth
* setup/aws-cli
* setup/flux
* setup/haproxy-ingress
* setup/helm
* setup/kubectl
* setup/tiller
* setup/vault

Follow [Readme](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/roles/) for detailed information on each of these roles.