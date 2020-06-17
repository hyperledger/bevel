<a name = "adding-cordapps"></a>
# Adding cordapps to R3 Corda network

## 1. Adding directly from build directory

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
## 2. Adding from a nexus repository

### Pre-requisites:
Build the CorDapp jars. If you have multiple jars, place them in a single location e.g. at `path/to/cordapp-jars`.
Publishing the CorDapp jars to the nexus repository.

Inorder to publish the jars add the following information in `example\supplychain-app\corda\gradle.properties` file

```yaml
# Repository URL e.g : https://alm.accenture.com/nexus/repository/AccentureBlockchainFulcrum_Release/
repoURI=nexus_repository_url
# Repository credentials
repoUser=repository_user_name
repoPassword=repository_user_password
```
Add the appropriate jar information as artifacts in `example\supplychain-app\corda\build.gradle` file, change this file only if you need to add or remove jars other that the ones mentioned below

```ruby
publishing{
    publications {
    maven1(MavenPublication) {
        artifactId = 'cordapp-supply-chain'
        artifact('build/cordapp-supply-chain-0.1.jar')
            }
    maven2(MavenPublication) {
        artifactId = 'cordapp-contracts-states'
        artifact('build/cordapp-contracts-states-0.1.jar')
            }
        }
        repositories {
        maven {
            url project.repoURI
            credentials {
                username project.repoUser
                password project.repoPassword
                }
            }
        }
}
```
Publishing the artifacts/jars, use the below command to publish the jars into the nexus repository 

```
gradle publish
```
Change the corda configuration file to add jar information under the cordapps field of required organisation.  

Example given in the sample configuration file  
`platforms/r3-corda/configuration/samples/network-cordav2.yaml`  
 
The snapshot from the sample configuration file with the example values is below
```yaml
      # Cordapps Repository details (optional use if cordapps jar are store in a repository)
      cordapps:
        jars: 
        - jar:
            # e.g https://alm.accenture.com/nexus/repository/AccentureBlockchainFulcrum_Release/com/supplychain/bcc/cordapp-supply-chain/0.1/cordapp-supply-chain-0.1.jar
            url: 
        - jar:
            # e.g https://alm.accenture.com/nexus/repository/AccentureBlockchainFulcrum_Release/com/supplychain/bcc/cordapp-contracts-states/0.1/cordapp-contracts-states-0.1.jar
            url: 
        username: "cordapps_repository_username"
        password: "cordapps_repository_password"
```
### Adding the jars by deploying the network

After the configuration file is updated and saved, now run the following command from the **blockchain-automation-framework** folder to deploy your network.

```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml"
```
This would deploy the network and add the cordapps.