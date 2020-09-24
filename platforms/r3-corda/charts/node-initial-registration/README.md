# NODE INITIAL REGISTRATION

Following chart contains Kubernetes job which is used for performing initial-registration for the node from doorman.

For more information read [corda node](https://docs.corda.net/releases/release-V3.3/key-concepts-node.html)

To find more details on initial registration [here](https://docs.corda.net/releases/release-V3.3/permissioning.html)

This chart has following structue:
```
  .
  ├── node-initial-registration
  │   ├── Chart.yaml
  │   ├── templates
  │   │   ├── _helpers.tpl
  │   │   └── job.yaml
  │   └── values.yaml
```

Type of files used:

```
charts.yaml       : A YAML file containing information about the chart
_helpers.tpl      : A place to put template helpers that you can re-use throughout the chart
values.yaml       : This file contains the default values for a chart
job.yaml          : A Job creates one or more Pods and ensures that a specified number of them successfully terminate. 
```


## Running the chart

Pre-Requisite: Before deploying the chart please ensure you have Doorman and Node's database up and running. 

- Deploy Doorman & Node's Database by following steps from documentation 
- Create secrets for the node by following steps from documentation 
- Create a values-node.yaml for the chart with a minimum set of keys, for template references use values.yaml present in the respective chart
- Create aws cli script to transfer artmis folder (which gets created by corda node) to and from AWS s3  

Install the chart with:

```
helm install --values=${PATH_TO_VALUES}/<node name>/values-node.yaml ${PATH_TO_HELMCHARTS}/node-initial-registration --name <helm name> --kube-context=<kube context> --namespace=<node namespace>
```

If you need to delete the chart use:

```
helm delete --purge <helm name> --kube-context=<kube context>
```

# Chart Functionalities

## job.yaml 

Contains following containers:

### Main Containers: 

1. corda-node: 	This container is used for running corda jar.  
  Tasks performed in this container:
- Setting up enviroment variables required for corda jar
- Import self signed tls certificate (if used) of doorman and networkmap, since java only trusts certificate signed by well known CA  
- Import self signed tls certificate of H2, since java only trusts certificate signed by well known CA 
- Change password of nodekeystore.jks,sslkeystore.jks ,truststore.jks
- Command to run corda jar with --initial-registration to perform initial registration with doorman, we are setting javax.net.ssl.keyStore as ${BASE_DIR}/certificates/sslkeystore.jks since keystore gets reset when using h2 ssl

2. store-certs:  This container is is used for putting certificate into the vault  
  Tasks performed in this container
- Loop to check if certificate and check file is generated 
- Put certificates obtained after perfoming initial-registration is added in vault

### Init-containers:

1. init-nodeconf: This container is used for creating node.conf which is used by corda node.  
   For more details on how to make node.conf read [node configuration](https://docs.corda.net/releases/release-V3.3/corda-configuration-file.html)
   Tasks performed in this container

- Delete previously created node.conf, and create a new node.conf
- Set env to get secrets from vault
- Save keyStorePassword & trustStorePassword from vault
- Save dataSourceUserPassword from vault
- Create node.conf according to values specified by users using values.yaml

2. init-downloadcordajars: This container is used for downloading corda jar  
   For more details on read [corda v3.3](https://github.com/corda/corda/tree/release-V3.3)
   Tasks performed in this container

-  Download corda jar if it doesnt exist

3. init-certificates:  This container is used for downloading certficate from vault  
   For more details on read [Network permissioning](https://docs.corda.net/releases/release-V3.3/permissioning.html)
   Tasks performed in this container

- Setting up env to get secrets from vault
- To perform check if certificate are already present in vault, if yes then exit
- Get custom nodekeystore.jks from vault, if provided
- Get network-map-truststore.jks from vault
- When using h2-ssl with private certificate, download the certificate  (To import in ca cert in main corda container)
- When using doorman and networkmap in TLS: true, and using private certificate then download certificate(To import in ca cert in main corda container)
- When using custom sslKeystore while setting in node.conf
- To download jars from git repo, download private key (corresponding public key to be added in git repo)
- Get aws access key id and secret access key, it is used for accessing AWS s3 for artmis folder 

4. init-credential: This container is used for getting passwords of keystore from vault  
  Tasks performed in this container
- Setting up env to get secrets from vault
- Get keystore passwords from vault

5. init-healthcheck: This container is used for performing health check  
  Tasks performed in this container
- perform health check if db is up and running before starting corda node
