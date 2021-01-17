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
    - |pin| HL Fabric v1.4.x upgrade
    - |pin| R3 Corda version 4.x upgrade

Platforms
---------
-  |tick| HL Fabric 2.2 version upgrade
-  |run| Corda Ent. OFE*
    - |run| Enable mutiple notaries
    - |pin| Addition of notaries
    - |hand| Removable of node
-  |run| HL Fabric operational feature enhancements

Application
-----------

-  |run| Hyperledger Besu reference application


Histroic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the compatibilitymatrix
