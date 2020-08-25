## DLT Platform 

#### Components check ( like flux, namespaces, service accounts, storage classes)

- Get the list of pods 
~~~
kubectl get pods -A
~~~
- Check for namespaces.
~~~
kubectl get namespace
~~~
- Check for Storage Classes
~~~
kubectl get sc
~~~
- Check for Service Accounts
~~~
kubeclt get sa -A
~~~        
- To describe the pod
~~~
kubectl describe <pod name> -n <namespace>
~~~
- To check the logs of a particular container inside the pod.
~~~
kubectl logs -c <container name in pod> <pod name> -n <namespace>
~~~

**NOTE:** The pods and other components take some time to setup.You can check the components while the retries occurs.

#### Common check

Stage 1.
**Check for flux pods using**
~~~
kubectl get pods -A
~~~
Check the deployment file for any invalid details.
~~~
    kubectl edit deployment/flux-{{ network.env.type }}
~~~
- Check the branch details here if they are correct or not.

Eg.
~~~
kubectl edit deployment/flux-h
~~~
~~~
      ...
      .
        - --git-url=git@github.com:user/blockchain-automation-framework.git
        - --git-branch=branch-name
        - --git-path=platforms/hyperledger-fabric/releases/dev
      .
      ...
~~~
Look for the above section to verify the details of branch name and git url. Make sure that the files are successfully pushed to git repo.

Stage 2.
**Check for namespaces, service accounts and storage classes.**
Check flux logs using 
~~~
    kubectl logs -f <flux pod name>
~~~
Possible errors, if namespaces, storege classes etc are not generated.
Value files are not properly generated or not properly pushed.
- Check whether git branch is right.
- Check whether the git credentials are right.

#### Platform specific check
##### Fabric ( Specific components check like ca tools, ca server, orderer and peer)

Stage 3. 
**Check for ca-server.**
Check if the pod is up and running.
If not, Check flux-helm operator  logs..
Possible errors
- Value files are not generated right. Release failed

To check a helm release
~~~
    kubectl describe helmrelease <helm release name> -n <namespace>
~~~
To rerun the pod.
- Delete the helm release
~~~
    kubectl delete hr <helm release name> -n <namespace>
~~~
Flux will relaunch the pod. Check for the logs.

Eg. 
~~~
kubectl describe helmrelease ch-net-ca -n ch-net
.
.
Status:
  Conditions:
    Last Transition Time:  2020-08-19T08:50:47Z
    Last Update Time:      2020-08-19T08:50:47Z
    Message:               helm install succeeded
    Reason:                HelmSuccess
    Status:                True
    Type:                  Released
    Last Transition Time:  2020-08-19T08:50:42Z
    Last Update Time:      2020-08-19T09:30:07Z
    Message:               successfully cloned git repo
    Reason:                GitRepoCloned
    Status:                True
    Type:                  ChartFetched
  Observed Generation:     1
  Release Name:            ch-net-ca
  Release Status:          DEPLOYED
  Revision:                2a61919e1393e95d17e7a6a0e1323459b57cf0f2
  Values Checksum:         b8c1fbc8ae2bad4626ceec30222ff9410eb79ddb2c3c664266661316478aaf83
Events:
  Type    Reason       Age                  From           Message
  ----    ------       ----                 ----           -------
  Normal  ChartSynced  41m                  helm-operator  Chart managed by HelmRelease processed
  Normal  ChartSynced  34m (x3 over 39m)    helm-operator  Chart managed by HelmRelease processed
  Normal  ChartSynced  2m52s (x7 over 20m)  helm-operator  Chart managed by HelmRelease processed
  Normal  ChartSynced  61s (x3 over 6m41s)  helm-operator  Chart managed by HelmRelease processed
  Normal  ChartSynced  45s (x15 over 39m)   helm-operator  Chart managed by HelmRelease processed
  Normal  ChartSynced  21s (x15 over 41m)   helm-operator  Chart managed by HelmRelease processed
 .
 .
 ~~~
 Given above is a snippet of CA's helm release. One can check the deployment status as well check if the vault, git and other respective info is correctly generated in the helm release.
 If there are some incorrect values in the helm release , it means that the values files were incorrectly generated and pushed.

Stage 4.
**Check for orderer Pod.**
Check if the pod is up and running. If not, Check flux-helm operator logs..
Possible errors
- Value files are not generated right. Release failed

If the orderer pod is in crashloopbackoff or in Error state, check the logs of orderer.
Common possible issues include
- Certificate errors. Check if the proper certificates are generated (or updated certificates are used).
- Check whether the certificates are present at proper paths in the vault or if the certificates are properly fetched.
- If you see the error message remote error: tls: bad certificate on the client side, it usually means that the TLS server has enabled client authentication and the server either did not receive the correct client certificate or it received a client certificate that it does not trust. Make sure the client is sending its certificate and that it has been signed by one of the CA certificates trusted by the peer or orderer node.


Stage 5.
**Check for peers**
Check if the pod is up and running. If not, Check flux-helm operator logs..
Possible errors
- Value files are not generated right. Release failed
For further details check the pod logs or describe the helm release files

Stage 6.
**Create channel/ Join channel**
Check if pod is up and running, If not Check Flux logs
Possible errors:
- Check whether the orderer and peer are able to talk to each other
- check if the orderer and peer urls are correct.
- Error: failed to create deliver client: orderer client failed to connect to <url>:7050: failed to create new connection: context deadline exceeded

Not able to reach orderer, Check orderer logs for more details.
Backtrace it, check if ambassador is working 

- got unexpected status: BAD_REQUEST -- error authorizing update: error validating DeltaSet: policy for [Group] /Channel/Application not satisfied: Failed to reach implicit threshold of 1 sub-policies, required 1 remaining

The most common reasons for are:

a) This identity is not in the organization's administrator list.

b) The organization certificate is not effectively signed by the organization's CA chain.

c) The organization that the orderer does not know about identity.

Stage 7. 
**Achor Peers**

Check peer logs, filter results using grep "anchor"
If anchor peers are successful, you should find the list in the peer logs.

     kubectl logs <pod name> -n <namespace> | grep anchor
The output should have the list of the anchor peers.
 
Stage 8.
**Install Chaincode/ Instantiate Chaincode**
Check Flux logs.
If Pod is not up and running backtrace to which component is creating issue.

**NOTE**:
If the components are not able to connect to each other, there could be some issue  with load balancer. Check the haproxy or external DNS logs for more debugging.

If any pod/component of the network is not running (in crashloopbackoff or in error state) or is absent in the get pods list.
- Check the flux logs if it has been deployed or not.
- Check the helm release. Check the status as well as if the key-values are generated properly.
- For further debugging check for pod/container logs.
- IF components are there but not able to talk to each, check whether the ambasssador/ haproxy is working properly, urls are properly mapped and ports are opened for communication or not.

##### Final network validity check.

For final checking of the validity of the fabric network.

1. Create a cli pod for any organization.Use this sample template. 
~~~
    metadata:
      namespace: <namespace>
      images:
        fabrictools: hyperledger/fabric-tools:2.0
        alpineutils: index.docker.io/hyperledgerlabs/alpine-utils:1.0
    storage:
      class: <storage class name>
      size: 256Mi
    vault:
      role: vault-role
      address: <vault address>
      authpath: <auth path>
      adminsecretprefix: <Path to admin secret Prefix>
      orderersecretprefix: <Path to orderer secret prefix>
      serviceaccountname: <Service account name>
      imagesecretname: regcred
      tls: false
    peer:
      name: <peer name>
      localmspid: <msp id of peer>
      tlsstatus: true
      address: <peer address>
    orderer:
      address: <orderer address>
~~~
2. To install the cli.
~~~
    helm install -f cli.yaml /blockchain-automation-framework/platforms/hyperledger-fabric/charts/fabric_cli/ -n <name>
~~~
3. Get the cli pod.
~~~
    export CLI=$(kubectl get po -n ${ORG1_NS} | grep "cli" | awk '{print $1}')
~~~
4. Copy the cli pod name from the output list and enter the cli using.
~~~
    kubectl exec -it $CLI -n <namespace> -- bash
~~~   
5. To see which chaincodes are installed 
~~~
    peer chaincode list --installed
~~~
6. Check if the chaincode is instantiated or not
~~~
    peer chaincode list --instantiated -C allchannel
~~~
6. Execute a transaction
For init:
~~~
peer chaincode invoke -o <orderer url> --tls true --cafile <path of orderer tls cert> -C  <channel name> -n <chaincode name> -c '{"Args":["init",""]}'
~~~
Upon successful invocation, should display a `status 200` msg.
