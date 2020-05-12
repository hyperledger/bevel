# Commands Reference
Below are various debugging commands that can be used

## Kubectl related debugging
* To setup KUBECONFIG environment variable
    ```
    export KUBECONFIG=PATH_TO_CLUSTER_KUBECONFIG_FILE
    Ex. export KUBECONFIG=~/.kube/config 
    /root/.kube/config is the default KUBECONFIG path
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
    ```
    kubectl get pods -n NAMESPACE
    Ex. kubectl get pods -n supplychain-net
    ```
* To get all pods in a cluster
    ```
    kubectl get pods --all-namespaces
    ```
* To check description of resource type (pod/service/pvc/HelmRelease)
    ```
    kubectl describe RESOURCE_TYPE RESOURCE_NAME -n NAMESPACE
    Ex. kubectl describe pvc ca-server-db-svc -n carrier-net
    Ex. kubectl describe sa vault-reviewer -n carrier-net
    ```
* To check logs of pod
    ```
    kubectl logs POD_NAME -n NAMESPACE
    Ex. kubectl logs flux-dev-123r45 -n default
    ```
* To check logs of container within a pod
    ```
    kubectl logs POD_NAME -c CONTAINER_NAME -n NAMESPACE
    Ex. kubectl logs ca-123r45 -c ca-certs-init -n carrier-net
    ```
* To execute a command in a running pod
    ```
    kubectl exec POD_NAME -n NAMESPACE -- COMMAND_TO_EXECUTE
    Ex. kubectl exec ca-tools-12345 -n carrier-net -- ls -a
    ```
* To execute a command in a container of a pod
    ```
    kubectl exec POD_NAME -c CONTAINER_NAME -n NAMESPACE -- COMMAND_TO_EXECUTE
    Ex. kubectl exec ca-tools-12345 -c ca-tools -n carrier-net -- ls -a
    ```

## Vault related debugging
* To access vault
    ```
    export VAULT_ADDR=
    export VAULT_TOKEN=
    vault read PATH_IN_VAULT
    Ex. vault read /secret/crypto/ordererOrganizations/carrier-net/ca/carrier-net-CA.key
    ```
* To list all enabled secrets engines with detailed output
    ```
    vault secrets list -detailed
    ```
* To enable an auth method at a given path
    ```
    vault auth enable -path PATH
    Ex. vault auth enable -path authpath
    ```
* To delete data on a given path in the key/value secrets engine
    ```
    vault kv delete PATH
    Ex. vault kv delete secret/creds
    ```
## Helm related debugging
* To list down all helm releases
    ```
    helm ls
    ```
* To upgrade helm client and Tiller server to the same version
    ```
    helm init --upgrade
    ```
* To delete an existing helm installation
    ```
    helm del --purge HELM_RELEASE_NAME
    Ex. helm del --purge carrier-ca
    ```

## Docker related debugging
* To login to docker registry
    ```
    docker login --username USERNAME --password PASSWORD URL
    Ex. docker login --username abcd --password abcd index.docker.io/hyperledgerlabs
    ```
* To pull images from docker registry
    ```
    docker pull IMAGE_NAME:TAG
    Ex. docker pull alpineutils:1.0
    ```
* To push images to docker registry
    ```
    docker push IMAGE_NAME:TAG
    Ex. docker push alpineutilstest:1.0
    ```
* To build an image from Dockerfile
    ```
    cd FOLDER_TO_DOCKERFILE
    docker build -t IMAGE_NAME:TAG -f DOCKERFILE_PATH PATH_TO_BUILD_CONTEXT
    Ex. docker build -t alpineutilstest:1.0 -f Dockerfile .
    ```

    ## Quorum related debugging
* To login to a quorum node 
    ```
    kubectl exec -it POD_NAME -n POD_NAMESPACE -c quorum -- geth attach "http://localhost:RPC_PORT"
    Ex. kubectl exec -it carrier-0 -n carrier-ns -c quorum -- geth attach "http://localhost:8546"
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

  ## Indy related debugging
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