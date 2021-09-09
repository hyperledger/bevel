# Blockchain Automation Framework [![join the chat][rocketchat-image]][rocketchat-url]
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[rocketchat-url]: https://chat.hyperledger.org/channel/blockchain-automation-framework
[rocketchat-image]: https://open.rocket.chat/images/join-chat.svg

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE) [![Documentation Status](https://readthedocs.org/projects/blockchain-automation-framework/badge/?version=latest)](https://blockchain-automation-framework.readthedocs.io/en/latest/?badge=latest) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3548/badge)](https://bestpractices.coreinfrastructure.org/projects/3548)
[![Build Status](https://circleci.com/gh/hyperledger-labs/blockchain-automation-framework.svg?style=shield)](https://circleci.com/gh/hyperledger-labs/blockchain-automation-framework)

- [Short Description](#short-description)
- [Scope of Lab](#scope-of-lab)
  - [Getting Started](#getting-started)
  - [Hyperledger Fabric](#hyperledger-fabric)
  - [Corda Enterprise](#corda-enterprise)
  - [Corda Opensource](#corda-opensource)
  - [Hyperledger Indy](#hyperledger-indy)
  - [Quorum](#quorum)
  - [Hyperledger Besu](#hyperledger-besu)
- [Contact](#contact)
- [Contributing](#contributing)
- [Initial Committers](#initial-committers)
- [Sponsor](#sponsor)

## Short Description
An automation framework for rapidly and consistently deploying production-ready DLT platforms.

## Scope of Lab
Blockchain Automation Framework delivers an automation framework for rapidly and consistently deploying production-ready DLT platforms to cloud infrastructure.

![What is Blockchain Automation Framework?](./docs/images/blockchain-automation-framework-overview.png "What is Blockchain Automation Framework?")

Blockchain Automation Framework makes use of Ansible, Helm, and Kubernetes to deploy production DLT networks. Specifically, it makes use of Ansible for configuration of the network by DevOps Engineers. It then uses Helm charts as instructions for deploying the necessary components to Kubernetes. Kubernetes was chosen to allow for Blockchain Automation Framework to deploy the DLT networks to any cloud that supports Kubernetes.

Blockchain Automation Framework currently supports Corda, Hyperledger Fabric, Hyperledger Indy and Quorum. It is the intention to add support for Hyperledger Besu and Corda Enterprise in the near future. Other DLT platforms can easily be added.

### Getting Started

To get started with the framework quickly, follow our [Getting Started guidelines](https://blockchain-automation-framework.readthedocs.io/en/latest/gettingstarted.html).

Detailed operator and developer documentation is available on [our ReadTheDocs site](https://blockchain-automation-framework.readthedocs.io/en/latest/index.html).

The documentation can also be built locally be following instructions in the `docs` folder.

### Hyperledger Fabric
For Hyperledger Fabric, we use the official Docker containers provided by that project. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Fabric](./docs/images/blockchain-automation-framework-fabric.png "Blockchain Automation Framework for Hyperledger Fabric")

### Corda Enterprise
For Corda Enterprise, we build Docker containers from the Corda source with licensed jars. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Corda Enterprise](./docs/images/blockchain-automation-framework-corda-ent.png "Blockchain Automation Framework for Corda Enterprise")

### Corda Opensource
For Corda Opensource, we build Docker containers from the Corda source. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Corda](./docs/images/blockchain-automation-framework-corda.png "Blockchain Automation Framework for Corda")

### Hyperledger Indy
For Hyperledger Indy, we build Docker containers from our source code. A number of different Ansible scripts will allow you to create a new network (across clouds).

![Blockchain Automation Framework - Indy](./docs/images/blockchain-automation-framework-indy.png "Blockchain Automation Framework for Hyperledger Indy")

### Quorum
For Quorum, we use the official Docker containers provided by Quorum. A number of different Ansible scripts will allow you to either create a new network (across clouds) with choice of Consensus (between IBFT and RAFT) and a choice of Transaction Manager (between Tessera and Constellation).

![Blockchain Automation Framework - Quorum](./docs/images/blockchain-automation-framework-quorum.png "Blockchain Automation Framework for Quorum")

### Hyperledger Besu
For Hyperledger Besu, we use the official Docker containers provided by that project. A number of different Ansible scripts will allow you to create a new network (across clouds).

![Blockchain Automation Framework - Besu](./docs/images/blockchain-automation-framework-besu.png "Blockchain Automation Framework for Hyperledger Besu")

## Contact
We welcome your questions & feedback on our [Rocketchat channel](https://chat.hyperledger.org/channel/blockchain-automation-framework).

## Contributing
We welcome contributions to BAF in many forms, and there’s always plenty to do!

Please review [contributing](./CONTRIBUTING.md) guidelines to get started.

# Build
If you are not using the provided Jenkins automation scripts, you can run the provisioning scripts within a docker runtime independent from your target Kubernetes cluster.
```
# Build provisioning image
docker build . -t hyperledgerlabs/baf-build

# Run the provisioning scripts
docker run -it -v $(pwd):/home/blockchain-automation-framework/ hyperledgerlabs/baf-build
```

## Initial Committers
- [tkuhrt](https://github.com/tkuhrt)
- [jonathan-m-hamilton](https://github.com/jonathan-m-hamilton)
- [sownak](https://github.com/sownak)


## Sponsor
Mark Wagner (Github: [n1zyz](https://github.com/n1zyz), email: [mwagner@redhat.com](mailto:mwagner@redhat.com)) - TSC Member

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/alvaropicazo"><img src="https://avatars.githubusercontent.com/u/76157062?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alvaro Picazo</b></sub></a><br /><a href="#maintenance-alvaropicazo" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/suvajit-sarkar"><img src="https://avatars.githubusercontent.com/u/55580532?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Suvajit Sarkar</b></sub></a><br /><a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=suvajit-sarkar" title="Code">💻</a> <a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=suvajit-sarkar" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/deepakkumardbd"><img src="https://avatars.githubusercontent.com/u/57094817?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Deepak Kumar</b></sub></a><br /><a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=deepakkumardbd" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jagpreetsinghsasan"><img src="https://avatars.githubusercontent.com/u/56861721?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jagpreet Singh Sasan</b></sub></a><br /><a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=jagpreetsinghsasan" title="Code">💻</a> <a href="#maintenance-jagpreetsinghsasan" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/angelaalagbe"><img src="https://avatars.githubusercontent.com/u/54588164?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Angela.Alagbe</b></sub></a><br /><a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=angelaalagbe" title="Documentation">📖</a> <a href="#content-angelaalagbe" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/mgCepeda"><img src="https://avatars.githubusercontent.com/u/83813093?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marina Gómez Cepeda</b></sub></a><br /><a href="https://github.com/hyperledger-labs/blockchain-automation-framework/commits?author=mgCepeda" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
