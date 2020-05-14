Roadmap
=======
.. mermaid::

   gantt
    title BAF current roadmap
    dateFormat  YY-MM-DD
    section Platform
    R3 Corda Enterprise Version  :a1, 20-05-15  , 90d
    Besu Provisioning       :a2, 20-06-08  , 90d
    Couch DB     :after a1  , 60d
    
    section Application
    Quorum Ref App      :done, b1, 20-03-10, 60d
    Indy Ref App      :active, b2, after b1, 90d
    
    section Architecture
    Besu Blueprint      : 20-06-01, 60d
    Corda vEnterprise Blueprint : 20-06-01, 60d
    