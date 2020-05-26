<a name = "adding-new-storageclass"></a>
# Adding a new storageclass
As storageclass templates vary as per requirements and cloud provider specifications, this guide will help in using a new storageclass which is not supported by Blockchain Automation Framework (BAF)

  - [Adding a new storage class for Hyperledger Fabric](#fabric)
  - [Adding a new storage class for R3-Corda](#corda)
  - [Adding a new storage class for Hyperledger Indy](#indy)
  - [Adding a new storage class for Quorum](#quorum)


<a name = "fabric"></a>
## Adding a new storage class for Hyperledger Fabric
---------------------------------------------------
To add a new storageclass for Hyperledger Fabric, perform the following steps:

1. Add the new storageclass template `sample_sc.tpl`, under `platforms/hyperledger-fabric/configuration/roles/create/storageclass/templates` with `metadata.name` (storageclass name) as the variable `sc_name`. For example,
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ sc_name }}
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  encrypted: "true"
```
2. Mention the template file, which you created above, under `platforms/hyperledger-fabric/configuration/roles/create/storageclass/vars/main.yaml` with a variable reference. For example,
```
sc_templates:
  sample-sc: sample_sc.tpl
```
3. Set the `type` variable to `sample-sc` (variable created in step2) in the task `Create Storage Class value file for orderers` and `Create Storage Class value file for Organizations`, located in `platforms/hyperledger-fabric/configuration/roles/create/storageclass/tasks/main.yaml`  


<a name = "corda"></a>
## Adding a new storage class for R3-Corda
---------------------------------------------------
To add a new storageclass for R3-Corda, perform the following steps:

1. Add the new storageclass template `sample_sc.tpl`, under `platforms/r3-corda/configuration/roles/create/k8_component/templates` with `metadata.name` (storageclass name) as the variable `component_name`. For example,
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  encrypted: "true"  
```
2. Mention the template file, which you created above, under `platforms/r3-corda/configuration/roles/create/k8_component/vars/main.yaml` with a variable reference. For example,
```
dlt_templates:
  sample-sc: sample_sc.tpl
```
3. Set the `component_type` and `component_name` variable to `sample-sc` (variable created in step2) in the task `Create storageclass`, located in `platforms/r3-corda/configuration/roles/create/storageclass/tasks/main.yaml`


<a name = "indy"></a>
## Adding a new storage class for Hyperledger Indy
---------------------------------------------------
To add a new storageclass for Hyplerledger Indy, perform the following steps:

1. Add the new storageclass template `sample_sc.tpl`, under `platforms/hyperledger-indy/configuration/roles/create/k8_component/templates` with `metadata.name` (storageclass name) as the variable `component_name`. For example,
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  encrypted: "true"  
```
2. Mention the template file, which you created above, under `platforms/hyperledger-indy/configuration/roles/create/k8_component/vars/main.yaml` with a variable reference. For example,
```
k8_templates:
  sample-sc: sample_sc.tpl
```
3. Set the `component_name` variable to `sample-sc` (variable created in step2) in the task `Create Storage Class`, located in `platforms/hyperledger-indy/configuration/deploy-network.yaml`

<a name = "quorum"></a>
## Adding a new storage class for Quorum
---------------------------------------------------
To add a new storageclass for Quorum, perform the following steps:

1. Add the new storageclass template `sample_sc.tpl`, under `platforms/quorum/configuration/roles/create/k8_component/templates` with `metadata.name` (storageclass name) as the variable `component_name`. For example,
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: kubernetes.io/aws-ebs
reclaimPolicy: Delete
volumeBindingMode: Immediate
parameters:
  encrypted: "true"  
```
1. Mention the template file, which you created above, under `platforms/quorum/configuration/roles/create/k8_component/vars/main.yaml` with a variable reference. For example,
```
dlt_templates:
  sample-sc: sample_sc.tpl
```
3. Set the `component_type` and `component_name` variable to `sample-sc` (variable created in step2) in the task `Create storageclass`, located in `platforms/quorum/configuration/roles/create/storageclass/tasks/main.yaml`