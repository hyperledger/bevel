# Lab Name
Blockchain Automation Framework

# Short Description
An automation framework for rapidly and consistently deploying production-ready DLT platforms

# Scope of Lab
Blockchain Automation Framework delivers an automation framework for rapidly and consistently deploying production-ready DLT platforms to cloud infrastructure.

![What is Blockchain Automation Framework?](./docs/images/blockchain-automation-framework-overview.png "What is Blockchain Automation Framework?")

Blockchain Automation Framework makes use of Ansible, Helm, and Kubernetes to deploy production DLT networks. Specifically, it makes use of Ansible for configuration of the network by DevOps Engineers. It then uses Helm charts as instructions for deploying the necessary components to Kubernetes. Kubernetes was chosen to allow for Blockchain Automation Framework to deploy the DLT networks to any cloud that supports Kubernetes.

Blockchain Automation Framework initially supports Hyperledger Fabric and Corda. It is the intention to add support for Hyperledger Sawtooth, Hyperledger Indy and Quorum. Other DLT platforms can easily be added.

## Documentation
Detailed operator and developer documentation is available at [our ReadTheDocs site](https://blockchain-automation-framework.readthedocs.io/en/latest/index.html).

The documentation can also be built locally be following instructions in the `docs` folder.

## Hyperledger Fabric
For Hyperledger Fabric, we use the official Docker containers provided by that project. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Fabric](./docs/images/blockchain-automation-framework-fabric.png "Blockchain Automation Framework for Hyperledger Fabric")

## Corda
For Corda, we build Docker containers from the Corda source. A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

![Blockchain Automation Framework - Corda](./docs/images/blockchain-automation-framework-corda.png "Blockchain Automation Framework for Corda")

# Build
If you are not using the provided Jeknins automation scripts, you can run the provisioning scripts within a docker runtime independent from your target Kubernetes cluster. 
```
# Build provisioning image
docker build . -t baf-build

# Run the provisioning scripts
docker run --volume=$(pwd)/network-cordav2.yaml:/home/build/network.yaml baf-build
```

# Initial Committers
- [tkuhrt](https://github.com/tkuhrt)
- [jonathan-m-hamilton](https://github.com/jonathan-m-hamilton)
- [petermetz](https://github.com/petermetz)

# Sponsor
Mark Wagner (Github: [n1zyz](https://github.com/n1zyz), email: [mwagner@redhat.com](mailto:mwagner@redhat.com)) - TSC Member
