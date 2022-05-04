/////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright Accenture. All Rights Reserved.                                                  //
//                                                                                             //
//  SPDX-License-Identifier: Apache-2.0                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////

const Web3 = require('web3'); // Importing web3.js library
const Web3Quorum = require('web3js-quorum');
const fs = require('fs-extra'); // Importing for writing a file
const contract = require('./compile'); //Importing the function to compile smart contract
const minimist = require('minimist'); // Import the library for the arguments

let args = minimist(process.argv.slice(2));
const url = args['url'];  // url of RPC port of besu node
const contractPath = args['path']; // path to the contract directory
const contractEntryPoint = args['entryPoint']; // Smart contract entrypoint eg Main.sol
const contractName = args['contractName']; // Smart Contract Class Nameconst initArguments = process.env.INITARGUMENTS | " ";
const tmPublicKey = args['tmKey'];
const privateKey = args['privateKey'];
const privateFor = [];
const outputFolder = args['output'] == true ? args['output'] : './build';
args['privateFor'].split(',').forEach(item => privateFor.push(item));
const numberOfIterations = args['numberOfIteration'] | 100;

args['v'] && console.log(`Creating a web3 provider.......`);
const web3quorum = new Web3Quorum(new Web3(`${url}`)); 

var transactionHash = ""; // to store transaction hash to get the transaction receipt 
var contractAddress = "";

const deploy = async () => {
  args['v'] && console.log(`Compiling the smartcontract.......`);
  const smartContract = await contract.GetByteCode(numberOfIterations, contractPath, contractEntryPoint, contractName); // Converting smart contract to byte code, optimizing the bytecode conversion for numberOfIterations iterations
  args['v'] && console.log(`Smartcontract converted into bytecode and abi`);
  const contractOptions = {
    data: `0x${smartContract.bytecode}`, // contract binary
    privateFrom: `${tmPublicKey}`,    // transaction manager public key of sender
    privateFor: privateFor,              // transaction manager public key(s) of receiver(s)
    privateKey: `${privateKey}`,          // private key of sender
    gas: 427372
  };
  args['v'] && console.log(`Created the contract options`);

  await deploySmartContract(contractOptions, smartContract.abi, smartContract.bytecode)
    .then(hash => {
      transactionHash = hash;
      args['v'] && console.log(`Transaction hash for the deployment is ${hash}`);
      web3quorum.eth.transactionPollingTimeout = "1200";    // defines the number of seconds Web3 will wait for a receipt which confirms that a transaction was mined by the network.
      web3quorum.priv.waitForTransactionReceipt(transactionHash)
        .then(data => {
          contractAddress = data.contractAddress
          console.log(contractAddress);
          args['v'] && console.log(`Transaction receipt:`); //comment for large smartcontracts
          args['v'] && console.log(data); //comment for large smartcontracts
        });
    })
    .catch(e => {
      console.log("Error")
      args['v'] && console.log(`Encountered error:  ${e}`);
    });

  args['v'] && console.log(`writing the smartcontract binary and abi to build folder......`);
  PostDeployKeeping(smartContract.abi, smartContract.bytecode) // For writing the ABI and the smartContract bytecode in build 
};

const deploySmartContract = async (contractOptions) => {
  args['v'] && console.log(`Deploying the smartcontract......`);
  web3quorum.eth.isMining().then(console.log);      // Checks whether the node is mining or not. returns boolean:true if the node is mining, otherwise false.
  return web3quorum.priv.generateAndSendRawTransaction(contractOptions); 
}

const PostDeployKeeping = (abi, bytecode) => {
  try {
    if (!fs.existsSync(outputFolder)) {
      fs.mkdirSync(outputFolder, 0744); // try to create a build folder if not exists
      args['v'] && console.log(`build folder is created`);
    }
  } catch (e) {
    console.log("Error", e)
  }
  try {
    fs.writeFileSync("./build/abi.json", JSON.stringify(abi)) // writing the ABI file
    args['v'] && console.log(`abi is written to abi.json file`);
  } catch (err) {
    console.error(err)
  }
  try {
    fs.writeFileSync("./build/bin.json", JSON.stringify(bytecode)) // writing binary code to the file
    args['v'] && console.log(`bytecode is written to the bin.json file.`);
  } catch (err) {
    console.error(err)
  }
}

deploy() // Calling the deploy function
