# Bevel current roadmap

``` mermaid
timeline
    title Hyperledger Bevel 2024 Roadmap
    section 2024 Q1
        Helm charts on Helm repo 
            : All platforms
        Documentation Redesign 
            : Restructure 
            : Format Config & Ops requried sections
        Github Actions 
            : All platforms
    section 2024 Q2
        Helm depencencies 
            : Besu
            : Corda 
            : Fabric
            : Quorum
    section 2024 Q3
        Deployment using Kubernetes Operator
            : Besu
    section 2024 Q4
        Helm depencencies 
            : Indy
            : Substrate


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
-  :octicons-check-16: Spell and grammar linting
-  :octicons-check-16: Replace ansible roles readme with high level information
-  :octicons-check-16: Add helm chart readme for platform charts
-  :octicons-check-16: Complete restructure and redesign of documentation
-  :material-run: Format/Update configuration file and ops section

## General/Shared
- :material-run: Grafana and Promethus integration
- :material-run: Consistent variable names for helm chart values
- :octicons-check-16: Support of Ambassador Edge Stack
- :octicons-check-16: Add git actions to automate creation of helm repo chart artifacts
- :octicons-check-16: Creation of vault auth role from the vault-k8s chart
- :octicons-check-16: Add default values to chart templates/values section
- :octicons-trophy-16:  Improve logging/error messaging in playbooks and log storage
- :octicons-trophy-16: Devcontainer for vscode containers/codespaces
- :octicons-trophy-16: Git commit/yaml linting
- :octicons-trophy-16:  Support for additional vault, hashicorp alternatives
- :octicons-stop-16:   Setup AWS cloudwatch exporter

## Platforms

- R3 Corda Enterprise and open source
    - :octicons-stop-16:   HA Notary options
    - :octicons-stop-16:   Enable PostGreSQL support for Corda Enterprise
    - :octicons-stop-16:   Removal of node
    - :octicons-stop-16:   Cacti connector for Corda opensource
    - :octicons-check-16: Corda enterprise Node/Notary v4.9 support
- R3 Corda OS v5
    - :octicons-pin-16: Base network deployment
- Hyperledger Fabric
    - :octicons-check-16: External chaincode for Fabric 2.2.x
    - :octicons-check-16: Support for Fabric 2.5.x
    - :material-run: Operational features for Fabric 2.5.x
    - :octicons-pin-16: chaincode operations via operator console
    - :octicons-pin-16: chaincode operations automation using bevel-operator-fabric
    - :octicons-pin-16: chaincode upgrade for external chaincode 
    - :octicons-stop-16: CI/CD piplelines for chaincode deployment
- Hyperledger Besu
    - :octicons-stop-16:   Enable node discovery
    - :octicons-stop-16:   Enable bootnodes
    - :octicons-check-16: Add promethus/Grafana chart for node monitoring data
    - :octicons-check-16: Test onchain permission for Besu platform
    - :octicons-pin-16: Node version upgrades
    - :octicons-pin-16: Tessera version upgrades
    - :octicons-stop-16: Support for Besu node on public network
- Quorum
    - :octicons-pin-16: Deployment using just helm charts
- Hyperledger Indy
    - :octicons-stop-16:   Removal of organizations from a running Indy Network
    - ::octicons-pin-16:   Node version upgrades
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

- :material-run: GitHub Actions automation script for each DLT platform
