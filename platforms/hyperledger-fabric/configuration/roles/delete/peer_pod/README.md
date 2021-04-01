## delete/peer_pod
This role deletes the peer pod
### main.yaml
### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Delete peer pod
This task deletes all genesis blocks from the Vault path
##### Input Variables

    *kubernetes: The Kubernetes config details for the organization