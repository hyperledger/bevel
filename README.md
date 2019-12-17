# Blockchain Automation Framework

- [Short Description](#short-description)
- [Scope of Lab](#scope-of-lab)
  - [Documentation](#documentation)
  - [Hyperledger Fabric](#hyperledger-fabric)
  - [Corda](#corda)
- [Contact](#contact)
- [Contributing](#contributing)
- [Initial Committers](#initial-committers)
- [Sponsor](#sponsor)

## Short Description
An automation framework for rapidly and consistently deploying production-ready DLT platforms

## Scope of Lab
Blockchain Automation Framework delivers an automation framework for rapidly and consistently deploying production-ready DLT platforms to cloud infrastructure.

![What is Blockchain Automation Framework?](./docs/images/blockchain-automation-framework-overview.png "What is Blockchain Automation Framework?")

Blockchain Automation Framework makes use of Ansible, Helm, and Kubernetes to deploy production DLT networks. Specifically, it makes use of Ansible for configuration of the network by DevOps Engineers. It then uses Helm charts as instructions for deploying the necessary components to Kubernetes. Kubernetes was chosen to allow for Blockchain Automation Framework to deploy the DLT networks to any cloud that supports Kubernetes.

Blockchain Automation Framework initially supports Hyperledger Fabric and Corda. It is the intention to add support for Hyperledger Sawtooth, Hyperledger Indy and Quorum. Other DLT platforms can easily be added.

### Documentation
Detailed operator and developer documentation is available at [our ReadTheDocs site](https://blockchain-automation-framework.readthedocs.io/en/latest/index.html).

The documentation can also be built locally be following instructions in the `docs` folder.

### Hyperledger Fabric
For Hyperledger Fabric, we use the official Docker containers provided by that project. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Fabric](./docs/images/blockchain-automation-framework-fabric.png "Blockchain Automation Framework for Hyperledger Fabric")

### Corda
For Corda, we build Docker containers from the Corda source. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Corda](./docs/images/blockchain-automation-framework-corda.png "Blockchain Automation Framework for Corda")

## Contact
We welcome your questions & feedback on our [Rocketchat channel](https://chat.hyperledger.org/channel/blockchain-automation-framework).

## Contributing
We welcome contributions to BAF in many forms, and there’s always plenty to do!

First things first, please review the [Hyperledger Code of Conduct](https://wiki.hyperledger.org/display/HYP/Hyperledger+Code+of+Conduct) before participating. 

There are many ways to contibute to BAF, both as a user and as a developer.

As a user, this can inlcude:
* [Making Feature/Enhancement Proposals](https://github.com/hyperledger-labs/blockchain-automation-framework/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=)
* [Reporting bugs](https://github.com/hyperledger-labs/blockchain-automation-framework/issues/new?assignees=&labels=bug&template=bug_report.md&title=)

As a developer:
* if you only have a little time, consider picking up a [“help-wanted”](https://github.com/hyperledger-labs/blockchain-automation-framework/labels/help%20wanted) or ["good-first-issue"](https://github.com/hyperledger-labs/blockchain-automation-framework/labels/good%20first%20issue) task
* If you can commit to full-time development, then please contact us on our [Rocketchat channel](https://chat.hyperledger.org/channel/blockchain-automation-framework) to work through logistics


## Initial Committers
- [tkuhrt](https://github.com/tkuhrt)
- [jonathan-m-hamilton](https://github.com/jonathan-m-hamilton)
- [sownak](https://github.com/sownak)


## Sponsor
Mark Wagner (Github: [n1zyz](https://github.com/n1zyz), email: [mwagner@redhat.com](mailto:mwagner@redhat.com)) - TSC Member
