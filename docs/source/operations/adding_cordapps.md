<a name = "adding-cordapps"></a>
# Adding cordapps to the deployed network in R3 Corda

### Pre-requisites: 
R3 Corda network deployed and network.yaml configuration file already set.

### Build CorDapp jars
Build the CorDapp jars. If you have multiple jars, place them in a single location e.g. at `path/to/cordapp-jars`.

### Run playbook

The playbook [deploy-cordapps.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/r3-corda/configuration/deploy-cordapps.yaml) is used to deploy cordapps over the existing R3 Corda network.
This can be done manually using the following command

```
ansible-playbook platforms/r3-corda/configuration/deploy-cordapps.yaml -e "@path-to-network.yaml" -e "source_dir='path/to/cordapp-jars'"
```