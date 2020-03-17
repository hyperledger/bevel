## ROLE: k8-component
This roles check if Job deployed and completed or not.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Wait for {{ component_type }} {{ component_name }}
Task to check if Job deployed and completed . This task will try for a maximum of 10 times with an interval of 60 seconds between each try.
##### Input Variables

    *component_type: The type of resource/organisation.
    *component_ns: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**retries**:  It means this task will try to deploy the value file for a maximum time of retries mentioned i.e 10. 
**delay**:  It means each retry will happen at a gap of mentioned delay i.e 60 seconds.
**until**:  It runs untill *component_data.resources|length* > 0, i.e. it will keep on retrying untill said resource if deployed and completed within mentioned retries.
**when**:  It runs when *component_type* == "Job" , i.e. this task will run for Job .

##### Output Variables

    component_data: This variable stores the output whether the job is deployed and completed.

#### 2. Wait for {{ component_type }} {{ component_name }}
Task to check if Pod deployed and running . This task will try for a maximum of 10 times with an interval of 60 seconds between each try.
##### Input Variables

    *component_type: The type of resource/organisation.
    *component_ns: The organisation's namespace
    kubernetes.config_file: The kubernetes config file
    kubernetes.context: The kubernetes current context

**retries**:  It means this task will try to deploy the value file for a maximum time of retries mentioned i.e 10. 
**delay**:  It means each retry will happen at a gap of mentioned delay i.e 60 seconds.
**until**:  It runs untill *component_data.resources|length* > 0, i.e. it will keep on retrying untill said resource if up within mentioned retries.
**when**:  It runs when *component_type* == "Pod" , i.e. this task will run for Pod .

##### Output Variables

    component_data: This variable stores the output whether the pod is up and running or not.