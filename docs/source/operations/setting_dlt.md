# Setting up a DLT network
Ansible playbooks are used to set up a DLT network. For this, [Ansible host and controller](https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html) is first configured with the pre-requisites like kubectl, helm, vault, aws-cli and aws-auth (when cloud_provider is aws) and then the DLT network is setup as per the specifications mentioned in your configuration file.

| Platform-specific configuration file|
|---------------------------------|
| [Hyperledger-Fabric](./fabric_networkyaml.md)|
| [R3-Corda](./corda_networkyaml.md) 
| [ Hyperledger-Indy](./indy_networkyaml.md)
| [Quorum](./quorum_networkyaml.md) |


## Executing provisioning script to setup DLT network

Use Docker build as given in [prerequisites](../prerequisites), then you can run the provisioning script to deploy the network after configuring the network specific configuration file.
```
# Run the provisioning scripts
docker run -it -v $(pwd):/home/blockchain-automation-framework/ hyperledgerlabs/baf-build bash
$ ./home/blockchain-automation-framework/run.sh
```
For detailed instructions on docker build, read [here](./developer/docker-build.md).
---
**NOTE:** This baf-build container should have connectivity to the Kubernetes cluster(s) and the Hashicorp Vault service(s). Which means, if your Vault is behind a bastion, you have to create the ssh-tunnel from inside the running baf-build container.

---

*Optional:* If you have create the **Ansible controller** manually, run the following command from the ansible machine
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
