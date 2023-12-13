# Bevel current roadmap

``` mermaid
timeline
    title Hyperledger Bevel 2024 Roadmap
    section 2024 Q1
        Helm charts on Helm repo 
            : All platforms
        Documentation Redesign 
            : Restructure 
            : Format Config files
    section 2024 Q2
        Helm depencencies 
            : Corda 
            : Fabric
            : Quorum
        Github Actions 
            : Corda 
            : Fabric
    section 2024 Q3
        Github Actions 
            : Quorum 
            : Besu
    section 2024 Q4
        Helm depencencies 
            : Indy 
            : Besu

```

OFE* : Operational feature enhancement

Legend of annotations:

| Icon                   | Description      |
|-----|----|
| :octicons-pin-16:                  | work to do       |
| :octicons-check-16:                 | work completed   |
| :material-run:                 | on-going work    |
| :octicons-trophy-16:            | stretch goal     |
| :octicons-stop-16:                  | on hold          |

## Documentation

-  :material-run: Complete restructure and redesign of documentation
-  :material-run: Spell and grammar linting
-  :material-run: Update troubleshooting guide
-  :material-run: Replace ansible roles readme with high level information
-  :octicons-check-16: Add helm chart readme for platform charts

## General/Shared

- :octicons-trophy-16:  Improve logging/error messaging in playbooks and log storage
- :material-run: Adding proper log message on the helm charts
- :octicons-stop-16:   Setup AWS cloudwatch exporter
- :material-run: Grafana and Promethus integration
- :octicons-check-16: Support of Ambassador Edge Stack
- :octicons-check-16: Molecule test support to be removed
- :octicons-check-16: Upgrade hashicorp vault version 
- :octicons-trophy-16:  Support for additional vault, hashicorp alternatives
- :octicons-check-16: Add git actions to automate creation of helm repo chart artifacts
- :octicons-pin-16: Devcontainer for vscode containers/codespaces
- :octicons-pin-16: Git commit/yaml linting
- :octicons-check-16: Vault reviewer reference removal
- :octicons-check-16: Creation of vault auth role from the vault-k8s chart
- :octicons-check-16: Add default values to chart templates/values section

## Platforms

- R3 Corda Enterprise and open source
    - :octicons-stop-16:   HA Notary options
    - :octicons-stop-16:   Enable PostGreSQL support for Corda Enterprise
    - :octicons-stop-16:   Removal of node
    - :octicons-stop-16:   Cacti connector for Corda opensource
    - :octicons-pin-16: Corda enterprise Node/Notary v4.9 support
- R3 Corda OS v5
    - :octicons-pin-16: Base network deployment
- Hyperledger Fabric
    - :octicons-check-16: External chaincode for Fabric 2.2.x
    - :octicons-check-16: Support for Fabric 2.5.x
    - :octicons-pin-16: Operational features for Fabric 2.5.x
    - :octicons-stop-16:   CI/CD piplelines for chaincode deployment
    - :octicons-pin-16: chaincode operations via operator console
    - :octicons-pin-16: chaincode operations automation using bevel-operator-fabric
    - :octicons-pin-16: chaincode upgrade for external chaincode 
- Hyperledger Besu
    - :octicons-stop-16:   Enable node discovery
    - :octicons-stop-16:   Enable bootnodes
    - :octicons-check-16: Add promethus/Grafana chart for node monitoring data
    - :octicons-check-16: Test onchain permission for Besu platform
    - :octicons-pin-16: Node version upgrades
    - :octicons-pin-16: Tessera version upgrades
    - :octicons-pin-16: Support for Besu node on public network
- Quorum
    - :octicons-pin-16: Test TLS for Quorum Tessera communication
- Hyperledger Indy
    - :octicons-stop-16:   Removal of organizations from a running Indy Network
- Substrate
    - :octicons-trophy-16:  Test with generic substrate node
    - :octicons-trophy-16:  Adding of org/new node

## Bevel Samples

-  :octicons-pin-16: Upgrade Ambassador proxy to Edge stack
-  :octicons-pin-16: Upgrade rest server/middleware applications
-  :octicons-pin-16: Upgrade aca py application

## Bevel Kubernetes Operators

- Bevel-Operator-Fabric
    - :octicons-pin-16: Host helm charts to github hosted helm repo
    - :octicons-trophy-16:  Use bevel platforms fabric chart
- Operator Quorum 
    - :octicons-trophy-16:  Architecture diagram
- Operator Besu 
    - :octicons-stop-16:   Architecture diagram 
- Operator Corda
    - :octicons-stop-16:   Architecture diagram

## DevOps-Pipeline

- :octicons-pin-16: GitHub Actions automation script for each DLT platform
