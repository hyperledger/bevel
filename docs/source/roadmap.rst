BAF current roadmap
===================

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade: active, 21-05-01, 180d
    Corda Ent. OFE*: active, 21-06-01, 120d
    Fabric OFE*: active, 21-05-01, 120d
    Besu OFE*: active, 21-06-01, 60d
    Quorum OFE*: active, 21-06-15, 60d
    Ansible Decoupling: active, 21-06-20, 90d
    section Application
    Besu Ref App: active, 21-06-15, 60d

.. |pin| image:: https://github.githubassets.com/images/icons/emoji/unicode/1f4cc.png?v8
    :width: 15pt
    :height: 15pt
.. |tick| image:: https://github.githubassets.com/images/icons/emoji/unicode/2714.png?v8
    :width: 15pt
    :height: 15pt
.. |run| image:: https://github.githubassets.com/images/icons/emoji/unicode/1f3c3-2642.png?v8
    :width: 15pt
    :height: 15pt
.. |muscle| image:: https://github.githubassets.com/images/icons/emoji/unicode/1f4aa.png?v8
    :width: 15pt
    :height: 15pt
.. |hand| image:: https://github.githubassets.com/images/icons/emoji/unicode/270b.png?v8
    :width: 15pt
    :height: 15pt

OFE* : Operational feature enhancement

Legend of annotations:

+------------------------+------------------+
| Mark                   | Description      |
+========================+==================+
| |pin|                  | work to do       |
+------------------------+------------------+
| |tick|                 | work completed   |
+------------------------+------------------+
| |run|                  | on-going work    |
+------------------------+------------------+
| |muscle|               | stretch goal     |
+------------------------+------------------+
| |hand|                 | on hold          |
+------------------------+------------------+

General
-------
-  |run| Improve the existing ``readthedocs`` documentations
-  |run| Platforms and components upgrade:
    - |tick| Helm3 upgrade
    - |tick| Ambassador upgrade to 1.9.1
    - |tick| Complete molecule test scenarios for BAF R3 Corda OS and HL Fabric
    - |run| EKS upgrade to 1.19
    - |pin| Setup AWS cloudwatch exporter
    - |pin| Grafana and Promethus integration 
    - |pin| Flux version upgrade
    - |pin| Support for HashiCorp vault kv version 2
    - |pin| Improve logging/error messaging in playbooks

Platforms
---------
- |run| Reduce/decouple ansible dependecy in DLT platforms automation
- |run| Corda Enterprise operational feature enhancements
    - |tick| Enable mutiple notaries
    - |tick| R3 Corda version 4.7 upgrade
    - |tick| CENM version 1.5 upgrade
    - |run| Addition of notary node organisation to an existing network
    - |pin| HA Notary options
    - |pin| Enable PostGreSQL support for Corda Enterprise
    - |pin| CENM 1.5 services (Auth, Gateway and Zone) support
    - |hand| Removal of node
- |run| HL Fabric operational feature enhancements
    - |tick| HL Fabric 2.2 version upgrade
    - |tick| HL Fabric 1.4.8 upgrade
    - |tick| Multi Orderer organisation option for RAFT
    - |run| Feature for user identities
    - |run| External chaincode for Fabric 2.2.x
    - |pin| CI/CD piplelines for chaincode deployment
- |run| HL Besu operational feature enhancements
    - |tick| Enable DNS support
    - |tick| Addition of new validator node
    - |tick| Add tessera transaction manager support
    - |pin| Enable deployment without proxy (proxy as none option)
    - |run| Add clique consensus mechanism support 
    - |run| Add ethash consensus mechanism support
    - |hand| Enable bootnodes
- |run| Quorum operational feature enhancements
    - |tick| Version upgrade (Tessera and Quorum node) - v21.4.x 
    - |pin| Implement private transactions

Application
-----------
-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitymatrix`
