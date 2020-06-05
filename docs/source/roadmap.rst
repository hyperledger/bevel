BAF current roadmap
=======
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

-  |tick| Minikube support for existing platforms
-  |run| Improve the existing ``readthedocs`` documentations

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
-  |pin| R3 Corda Enterprise Version architecture blueprint
-  |hand| Couch DB architecture blueprint
