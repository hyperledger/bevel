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
-  |run| Complete restructure and redesign of documentation
-  |run| Spell and grammar linting
-  |run| Update troubleshooting guide
-  |run| Replace ansible roles readme with high level information
-  |tick| Add helm chart readme for platform charts

General/Shared
--------------
- |muscle| Improve logging/error messaging in playbooks and log storage
- |run| Adding proper log message on the helm charts
- |hand| Setup AWS cloudwatch exporter
- |run| Grafana and Promethus integration
- |tick| Support of Ambassador Edge Stack
- |tick| Molecule test support to be removed
- |tick| Upgrade hashicorp vault version 
- |muscle| Support for additional vault, hashicorp alternatives
- |tick| Add git actions to automate creation of helm repo chart artifacts
- |pin| Devcontainer for vscode containers/codespaces
- |pin| Git commit/yaml linting
- |tick| Vault reviewer reference removal
- |tick| Creation of vault auth role from the vault-k8s chart
- |tick| Add default values to chart templates/values section

Platforms
---------
- R3 Corda Enterprise and open source
    - |hand| HA Notary options
    - |hand| Enable PostGreSQL support for Corda Enterprise
    - |hand| Removal of node
    - |hand| Cacti connector for Corda opensource
    - |pin| Corda enterprise Node/Notary v4.9 support
- R3 Corda OS v5
    - |pin| Base network deployment
- Hyperledger Fabric
    - |tick| External chaincode for Fabric 2.2.x
    - |tick| Support for Fabric 2.5.x
    - |pin| Operational features for Fabric 2.5.x
    - |hand| CI/CD piplelines for chaincode deployment
    - |pin| chaincode operations via operator console
    - |pin| chaincode operations automation using bevel-operator-fabric
    - |pin| chaincode upgrade for external chaincode 
- Hyperledger Besu
    - |hand| Enable node discovery
    - |hand| Enable bootnodes
    - |tick| Add promethus/Grafana chart for node monitoring data
    - |tick| Test onchain permission for Besu platform
    - |pin| Node version upgrades
    - |pin| Tessera version upgrades
    - |pin| Support for Besu node on public network
- Quorum
    - |pin| Test TLS for Quorum Tessera communication
- Hyperledger Indy
    - |hand| Removal of organizations from a running Indy Network
- Substrate
    - |muscle| Test with generic substrate node
    - |muscle| Adding of org/new node

Bevel Samples
-------------
-  |pin| Upgrade Ambassador proxy to Edge stack
-  |pin| Upgrade rest server/middleware applications
-  |pin| Upgrade aca py application

Bevel Kubernetes Operators
--------------------------
- Bevel-Operator-Fabric
    - |pin| Host helm charts to github hosted helm repo
    - |muscle| Use bevel platforms fabric chart
- Operator Quorum 
    - |muscle| Architecture diagram
- Operator Besu 
    - |hand| Architecture diagram 
- Operator Corda
    - |hand| Architecture diagram

DevOps-Pipeline
---------------
- |pin| Jenkins automation script for each DLT platform


Historic DLT/Blockchain support releases
-----------------------------------------
This section has been moved to the :doc:`compatibilitytable`
