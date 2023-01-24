const dotenv = require('dotenv');
dotenv.config();
module.exports = {
  port: process.env.PORT,
  quorumServer : process.env.QUORUM_SERVER,
  ganacheServer : process.env.GANACHE_SERVER,
  nodeIdentity : process.env.NODE_IDENTITY,
  productContractAddress : process.env.PRODUCT_CONTRACT_ADDRESS,
  nodeOrganization : process.env.NODE_ORGANIZATION,
  nodeOrganizationUnit : process.env.NODE_ORGANIZATION_UNIT,
  nodeSubject : process.env.NODE_SUBJECT,
  protocol: process.env.PROTOCOL
};
