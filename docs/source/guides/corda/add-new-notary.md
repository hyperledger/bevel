[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-notary-to-existing-network-in-corda"></a>
# Adding a new Notary organization in R3 Corda Enterprise
Corda Enterprise Network Map (CENM) 1.2 does not allow dynamic addition of new Notaries to an existing network via API Call. This process is manual and involves few steps as described in the Corda Official Documentation [here](https://docs.corda.net/docs/cenm/1.2/updating-network-parameters.html#updating-the-network-parameters).
To overcome this, we have created an Ansible playbook. The playbook will update the Networkmap service so that a networkparameter update is submitted. But the `run flagDay` command has to be manual, as it is not possible to login to each Network Participant and accept the new parameters. Also, whenever the parameter update happens, it will trigger a node shutdown. Hence, the `run flagDay` command must be executed when no transactions are happening in the network.

`run flagDay` command must be run after the network parameters update deadline is over (+10 minutes by default). And this command must be run during downtime as it will trigger Corda node restart.

- [Prerequisites](#prerequisites)
- [Deploy new Notary Service](#deploy-new-notary-service)
- [Run playbook](#run-playbook)
- [Run parameter update](#run-parameter-update)

<a name = "prerequisites"></a>
## Prerequisites
To add a new Notary organization, Corda Idman and Networkmap services should already be running. The public certificates and NetworkTrustStore from Idman and Networkmap should be available and specified in the configuration file. 

!!! note
    Addition of a new Notary organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

<a name = "deploy-new-notary-service"></a>
## Deploy new Notary Service

Deploy the additional notary/notaries as separate organizations by following the guidance on [how to add new organizations here](./add-new-org.md). A sample network.yaml for adding new notary orgs can be found [here](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/configuration/samples/network-addNotary.yaml).

```yaml
--8<-- "platforms/r3-corda-ent/configuration/samples/network-addNotary.yaml:1:306"
```

<a name = "run-playbook"></a>
## Run Playbook

After the new notary is running, execute the playbook [add-notaries.yaml] (https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/configuration/add-notaries.yaml) with the same configuration file as used in previous step. This can be done using the following command

```
ansible-playbook platforms/r3-corda-ent/configuration/add-notaries.yaml --extra-vars "@path-to-new-network.yaml"
```

<a name = "run-parameter-update"></a>
## Run Parameter Update

The default networkparameters update timeout is 10 minutes, so wait for 10 minutes and then login to the networkmap ssh shell from the networkmap pod by running the commands below

```	
#Login to networkmap pod
kubectl exec -it networkmap-0 -n <cenm-namespace> -c main -- bash
root@networkmap-0:/opt/corda# ssh nmap@localhost -p 2222   # say yes for hostkey message
Password authentication
Password:					# Enter password at prompt
	    _   __     __  __  ___
	   / | / /__  / /_/  |/  /___ _____
	  /  |/ / _ \/ __/ /|_/ / __ `/ __ \
	 / /|  /  __/ /_/ /  / / /_/ / /_/ /
	/_/ |_/\___/\__/_/  /_/\__,_/ .___/
	                           /_/
	Welcome to the Network Map interactive shell.
	Type 'help' to see what commands are available.
	
	Thu Dec 03 17:40:37 GMT 2020>>> view notaries				# to view current notaries
	
# Run the following commands to execute flagday so that latest network parameters update is accepted
	
  Thu Dec 03 17:43:04 GMT 2020>>> view networkParametersUpdate   # to check the current update (will be empty if no updates are in progress)
	
	Thu Dec 03 17:43:57 GMT 2020>>> run flagDay                    # to initiate flagDay which will apply the networkParameters update only if the deadline has passed
	
	# If you want to cancel the update, run following
Thu Dec 03 17:45:17 GMT 2020>>> run cancelUpdate
```

Ensure that the Corda Node users know that the network parameters have changed which will trigger node restart automatically.
