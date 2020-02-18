var Web3 = require("web3");
var {productABI} = require("./ABI/productABI");
var {productContractAddress,quorumServer, nodeIdentity} = require("./config");

// Smart contract address
const fromAddress = nodeIdentity;
console.log(fromAddress);

web3 = new Web3(new Web3.providers.HttpProvider(quorumServer));

//instantiate the product smartcontract 
let productContract = new web3.eth.Contract(productABI, productContractAddress);

module.exports = {
    productContract,
    fromAddress
}