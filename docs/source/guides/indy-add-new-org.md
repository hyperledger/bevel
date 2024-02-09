[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-org-to-existing-network-in-indy"></a>
# Adding a new validator organization in Indy

  - [Prerequisites](#prerequisites)
  - [Add a new validator organization to a Bevel managed network](#add-new-org-bevel)
    - [Create Configuration File](#create-configuration-file-bevel)
    - [Run playbook](#run-playbook-bevel)
  - [Add a new validator organization to network managed outside of Bevel](#add-new-org-non-bevel)
    - [Create Configuration File](#create-configuration-file-non-bevel)
    - [Run playbook up-to genesis config map creation](#run-playbook-up-to-config-map-non-bevel)
    - [Provide public STEWARD identity crypto to network manager](#provide-public-crypto-non-bevel)
    - [Run rest of playbook](#run-rest-playbook-non-bevel)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Indy, an existing Indy network should be running, pool and domain genesis files should be available.

??? note "add organization"
    
    The guide is only for the addition of VALIDATOR Node in existing Indy network.

<a name = "add-new-org-bevel"></a>
## Add a new validator organization to a Bevel managed network

<a name = "create-configuration-file-bevel"></a>
### Create Configuration File

Refer [this guide](./networkyaml-indy.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details.

!!! important

    If you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-indy/configuration/samples/network-indy-newnode-to-baf-network.yaml) as a base.

```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indy-newnode-to-baf-network.yaml"
```

Following items must be added/updated to the network.yaml used to add new organizations

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| genesis.state  | Must be `present` for add org  |
| genesis.pool | Path to Pool Genesis file of the existing Indy network.|
| genesis.domain | Path to Domain Genesis file of the existing Indy network.|


Also, ensure that `organization.org_status` is set to `existing` for existing orgs and `new` for the new org.

<a name = "run-playbook-bevel"></a>
### Run playbook

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used to add a new organization to the existing Bevel managed network by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml"
```

<a name = "add-new-org-non-bevel"></a>
## Add a new validator organization to network managed outside of Bevel

<a name = "create-configuration-file-non-bevel"></a>
### Create Configuration File

Refer [this guide](./networkyaml-indy.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details.

For reference, use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-indy/configuration/samples/network-indy-newnode-to-non-baf-network.yaml)


```yaml
--8<-- "platforms/hyperledger-indy/configuration/samples/network-indy-newnode-to-non-baf-network.yaml"
```

Following items must be added/updated to the network.yaml used to add new organizations

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| genesis.state  | Must be `present` for add org  |
| genesis.pool | Path to Pool Genesis file of the existing Indy network.|
| genesis.domain | Path to Domain Genesis file of the existing Indy network.|


Also, ensure that `organization.org_status` is set to `new` for the new org.

<a name = "run-playbook-up-to-config-map-non-bevel"></a>
### Run playbook up-to genesis config map creation

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used with additional parameters specifying that a TRUSTEE identity is not present in the network configuration file and also NYMs (identities) of the new organization are not yet present on the domain ledger. This is achieved by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml" \
                                                                          -e "add_new_org_network_trustee_present=false" \
                                                                          -e "add_new_org_new_nyms_on_ledger_present=false"
```

<a name = "provide-public-crypto-non-bevel"></a>
### Provide public STEWARD identity crypto to network manager

Share the following public crypto from Vault with an organization admin (TRUSTEE identity owner).

| Path                | Key (for Vault)                        | Type             |
|-----------------------------------|--------------------------|------------------|
| /`org_name_lowercase`/stewards/`steward_name_lowercase`/identity/public/             | did                 | String           |
| /`org_name_lowercase`/stewards/`steward_name_lowercase`/node/public/verif_keys/      | verification-key                       | Verification Key |

Please wait for the organization admin to confirm that the identity has been added to the domain ledger with a STEWARD role until you proceed with the final step.

<a name = "run-rest-playbook-non-bevel"></a>
### Run rest of playbook

The [add-new-organization.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/add-new-organization.yaml) playbook is used with additional parameters specifying that a TRUSTEE identity is not present in the network configuration file and also NYMs (identities) of the new organization are already present on the domain ledger. This is achieved by running the following command

```
ansible-playbook platforms/shared/configuration/add-new-organization.yaml -e "@path-to-network.yaml" \
                                                                          -e "add_new_org_network_trustee_present=false" \
                                                                          -e "add_new_org_new_nyms_on_ledger_present=true"
```
