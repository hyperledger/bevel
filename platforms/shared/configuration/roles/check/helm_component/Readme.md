[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## ROLE: helm_component
This roles check if Pod is deployed or not and Job being deployed and completed or not.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Wait for {{ component_type }} {{ component_name }} in {{ namespace }}
Task to check if Job deployed and completed . This task will try for a maximum number of times which is described in network.yaml with an interval of 30 seconds between each try.
##### Input Variables

    *component_type: The type of resource/organisation.
    *component_ns: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**retries**:  It means this task will try to deploy the value file for a maximum time of retries mentioned i.e 10. 
**delay**:  It means each retry will happen at a gap of mentioned delay i.e 60 seconds.
**until**:  It runs until *component_data.resources|length* > 0 and component_data.resources[0].status.succeeded is defined and component_data.resources[0].status.succeeded == 1, i.e. it will keep on retrying untill said resource if deployed and completed within mentioned retries.
**when**:  It runs when *component_type* == "Job" , i.e. this task will run for Job .

##### Output Variables

    component_data: This variable stores the output whether the job is deployed and completed.

#### 2. Check for {{ job_title }} job on {{ component_name }}
Task to check if Job deployed and completed without the retry. 
##### Input Variables

    *component_type: The type of resource/organisation.
    *component_ns: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**when**:  It runs when *component_type* == "Job" , i.e. this task will run for Job .

##### Output Variables

    result: This variable stores the output whether the job is deployed and completed.

#### 3. Wait for {{ component_type }} {{ component_name }} in {{ namespace }}
Task to check if Pod deployed and running . This task will try for a maximum number of times as described in network.yaml or defined by the role calling it with an interval of 30 seconds between each try. Any role calling this task needs to have a variable called label_selectors. An implementation of label_selectors could be as follows  

```yaml
label_selectors:
      - app = {{ component_name }}
```
##### Input Variables

    *component_type: The type of resource/organisation.
    *component_ns: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**retries**:  It means this task will try to deploy the value file for a maximum time of retries mentioned i.e 10. 
**delay**:  It means each retry will happen at a gap of mentioned delay i.e 60 seconds.
**until**:  It runs untill *component_data.resources|length* > 0, i.e. it will keep on retrying untill said resource is up within mentioned retries.
**when**:  It runs when *component_type* == "Pod" , i.e. this task will run for Pod .

##### Output Variables

    component_data: This variable stores the output whether the pod is up and running or not.
