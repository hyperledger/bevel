BAF current roadmap
===================
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade: active, 21-01-07, 180d
    Corda Ent. OFE*: active, 20-11-15, 180d
    Fabric OFE*: active, 20-10-15, 240d
    Besu OFE*: active, 21-01-07, 150d
    section Application
    Besu Ref App: b4, 20-10-15, 120d

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
    - |tick| EKS upgrade to 1.16
    - |tick| Ambassador upgrade to 1.9.1
    - |tick| Complete molecule test scenarios for BAF R3 Corda OS and HL Fabric
    - |pin| Setup AWS cloudwatch exporter
    - |pin| Grafana and Promethus integration 
    - |pin| Flux version upgrade
    - |pin| Support for HashiCorp vault kv version 2
    - |pin| Improve logging/error messaging in playbooks
    - |hand| Java version upgrades

Platforms
---------
- |run| Corda Ent. operational feature enhancements
    - |tick| Enable mutiple notaries
    - |tick| Test R3 Corda version 4.7 upgrade
    - |tick| Test CENM version upgrade to 1.5
    - |pin| Addition of notary node to an existing network
    - |pin| Enable PostGreSQL support for Corda Enterprise
    - |hand| Removable of node
- |run| HL Fabric operational feature enhancements
    - |tick| HL Fabric 2.2 version upgrade
    - |tick| HL Fabric v1.4.8 upgrade
    - |tick| Multi Orderer organisation option for RAFT
    - |run| Feature for user identities
    - |run| External chaincode for Fabric 2.2.x
    - |pin| CI/CD piplelines for chaincode deployment

- |run| HL Besu operational feature enhancements
    - |tick| Enable DNS support
    - |pin| Enable deployment without proxy (proxy as none option)
    - |pin| Add clique consensus mechanism support 
    - |run| Addition of new validator node
    - |hand| Enable bootnodes


Application
-----------
-  |hand| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the compatibilitymatrix
