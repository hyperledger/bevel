# Setting up a DLT network
Ansible playbooks are used to set up a DLT network. For this, [Ansible host and controller](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html) is first configured with the pre-requisites like kubectl, helm, vault, aws-cli and aws-auth (when cloud_provider is aws) and then the DLT network is setup as per the specifications mentioned in your configuration file.

| Platform-specific configuration file|
|---------------------------------|
| [Hyperledger-Fabric](./fabric_networkyaml.md)|
| [R3-Corda](./corda_networkyaml.md) 
| [ Hyperledger-Indy](./indy_networkyaml.md)
| [Quorum] |


## Executing Ansible playbook to setup DLT network
The playbook [site.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/)) can be run after the configuration file (for example: [network.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for Fabric) has been updated.
```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
```
The `site.yaml` playbook, in turn calls various playbooks depending on the configuration file and sets up your DLT network.

## Verify successful configuration of DLT network
To verify if the network is successfully configured or not check if all the kubernetes pods are up and running or not.
Below are some commands to check the pod's status:
* `Kubectl get pods --all-namespaces` : To get list of all the pods and their status across all the namespaces. It will look as below -
![](./../_static/ListOfPods.png)




* `Kubectl get pods -n xxxxx` : To check status of pods of a single namespace mentioned in place of xxxxx. Example

![](./../_static/GetOnePod.png)

* `Kubectl logs -f <PODNAME> -n <NAMESPACE>` : To check logs of a pod by giving required pod name and namespace in the command. Example-

![](./../_static/LogsOfPod.png)


For a successful setup of DLT Network all the pods should be in running state.


## Deleting an existing DLT network
The above mentioned playbook [site.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/site.yaml) ([ReadMe](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/README.md)) can be run to reset the network using the network configuration file having the specifications which was used to setup the network using the following command:
```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml" --extra-vars "reset=true"
```