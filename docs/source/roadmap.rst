Bevel current roadmap
=====================

.. mermaid::

   gantt
    title Bevel current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade : active, 22-04-25, 180d
    Fabric OFE*: active, 22-04-25, 90d
    Ansible Decoupling: active, 22-04-25, 60d 
    section Application
    Besu Ref App: active, 22-04-25, 120d
    section GitOps
    Upgrade to Flux v2: active, 22-04-25, 60d

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
    - |run| Update guide for deployment on Local k8s
-  |run| Platforms and components upgrade:
    - |run| Flux version 2 upgrade
    - |pin| Test and update platforms code to run on EKS v1.2x 
    - |pin| Setup AWS cloudwatch exporter
    - |pin| Grafana and Promethus integration 
    - |pin| Improve logging/error messaging in playbooks

Platforms
---------
- |run| Reduce/decouple ansible dependecy in DLT platforms automation
- |run| Corda Enterprise operational feature enhancements
    - |pin| HA Notary options
    - |pin| Enable PostGreSQL support for Corda Enterprise
    - |pin| Removal of node
- |run| HL Fabric operational feature enhancements
    - |run| Feature for user identities
    - |run| External chaincode for Fabric 2.2.x
    - |pin| CI/CD piplelines for chaincode deployment
- |run| HL Besu operational feature enhancements
    - |run| Implement private transactions
    - |hand| Enable bootnodes
- |run| Quorum operational feature enhancements
    - |tick| Vault secret engine integration with tessera
    - |pin| Implement private transactions
- |run| HL Indy operational feature enhancements
    - |hand| Removal of organizations from a running Indy Network

Application
-----------
-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitymatrix`
