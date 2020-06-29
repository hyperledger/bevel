# Platform Releases

The Blockchain Automation Framework follows a [Gitops](https://www.weave.works/technologies/gitops/) approach for deploying and maintaining environment specific platform configurations. For each environment in which the components are deployed, you will maintain a separate sub-directory under this directory in the format...
```
└── releases
    ├── dev
    │   └── IBFT
    │        └── namespace.yaml
    │            
    └── stg
        └── IBFT
            └── namespace.yaml

```

For more information, please read [the documentation](https://www.weave.works/technologies/gitops/) on the GitOps approach provided by Weave Works.

## Description
<!-- [TODO]: Release files description will go here  -->

**NOTE**: Once the values file created GitOps will automatically take the files and create the deployment in the cluster.
   