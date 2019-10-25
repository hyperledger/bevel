<a name = "adding-cordapps"></a>
# Adding cordapps to the deployed network in R3 Corda

Pre-requisites: R3 Corda network deployed and network.yaml configuration file already set.

The playbook mentioned [here](https://innersource.accenture.com/projects/BLOCKOFZ/repos/blockchain-automation-framework.git/browse/platforms/r3-corda/configuration/deploy-cordapps.yaml) is used to deploy cordapps over the existing R3 Corda network.
This can be done manually using the following command

```
    ansible-playbook platforms/r3-corda/configuration/deploy-cordapps.yaml --extra-vars "@path-to-network.yaml"
```