# Charts for Identity Application demo

## About
This folder contains helm charts which are used by the ansible playbooks for the deployment of the component. Each chart folder contain a folder for templates, chart file and the corresponding value file.

## Example Folder Structure ###
```
/webserver
|-- templates
|   |-- service.tpl
|   |-- statefulset.yaml
|-- Chart.yaml
|-- values.yaml
```

## Pre-requisites

 Helm to be installed and configured 

## Charts description

### 1. acme
- This folder contains chart templates and default values for creation of employer agent "Acme" for Aries Demo. This is not completely tested.
### 2. alice
- This folder contains chart templates and default values for creation of student agent "Alice" for Aries Demo.
### 3. faber
- This folder contains chart templates and default values for creation of university agent "Faber" for Aries Demo with Endorser permissions.
### 4. webserver
- This folder contains chart templates and default values for creation of Indy WebServer with Trustee permission.
