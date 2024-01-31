[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Troubleshooting Bevel

Like any software program, Bevel also may not work correctly first time; this guide helps to troubleshoot some of the common problems faced when using Bevel first time.

!!! tip

    When deploying a network using Bevel, it is common for various kubernetes pods and jobs to undergo an initialization phase, where they take some time to start. Bevel's automation, powered by Ansible, diligently waits for these components to reach a state of "Running" or "Succeeded" before proceeding with subsequent deployment steps. During this process, you might encounter messages like "FAILED - RETRYING: ...". This is not a bug.

Troubleshooting in Bevel involves understanding and managing the retry mechanism embedded in the [Ansible](../concepts/ansible.md) component. Each individual component has a retry count, and this count can be configured to suit the specific requirements of your network in the configuration file `network.yaml`. Typically, when everything is operating as expected, the components successfully transition to the desired state within 10-15 retries.

To facilitate efficient troubleshooting, it's advisable to monitor the components during the retry attempts. 
!!! example
    From a new terminal window, execute
    ```bash
    kubectl get pods -A -w
    ```
    If any pod/job is showing error or getting restarted then check the logs
    ```bash
    kubectl logs notification-controller-644f548fb6-r8tx9 -n flux-dev
    ```

This proactive approach allows you to inspect the status of the components before the maximum retry count is reached, potentially avoiding unnecessary wait times until an error or failure message appears in the Ansible logs. By leveraging this understanding of the retry mechanism, you can streamline the troubleshooting process and ensure a smoother deployment experience with Bevel.

!!! important

    Before starting the troubleshooting, do check that you have used all the supported [software/tool versions](./tool-versions.md) correctly.

## Flux Errors

`invalid apiVersion "client.authentication.io/v1xxxx`
: Check that you have compatible Kubernetes, kubectl versions and correct kubeconfig file.

`Unable to mount config-map git-auth-xxxx`
: Gitops private key file path is wrong or file is unreadable by Ansible controller. Check the `gitops.private_key` in network.yaml value is an absolute path, and the file is readable by the Ansible controller. 

`Unable to clone repository`
: Correct permissions have not been given to the gitops public key or your access token. Check that correct permissions are given as per [this tutorial](../tutorials/dev-prereq.md#setting-up-github).
Also, check the `gitops.git_url` is either correct SSH (`ssh://git@github.com/<username>/bevel.git`) or HTTPS (`https://github.com/<username>/bevel.git`) clone address of the git repository. 
It may be that your Kubernetes has SSH is blocked, in which case use HTTPS instead.

`No such file or directory`
: Files are not getting committed to the git repo from Ansible controller. Check there are no errors when you do `git commit` manually from the `bevel` directory in your Ansible controller or the docker container. Also, check the `git branch` is same as that you have configured in `network.yaml`.

## Hyperledger Fabric Errors

`CA pod is in Init:Crashloopbackoff state`
: Issue with Vault connectivity. If the pod `ca-xxxx-xxx` has status as `Init:Crashloopbackoff`, check the logs of the init container `ca-certs-init` of this pod. This can be checked using the command `kubectl logs ca-xxxx-xxx -c ca-certs-init -n supplychain-net`. Ensure Vault Service is running and correct Vault address was used (do not use 127.0.0.1 or localhost).

: Issue with Vault authentication. If the logs mention "access denied", make sure that the `xxx-vaultk8s-job-yyyy` and `xxx-cacerts-job-yyyy` has completed successfully. Any Vault authentication problem is because of running different configurations `network.yaml` on the same Vault. Please ensure that you reset the network before re-running with a different network.yaml.

`pod has unbound immediate PersistentVolumeClaims`
: Storgeclass was not created or is not working. Check that you haven't modified any storage class templates, then check `network.organization.cloud_provider` for incorrect cloud provider. If you have modified storage class, please make sure that the storage class works with the mentioned cloud provider under `network.organization.cloud_provider`.

`Create Channel pod is in Crashloopbackoff`
: Non-accessibility of proxy URL(s). Check the logs of the pod `createchannel-CHANNEL_NAME-xxx`. This can be checked using the command `kubectl logs createchannel-CHANNEL_NAME-xxx -n ORG_NAME-net`. If the logs mentions at the end  `Error: failed to create deliver client: orderer client failed to connect to ORDERER_NAME.EXTERNAL_URL_SUFFIX:443:failed to create new connection: context deadline exceeded` then, check the external URL suffix being available and check its access from the security groups of the VPC.

`Ansible playbook failed but no createchannel/joinchannel pod is visible`
: Job failed more than 6 times due to an error. All jobs in Bevel disappear if they failed for 6 times. To re-run the jobs, follow this
```bash
# Get all the helmreleases for that namespace
kubectl get hr -n ORG_NAME-net
# Then delete the corresponding helmrelease
kubectl delete hr createchannel-xxx -n ORG_NAME-net 
``` 
and then wait for the pod `createchannel-CHANNEL_NAME-xxx` to come up. Now, you can check the failure logs and debug.

`chaincode-install-xxxx-yyyy pod is in Crashloopbackoff`
: Check the logs as per above, and if the chaincode git credentials are wrong/absent. Check the git credentials under `network.organization.services.peer.chaincode.repository` for possible incorrect credentials.

`genesis block file not found open allchannel.block: no such file or directory`
: The orderer certificates aren't provided/non-accessible/incorrect. This error comes when the orderer certificate mentioned in the orderer block `network.orderers[*].certificate` is invalid, the path not readable or contains the wrong tls certificate of orderer. Fix the errors and reset and re-run the playbook.

## Hyperledger Indy Errors

`Ansible vars or dict object not found, domain genesis was not created`
: network.yaml not properly configured. Check `organisation.service.trustees`,  `organisation.service.stewards` and `organisation.service.endorsers` is properly configured for the failing `organisation` in your `network.yaml`. Refer to [Indy config file](../guides/networkyaml-indy.md) for more details.

`Vault Access denied, Root Token invalid, Vault Sealed`
: If the logs mention "access denied", make sure that the Vault authentications were created correctly by checking all the tabs on Vault UI. Any Vault authentication problem is because of running different configurations `network.yaml` on the same Vault. Please ensure that you reset the network before re-running with a different network.yaml.

`Ansible vars or dict object not found, pool genesis was not created`
: network.yaml not properly configured. Check `organisation.service.trustees`,  `organisation.service.stewards` and `organisation.service.endorsers` is properly configured for the failing `organisation` in your `network.yaml`. Refer to [Indy config file](../guides/networkyaml-indy.md) for more details.

`nodes cannot connect with each other|Port/IP blocked from firewall`
: You can check the logs of node pods using: `kubectl logs -f -n university university-university-steward-1-node-0`. Properly configure the required outbound and inbound rules for the firewall settings for `Ambassador Pod`. E.g.if you using AWS the firewall setting for the `Ambassador Pod` will be K8S Cluster's `worker-sg` Security Group.

`Not able to connect to the indy pool`
: Ambassador IP does not match the PublicIps provided in network.yaml. Check the `Ambassador Host's IP` using  `host <Ambassador Public URL> `  and verify if the same is present in the `PublicIps:` section of your `network.yaml`.
Also, the Port/IP may be blocked from firewall. Properly configure the required outbound and inbound rules for the firewall settings for `Ambassador Pod`.E.g. if you using AWS the firewall setting for the `Ambassador Pod` will be K8S Cluster's `worker-sg` Security Group.

`Resource Temporarily Unavailable`
: Insufficient memory issues leads to RockDB getting locked. The `steward node pods` are not getting sufficient memory to turn up the RocksDB service hence it results in the DB getting locked. Recommedation is to either scale up the k8s nodes or increase the memory of existing k8s nodes. 

## R3 Corda Checks

`Destination directory, example: /home/bevel/build/corda/doorman/tls, does not exist`
: Folder to copy tls certs does not exist. `network.network_services.certificate` value is either misspelled or directory doesn't exist.

`Vault timeout or related error`
: Vault was unavailable due to connection issues.Please verify **all** Vault configuration field in the `network.yaml`. Additionally check if the Vault service/instance is online and reachable from Kubernetes cluster.

`Doorman/NMS are unreachable HTTP error`
: URI/URL could be misconfigured in the `network.yaml` or the services themselves are not running. Check logs of dooeman/networkmap pod and debug.

`AnsibleUndefinedVariable: 'dict object' has no attribute 'corda-X.X'`
: Corda version is not supported. `network.version` value must be a supported Corda version. 

`Notary DB Failed`
: Notary registration has not happened properly or Notary store certificates failed.Check the notary registration container logs `kubectl logs <podname> -n <namespace> -c notary-initial-registration`. Check vault path '/credentials' for nodekeystore, sslkeystore and truststore certificates or check for error in logs of store-certs container of notary-registration job `kubectl logs <podname> -n <namespace> -c store-certs`.

## Quorum Errors

`Destination directory does not exist`
: Build directory does not exist or not accessible. Ensure the path `network.config.genesis` and `network.config.staticnodes` folder path is accessible(read and write) by ansible controller and is an absolute path.

`Error enabling kubernetes auth: Error making API request`
: Vault authentication issue. Ensure vault credentials are properly mentioned in `network.yaml` file.

`Retries exhausted/ pods stuck`
: Issue with Vault connectivity. If the pod `PEER_NAME-0` has the status as `Init:Crashloopbackoff`. Check the logs of the init container `certificates-init` of this pod using the command `kubectl logs PEER_NAME-0 -n ORG_NAME-quo -c certificates-init`. If the logs mention non accessibility of the Vault, make sure that the Vault is up and running and is accessible from the cluster.

`Could not locate file in lookup: network.config.genesis`
: Genesis file not present in the location/not added in configuration file. Ensure the path of genesis file of exising network is correct/accessible(read and write) by ansible controller and is an absolute path .

`Could not locate file in lookup: network.config.staticnodes`
: Staticnodes file not present in the location/not added in configuration file. Ensure the path  of staticnodes file of exising network is correct/accessible(read and write) by ansible controller and is an absolute path.
