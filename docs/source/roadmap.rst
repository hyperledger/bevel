BAF current roadmap
===================
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    R3 Corda Enterprise Version  :a1, 20-05-15  , 90d
    Besu Provisioning       :active, a2, 20-05-20  , 90d
    Couch DB     :after a1  , 60d
    
    section Application
    Quorum Ref App      :done, b1, 20-03-10, 60d
    Indy Ref App      :done, b2, after b1, 30d
    
    section Architecture
    Besu Blueprint      : 20-06-01, 60d
    Corda vEnterprise Blueprint : 20-06-01, 60d

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
-  |run| BAF software tools upgrade

Platforms
---------

-  |run| Besu network provisioning
-  |pin| Support for R3 Corda Enterprise Version
-  |tick| Hyperledger Indy network provisioning
-  |tick| Quorum network provisioning
-  |tick| Support for Hyperledger Fabric v2.0
-  |tick| Key storage and management
-  |hand| Implementing couch DB

Application
-----------

-  |pin| Hyperledger Besu reference application
-  |tick| Quorum supplychain application integration
-  |tick| Hyperledger Indy reference application

Architecture
------------

-  |pin| Besu architecture blueprint
-  |tick| R3 Corda Enterprise Version architecture blueprint
-  |hand| Couch DB architecture blueprint

Histroic DLT/Blockchain support releases
-----------------------------------------

+-------------------------------------------+-----------+--------------+
| Feature Name                              | Release   | Status       |
+===========================================+===========+==============+
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
