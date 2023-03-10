const Web3 = require("web3");
const contract = require('./compile'); //Importing the function to compile smart contract
const minimist = require('minimist'); // Import the library for the arguments

let args = minimist(process.argv.slice(2));
const url = args['url'];  // url of RPC port of besu node
const contractPath = args['path']; // path to the contract directory
const contractChainId = args['chainId']; // path to the contract directory
const contractEntryPoint = args['entryPoint']; // Smart contract entrypoint eg Main.sol
const contractName = args['contractName']; // Smart Contract Class Nameconst initArguments = process.env.INITARGUMENTS | " ";
const privateKey = args['privateKey'];
const nodeAddress = args['nodeAddress'];
const numberOfIterations = args['numberOfIteration'] | 100;

async function createContract(host, contractBytecode ) {
  const web3 = new Web3(host);
  // initialize the default constructor with a value `47 = 0x2F`; this value is appended to the bytecode
  const contractConstructorInit = web3.eth.abi
    .encodeParameter("uint256", "47")
    .slice(2);

  const block = await web3.eth.getBlock("latest", false);
  console.log()
  const txn = {
    chainId: contractChainId,
    nonce: await web3.eth.getTransactionCount(nodeAddress), // 0x00 because this is a new account
    from: nodeAddress,
    to: null, //public tx
    value: "0x00",
    data: "0x" + contractBytecode + contractConstructorInit,
    gasPrice: "0x0", //ETH per unit of gas
    gas: "0x2CA51", //max number of gas units the tx is allowed to use
    gasLimit: block.gasLimit
  };
  console.log("create and sign the txn");
  const signedTx = await web3.eth.accounts.signTransaction(
    txn,
    privateKey
  );
  console.log("sending the txn");
  const txReceipt = await web3.eth.sendSignedTransaction(
    signedTx.rawTransaction
  );
  console.log(txReceipt);
  console.log("tx transactionHash: " + txReceipt.transactionHash);
  console.log("tx contractAddress: " + txReceipt.contractAddress);
  return txReceipt;
}

async function main() {
  args['v'] && console.log(`Compiling the smartcontract.......`);
  const smartContract = await contract.GetByteCode(numberOfIterations, contractPath, contractEntryPoint, contractName); // Converting smart contract to byte code, optimizing the bytecode conversion for numberOfIterations iterations
  args['v'] && console.log(`Smartcontract converted into bytecode and abi`);
  const contractBytecode = smartContract.bytecode;
  const contractAbi =  smartContract.abi;
  createContract(url, contractBytecode, contractAbi)
    .then(async function (tx) {
      console.log("Contract deployed at address: " + tx.contractAddress);
    })
    .catch(console.error);
}

if (require.main === module) {
  main();
}

module.exports = exports = main;
