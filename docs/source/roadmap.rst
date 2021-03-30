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

.. |pin| image:: _static/pin.png
    :width: 15pt
    :height: 15pt
.. |tick| image:: _static/tick.png
    :width: 15pt
    :height: 15pt
.. |run| image:: _static/run.png
    :width: 15pt
    :height: 15pt
.. |muscle| image:: _static/muscle.png
    :width: 15pt
    :height: 15pt
.. |hand| image:: _static/hand.png
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
    - |run| Ambassador upgrade to 1.9.1  
    - |pin| Improve logging/error messaging in playbooks
    - |pin| Complete molecule test scenarios for BAF R3 Corda OS and HL Fabric  
    - |hand| Java version upgrades

Platforms
---------
- |run| Corda Ent. operational feature enhancements
    - |tick| Enable mutiple notaries
    - |pin| Addition of notary node to an existing network
    - |pin| R3 Corda version 4.x upgrade
    - |pin| CENM version upgrade
    - |hand| Removable of node
- |run| HL Fabric operational feature enhancements
    - |tick| HL Fabric 2.2 version upgrade
    - |tick| HL Fabric v1.4.8 upgrade
    - |run| Feature for user identities
    - |pin| External chaincode for Fabric 2.2.x
    - |pin| Multi Orderer organisation option for RAFT
    - |pin| CI/CD piplelines for chaincode deployment 
- |run| HL Besu operational feature enhancements
    - |tick| Enable DNS support
    - |pin| Enable deployment without proxy (proxy as none option)
    - |hand| Addition of new validator node
    - |hand| Enable bootnodes


Application
-----------
-  |hand| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the compatibilitymatrix
