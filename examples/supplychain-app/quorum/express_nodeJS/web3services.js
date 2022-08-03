var Web3 = require("web3");
var {productABI} = require("./ABI/productABI");
var {productContractAddress,quorumServer, ganacheServer, nodeIdentity, nodeOrganization, nodeOrganizationUnit, nodeSubject,protocol} = require("./config");

// Smart contract address
const fromAddress = nodeIdentity;
console.log(fromAddress);

const fromNodeOrganization = nodeOrganization;
console.log(fromNodeOrganization);

const fromNodeOrganizationUnit = nodeOrganizationUnit;
console.log(fromNodeOrganizationUnit);

const fromNodeSubject = nodeSubject;
console.log(fromNodeSubject);
console.log(fromAddress+","+fromNodeSubject);

console.log(protocol);

web3 = new Web3(new Web3.providers.HttpProvider(ganacheServer));

//instantiate the product smartcontract 
let productContract = new web3.eth.Contract(productABI, productContractAddress);

module.exports = {
    productContract,
    fromAddress,
    fromNodeOrganization,
    fromNodeOrganizationUnit,
    fromNodeSubject,
    protocol
}

