BAF current roadmap
===================
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Platforms and components upgrade: active, 21-01-07, 90d
    Corda Ent. OFE*: active, 20-11-15, 120d
    Fabric OFE*: active, 20-10-15, 150d
    Besu OFE*: 21-01-07, 45d
    Git Action Migration: active, 21-01-07, 30d
    section Application
    Besu Ref App: active, b4, 20-10-15, 120d

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
    - |hand| Java version upgrades
    - |pin| Improve logging/error messaging in playbooks
    - |pin| Proxy as none option in DLT platforms
   

Platforms
---------
- |tick| HL Fabric 2.2 version upgrade
- |pin| HL Fabric v1.4.x upgrade
- |run| Corda Ent. operational feature enhancements
    - |run| Enable mutiple notaries
    - |pin| Addition of notaries
    - |pin| R3 Corda version 4.x upgrade
    - |pin| CENM version upgrade
    - |hand| Removable of node
- |run| HL Fabric operational feature enhancements
    - |pin| External chaincode for Fabric 2.2.x
    - |pin| CI/CD piplelines for chaincode deployment 
    - |pin| Multi Orderer organisation option for RAFT
    - |run| Feature for user identities
- |run| HL Besu operational feature enhancements
    - |tick| Enable DNS support
    - |pin| Addition of new validator node
    - |pin| Enable bootnodes


Application
-----------

-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the compatibilitymatrix
