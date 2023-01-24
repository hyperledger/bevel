[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Platform Releases
Hyperledger Bevel follows a [Gitops](https://www.weave.works/technologies/gitops/) approach for deploying and maintaining environment specific platform configurations. For each environment in which the components are deployed, you will maintain a separate sub-directory under this directory in the format...
```
└── releases
    ├── dev
    │   └── org1
    │        └── org1-database.yaml
    │            
    └── stg
        └── org1
            └── org1-database.yaml

```

For more information, please read [the documentation](https://www.weave.works/technologies/gitops/) on the GitOps approach provided by Weave Works.