Roadmap
=======
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    R3 Corda Enterprise Version  :a1, 20-05-15  , 90d
    Besu Provisioning       :a2, 20-06-08  , 90d
    Couch DB     :after a1  , 60d
    
    section Application
    Quorum Ref App      :done, b1, 20-03-10, 60d
    Indy Ref App      :active, b2, after b1, 90d
    
    section Architecture
    Besu Blueprint      : 20-06-01, 60d
    Corda vEnterprise Blueprint : 20-06-01, 60d

## Blockchain automation framework roadmap for the release v0.5 and v0.6 broadly covers the following

Legend of annotations:

| Mark | Description |
| ------------- | ------------- |
| :pushpin: | work to do |
| :heavy_check_mark: | work completed |
| :runner: | on-going work |
| :muscle: | stretch goal |
| :hand: | on hold |

## General
- :heavy_check_mark: Minikube support for existing platforms
- :runner: Improve the existing `readthedocs` documentations

## Platforms
- :runner: Besu network provisioning
- :pushpin: Support for R3 Corda Enterprise Version
- :heavy_check_mark: Hyperledger Indy network provisioning
- :heavy_check_mark: Quorum network provisioning
- :heavy_check_mark:  Support for Hyperledger Fabric v2.0
- :heavy_check_mark:  Key storage and management
- :hand: Implementing couch DB

## Application
- :pushpin: Hyperledger Besu reference application
- :heavy_check_mark: Quorum supplychain application integration
- :heavy_check_mark: Hyperledger Indy reference application

## Architecture
- :pushpin: Besu architecture blueprint
- :pushpin: R3 Corda Enterprise Version architecture blueprint
- :hand: Couch DB architecture blueprint
 