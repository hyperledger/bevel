[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# Commands Reference
Below are some commands that can be used for debugging.

## Kubectl

* To setup KUBECONFIG environment variable
    ```bash
    export KUBECONFIG=PATH_TO_CLUSTER_KUBECONFIG_FILE
    # e.g. export KUBECONFIG=~/.kube/config where /root/.kube/config is the default KUBECONFIG path
    ```
* To check the cluster config file being used
    ```
    kubectl config view
    ```
* To check the current context
    ```
    kubectl config current-context
    ```
* To get all pods in a namespace
    ```bash
    kubectl get pods -n NAMESPACE
    # e.g. kubectl get pods -n supplychain-net
    ```
* To get all pods in a cluster
    ```
    kubectl get pods --all-namespaces
    ```
* To watch new pods creation in the cluster
    ```
    kubectl get pods --all-namespaces --watch
    ```
* To check description of resource type (pod/service/pvc/HelmRelease)
    ```bash
    kubectl describe RESOURCE_TYPE RESOURCE_NAME -n NAMESPACE
    # e.g. kubectl describe pvc ca-server-db-svc -n carrier-net
    # e.g. kubectl describe sa vault-reviewer -n carrier-net
    ```
* To check logs of pod
    ```bash
    kubectl logs POD_NAME -n NAMESPACE
    # e.g. kubectl logs flux-dev-123r45 -n default
    ```
* To check logs of container within a pod
    ```bash
    kubectl logs POD_NAME -c CONTAINER_NAME -n NAMESPACE
    # e.g. kubectl logs ca-123r45 -c ca-certs-init -n carrier-net
    ```
* To get all the helmreleases in a namespace
    ```bash
    kubectl get hr -n NAMESPACE
    # e.g. kubectl get hr -n carrier-net
    ```
* To delete a helmrelease so as to restart it in a namespace
    ```bash
    kubectl delete hr HELMRELEASENAME -n NAMESPACE
    # e.g. kubectl delete hr channel-carrier-allchannel -n carrier-net
    ```
* To execute a command in a running pod
    ```bash
    kubectl exec POD_NAME -n NAMESPACE -- COMMAND_TO_EXECUTE
    # e.g. kubectl exec ca-tools-12345 -n carrier-net -- ls -a
    ```
* To execute a command in a container of a pod
    ```bash
    kubectl exec POD_NAME -c CONTAINER_NAME -n NAMESPACE -- COMMAND_TO_EXECUTE
    # e.g. kubectl exec ca-tools-12345 -c ca-tools -n carrier-net -- ls -a
    ```

## Vault

* To access vault
    ```bash
    export VAULT_ADDR=<addess of the vault with port>
    export VAULT_TOKEN=<vault token>
    vault read PATH_IN_VAULT
    # e.g. vault read secretsv2/crypto/ordererOrganizations/carrier-net/ca/carrier-net-CA.key
    ```
* To list all enabled secrets engines with detailed output
    ```
    vault secrets list -detailed
    ```
* To enable an auth method at a given path
    ```bash
    vault auth enable -path PATH
    # e.g. vault auth enable -path authpath
    ```
* To delete data on a given path in the key/value secrets engine
    ```bash
    vault kv delete PATH
    # e.g. vault kv delete secretsv2/creds
    ```
## Helm
* To list down all helm releases
    ```
    helm ls -A
    ```
* To delete an existing helm installation
    ```bash
    helm uninstall HELM_RELEASE_NAME -n NAMESPACE
    # e.g. helm uninstall carrier-ca -n carrier-ns
    ```

## Docker

* To login to docker registry
    ```bash
    docker login --username USERNAME --password PASSWORD URL
    # e.g. docker login --username abcd --password abcd ghcr.io/hyperledger
    ```
* To pull images from docker registry
    ```bash
    docker pull IMAGE_NAME:TAG
    # e.g. docker pull alpineutils:1.0
    ```
* To push images to docker registry
    ```bash
    docker push IMAGE_NAME:TAG
    # e.g. docker push alpineutilstest:1.0
    ```
* To build an image from Dockerfile
    ```bash
    cd FOLDER_TO_DOCKERFILE
    docker build -t IMAGE_NAME:TAG -f DOCKERFILE_PATH PATH_TO_BUILD_CONTEXT
    # e.g. docker build -t alpineutilstest:1.0 -f Dockerfile .
    ```

## Quorum

* To login to a quorum node 
    ```bash
    kubectl exec -it POD_NAME -n POD_NAMESPACE -c quorum -- geth attach "http://localhost:RPC_PORT"
    # e.g. kubectl exec -it carrier-0 -n carrier-ns -c quorum -- geth attach "http://localhost:8546"
    ```
* Get all the paritipants present in the network after logging into the node (for raft consensus based cluster)
    ```
    raft.cluster
    ```
* Get node information (after logging into the node)
  ```
  admin.nodeInfo
  ```
* Get the peers attached to the current node (after loggin into the node)
  ```
  admin.peers
  ```
* Get the account details (after logging into the node)
  ```
  eth.accounts
  ```
* Get retrieves the list of authorized validators at the specified block (for ibft consensus based cluster)
  ```
  istanbul.getValidators(blockHashOrBlockNumber)
  ```

## Indy

* To access indy cli, in any terminal
    ```
    indy-cli
    ```
* To create a pool
    ```
     pool create local-pool gen_txn_file=<path of the genesis file>
    ```
* To connect the pool
    ```
    pool connect <pool name>
    ```
* To create a wallet
    ```
    wallet create <wallet name> <key>
    ```
* To open a wallet
    ```
    wallet open <wallet name> <key>
    ```
* To list the wallets
    ```
    wallet list
    ```
* To delete a wallet
    ```
    wallet delete <wallet name> 
    ```
* To create a new did
    ```
    did import <did file>
    ```
    ```
    did new
    ```
* To create a pool
    ```
    pool create <pool name> gen_txn_file=<pool_genesis_path>
    ```
* To open a pool
    ```
    pool connect <pool name>
    ```
* To list the pool
    ```
    pool list
    ```
* To execute a transaction on ledger
    ```
    ledger nym did=<did name> verkey=<key detail> role=<role name>
    ```
* To get the transaction details
    ```
    ledger get-nym did=<did name>
    ```