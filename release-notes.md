This is beta release version 0.3.0.0
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