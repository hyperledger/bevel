Bevel current roadmap
=====================

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

Documentation
-------------
-  |pin| Complete restructure and redesign of documentation
-  |pin| Spell and grammar linting
-  |pin| Update troubleshooting guide
-  |pin| Replace ansible roles readme with high level information
-  |tick| Add helm chart readme for platform charts

General/Shared
--------------
- |muscle| Improve logging/error messaging in playbooks and log storage
- |pin| Adding proper log message on the helm charts
- |hand| Setup AWS cloudwatch exporter
- |pin| Grafana and Promethus integration
- |hand| Support of Emissary Ingress
- |pin| Molecule test support to be removed
- |tick| Upgrade hashicorp vault version 
- |pin| Support for additional hashicorp vault alternatives
- |tick| Add git actions to automate creation of helm repo chart artifacts
- |pin| Devcontainer for vscode containers/codespaces
- |pin| Git commit/yaml linting
- |tick| Vault reviewer reference removal
- |tick| Creation of vault auth role from the vault-k8s chart
- |run| Add default values to chart templates/values section

Platforms
---------
- R3 Corda Enterprise and open source
    - |hand| HA Notary options
    - |hand| Enable PostGreSQL support for Corda Enterprise
    - |hand| Removal of node
    - |pin| Add Corda 5 support
    - |hand| Cacti connector for Corda opensource
- Hyperledger Fabric
    - |tick| External chaincode for Fabric 2.2.x
    - |run| Support for Fabric 2.5.x
    - |hand| CI/CD piplelines for chaincode deployment
    - |pin| Chaincode operations via operator console  
- Hyperledger Besu
    - |hand| Enable node discovery
    - |hand| Enable bootnodes
    - |pin| Add promethus/Grafana chart for node monitoring data
    - |pin| Test permission for Besu platform
- Quorum
    - |pin| Enable TLS for Quorum Tessera communication
- Hyperledger Indy
    - |hand| Removal of organizations from a running Indy Network
- Substrate
    - |pin| Test with generic substrate node
    - |muscle| Adding of org/new node

Bevel Samples
-------------
-  |pin| Upgrade rest server/middleware applications
-  |pin| Upgrade aca py application

Bevel Kubernetes Operators
--------------------------
- Operator Fabric
    - |pin| Host helm charts to github hosted helm repo
    - |muscle| Use bevel platforms fabric chart
- Operator Quorum 
    - |pin| Architecture diagram 
- Operator Besu 
    - |hand| Architecture diagram 
- Operator Corda
    - |hand| Architecture diagram


Historic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitytable`
