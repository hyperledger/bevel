# Release notes
The release notes provide more details for users moving to the new release, along
with a link to the full release change log.  

## The Blockchain Automation Framework v0.3.0.0 release notes
### v0.3.0.0 Release notes - December 23, 2019

 - Common Changes
   - Use of private key for GitOps. This enables fully automated playbooks.
   - Improved security of Supplychain App by passing Google Maps API key through k8s secret.
 - Fabric
   - Implemented HAProxy in place of Ambassador for ssl-passthrough.
   - Implemented Anchor peers; all peers are anchor peers now.
   - Changes for Multi-orderer network.

 - Corda
   - Corda version supported is v4.1.
   - Improved security by implementing linuxkit images for Doorman and NetworkMap.
   - Update corda components to include Ambassador annotations for services.
 
 - Indy
   - New platform added.
   - Automated network deployement in local enviorment.

### The Blockchain Automation Framework v0.2.0.0 release notes
 #### v0.2.0.0 Release notes - October 25, 2019

 - Fabric
   - Fabric version supported is v1.4.0
 - Corda
   - Corda version supported is v4.0
   - NetworkMap service (NMS) version is 3.3.1
   - Doorman service version is 3.3.1
 - Consensus Mechanisms
   - Hyperledger Fabric - Kafka that uses a conceputal configuration in the Raft provides a unified, high-throughput, low-latency platform for handling real-time data feeds
   - R3 Corda - allows pluggable consensus mechanisms a notary cluster may choose to run a high-speed, high-trust algorithm such as Raft, a low-speed, low-trust algorithm such as BFT

