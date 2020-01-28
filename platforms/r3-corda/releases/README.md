# Platform Releases

The Blockchain Automation Framework follows a [Gitops](https://www.weave.works/technologies/gitops/) approach for deploying and maintaining environment specific platform configurations. For each environment in which the components are deployed, you will maintain a separate sub-directory under this directory in the format...
```
└── releases
    ├── dev
    │   └── Doorman
    │        └── doorman.yaml
    │            
    └── stg
        └── Doorman
            └── doorman.yaml

```

For more information, please read [the documentation](https://www.weave.works/technologies/gitops/) on the GitOps approach provided by Weave Works.

## Description
* **namespace.yaml**: This creates deployment files for namespaces for each node in the network
* **reviewer_rbac.yaml**: This creates deployment files for clusterrolebinding for each node in the network.
* **vault-reviewer.yaml and vaultAuth.yaml**: This creates deployment files for (service accounts) vault-auth nad vault-reviewer for each node in the network.
* **db.yaml,job.yaml,node.yaml,doorman.yaml,nms.yaml**: This is of kind HelmRelease which creates deployment for the respective services.

**NOTE**: Once the values file created GitOps will automatically take the files and create the deployment in the cluster.
   