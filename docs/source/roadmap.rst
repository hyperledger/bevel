BAF current roadmap
===================

.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade : active, 21-09-01, 180d
    CENM v1.5 services : active, 21-09-27, 90d
    Fabric OFE*: active, 21-10-04, 120d
    Besu OFE*: active, 21-09-27, 60d
    Quorum OFE*: active,crit, 21-09-27, 90d
    Ansible Decoupling: active, 21-09-01, 150d
    section Application
    Besu Ref App: active, 21-09-15, 120d

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
    - |tick| Support for HashiCorp vault kv version 2
    - |run| Flux version 2 upgrade
    - |pin| Test and update platforms code to run on EKS v1.21 
    - |pin| Setup AWS cloudwatch exporter
    - |pin| Grafana and Promethus integration 
    - |pin| Improve logging/error messaging in playbooks

Platforms
---------
- |run| Reduce/decouple ansible dependecy in DLT platforms automation
- |run| Corda Enterprise operational feature enhancements
    - |tick| Enable mutiple notaries
    - |tick| R3 Corda version 4.7 upgrade
    - |tick| CENM version 1.5 upgrade
    - |tick| Addition of notary node organisation to an existing network
    - |run| CENM 1.5 services (Auth, Gateway and Zone) support
    - |pin| HA Notary options
    - |pin| Enable PostGreSQL support for Corda Enterprise
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
    - |tick| Enable deployment without proxy (proxy as none option)
    - |tick| Add clique consensus mechanism support 
    - |tick| Add ethash consensus mechanism support
    - |run| Vault secret engine integration with tessera
    - |hand| Enable bootnodes
- |run| Quorum operational feature enhancements
    - |tick| Version upgrade (Tessera and Quorum node) - v21.4.x
    - |run| Vault secret engine integration with tessera
    - |run| Implement private transactions

Application
-----------
-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitymatrix`
