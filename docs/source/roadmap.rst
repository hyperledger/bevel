Bevel current roadmap
=====================

.. mermaid::

   gantt
    title Bevel current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade : active, 22-09-01, 180d
    section Application
    Besu Ref App: active, 22-10-15, 90d
    section Bevel Operator
    To Be Discussed: active, 22-11-15, 120d

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
    - |pin| Update troubleshooting guide and role readme
-  |run| Platforms and components upgrade:
    - |run| Ambassador chart upgrade
    - |run| HAProxy chart upgrade
    - |pin| Setup AWS cloudwatch exporter
    - |pin| Grafana and Promethus integration 
    - |pin| Improve logging/error messaging in playbooks

Platforms
---------
- |run| Reduce/decouple ansible dependecy in DLT platforms automation
- |run| Option to enable cert-manager for tls certificate creation
- |run| Corda Enterprise operational feature enhancements
    - |pin| HA Notary options
    - |pin| Enable PostGreSQL support for Corda Enterprise
    - |pin| Removal of node
- |run| HL Fabric operational feature enhancements
    - |run| External chaincode for Fabric 2.2.x
    - |pin| CI/CD piplelines for chaincode deployment
    - |hand| Feature mixed organizations (orderer and peer in same organizations)
- |run| HL Besu operational feature enhancements
    - |run| Implement private transactions
    - |pin| Add QBFT consensus
    - |hand| Enable node discovery
    - |hand| Enable bootnodes
- |run| Quorum operational feature enhancements
    - |pin| Enable TLS for Quorum Tessera communication 
    - |pin| Implement private transactions
- |run| HL Indy operational feature enhancements
    - |hand| Removal of organizations from a running Indy Network

Application
-----------
-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitytable`
