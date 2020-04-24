Roadmap
=======
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    R3 Corda Enterprise Version  :a1, 20-03-15  , 90d
    Besu Provisioning       :active, a2, 20-03-15  , 90d
    Key Storage & Management     :done, a3, 20-03-15  , 90d
    Sawtooth Provisioning     :after b1, 90d
    Couch DB     :after b1  , 90d
    
    section Application
    Quorum Ref App      :active, b1, 20-03-01, 90d
    Indy Ref App      : after b1, 90d
    
    section Architecture
    Quorum Blueprint      :done,c1, 20-02-01, 60d
    Besu Blueprint      : 20-05-01, 60d
    Corda vEnterprise Blueprint : 20-05-01, 60d
    