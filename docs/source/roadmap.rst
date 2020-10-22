BAF current roadmap
===================
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    Corda Ent. MVP Provisioning  :active, a1, 20-05-15  , 130d
    Besu MVP Provisioning       :active, a2, 20-05-20  , 125d
    Flux Helm3: done, 20-07-15, 15d
    Quorum Helm3: active, 20-10-01, 15d
    Besu Helm3: active, 20-10-01, 15d
    Fabric Helm3: active, 20-10-01, 15d
    Indy Helm3: done, 20-09-15, 15d
    Tech tool upgrades: 20-12-01, 45d
    Corda OS Helm3: done, 20-09-20, 15d
    Corda Ent. OFE*: 20-11-15, 60d
    Corda Ent. Helm3: done, 20-09-15, 15d
    EKS upgrade:done, a5, 20-08-10, 10d
    Fabric 2.2 upgrade: active, a6, 20-09-01, 50d
    Fabric OFE*: active, 20-10-01, 45d
    Besu OFE*: 20-11-15, 45d
    section Application
    Corda Ent. Ref App : active, b3, 20-09-15, 60d
    Besu Ref App: active, b4, 20-09-15, 60d
    section Architecture
    Besu Blueprint      : done, 20-06-01, 50d
    Corda-Ent Blueprint : done, 20-06-01, 50d

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
.. |depricated| image:: _static/depricated.png
    :alt: depricated
    :width: 15pt
    :height: 15pt
.. |active| image:: _static/active.png
    :alt: in use
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
| |depricated|           | depricated       |
+------------------------+------------------+
| |active|               | in use / valid   |
+------------------------+------------------+

General
-------

-  |tick| Minikube support for existing platforms
-  |run| Improve the existing ``readthedocs`` documentations
-  |run| BAF DLT and software tools upgrade:
    - |run| Helm3 upgrade
    - |tick| HAProxy upgrade to latest stable
    - |tick| EKS upgrade to 1.16
    - |pin| Ambassador upgrade to latest stable 
    - |tick| Flux upgrade for helm3 operator support
    - |pin| Java version upgrades

Platforms
---------

-  |tick| Besu MVP network provisioning
-  |tick| R3 Corda Enterprise MVP network provisioning
-  |tick| Key storage and management
-  |run| HL Fabric 2.2 version upgrade
-  |run| HL Fabric operational feature enhancements

Application
-----------

-  |pin| Hyperledger Besu reference application
-  |pin| R3 Corda Enterprise reference application
-  |tick| Quorum supplychain application integration
-  |tick| Hyperledger Indy reference application

Architecture
------------

-  |tick| Besu architecture blueprint
-  |tick| R3 Corda Enterprise Version architecture blueprint

Histroic DLT/Blockchain support releases
-----------------------------------------

+-------------------------------------------+-----------+--------------+
| Feature Name                              | Release   | Status       |
+===========================================+===========+==============+
| R3 Corda Enterprise v4.4                  | 0.6.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| Hyperledger Fabric v2.0                   | 0.5.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| R3 Corda v4.4                             | 0.5.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| Hyperledger Indy v1.11.0                  | 0.5.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| Quorum v2.5.0                             | 0.4.1     | |active|     |
+-------------------------------------------+-----------+--------------+
| Quorum v2.1.1                             | 0.4.0     | |depricated| |
+-------------------------------------------+-----------+--------------+
| Quorum Architecture blueprint             | 0.4.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| Hyperledger Indy v1.9.0                   | 0.4.0     | |depricated| |
+-------------------------------------------+-----------+--------------+
| Hyperledger Fabric v1.4.4                 | 0.3.1     | |active|     |
+-------------------------------------------+-----------+--------------+
| Hyperledger Indy Architecture blueprint   | 0.3.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| R3 Corda v4.1                             | 0.3.0     | |active|     |
+-------------------------------------------+-----------+--------------+
| Hyperledger Fabric v1.4.0                 | 0.2.0     | |depricated| |
+-------------------------------------------+-----------+--------------+
| R3 Corda v4.0                             | 0.2.0     | |depricated| |
+-------------------------------------------+-----------+--------------+
