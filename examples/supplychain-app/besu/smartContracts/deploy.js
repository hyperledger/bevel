const Web3 = require('web3'); // Importing web3.js library
const EEAClient = require("web3-eea"); // Web3.js wrapper
const fs = require('fs'); // Importing for writing a file
const contract = require('./compile'); //Importing the function to compile smart contract
const minimist = require('minimist'); // Import the library for the arguments

let args = minimist(process.argv.slice(2));
const url = args['url'];  // url of RPC port of besu node
const contractPath = args['path']; // path to the contract directory
const contractEntryPoint = args['entryPoint']; // Smart contract entrypoint eg Main.sol
const contractName = args['contractName']; // Smart Contract Class Nameconst initArguments = process.env.INITARGUMENTS | " ";
const chainId = args['chainId'];
const orionPublicKey = args['orionKey'];
const privateKey = args['privateKey'];
const privateFor = [];
const outputFolder = args['output'] == true? args['output'] : './build';
args['privateFor'].split(',').forEach(item=>privateFor.push(item));
const numberOfIterations = args['numberOfIteration'] | 100;

args['v'] && console.log(`Creating a web3 provider.......`);
const web3 = new EEAClient(new Web3(`${url}`), `${chainId}`);// Creating a provider
var transactionHash = "";  // to store transaction hash to get the transaction receipt 
var contractAddress= "";

const deploy = async ()=>{
    args['v'] && console.log(`Compiling the smartcontract.......`);
    const smartContract = await contract.GetByteCode(numberOfIterations,contractPath,contractEntryPoint,contractName); // Converting smart contract to byte code, optimizing the bytecode conversion for numer of Iterations
    args['v'] && console.log(`Smartcontract converted into bytecode and abi`);
    const contractOptions = {
        data: `0x${smartContract.bytecode}`, // contract binary
        privateFrom: `${orionPublicKey}`,
        privateFor: privateFor,
        privateKey: `${privateKey}`
    };
    args['v'] && console.log(`Created the contract options`);
    await deploySmartContract(contractOptions)
    .then(hash=>{
        transactionHash=hash;
        args['v'] && console.log(`Transaction hash for the deployment is ${hash}`);
        web3.priv.getTransactionReceipt(transactionHash,`${orionPublicKey}`)
        .then(data=>{
            contractAddress=data.contractAddress
            console.log(contractAddress);
            args['v'] && console.log(`Transaction receipt: ${data}`); //comment for large smartcontracts
        });
    })
    .catch(e=>{
      console.log("Error")
      args['v'] && console.log(`Encountered error:  ${e}`); 
    });
    
    args['v'] && console.log(`writing the smartcontract binary and abi to build folder......`);
    PostDeployKeeping(smartContract.abi, smartContract.bytecode) // For writing the ABI and the smartContract bytecode in build 

}

const deploySmartContract= async ( contractOptions )=>{
    args['v'] && console.log(`trying to create a new ccount from private key`);
    const newAccount = await web3.eth.accounts.privateKeyToAccount(`0x${privateKey}`) // Creating new ethereum account from the private key
    args['v'] && console.log(`Deploying the smartcontract......`);
    return web3.eea.sendRawTransaction(contractOptions); // deploy smartcontract with contractoptions
}


const PostDeployKeeping = (abi, bytecode) =>{
    try{
        if (!fs.existsSync(outputFolder)){
            fs.mkdirSync(outputFolder, 0744); // try to create a build folder if not exists
            args['v'] && console.log(`build folder is created`);
        }
    }catch(e){
        console.log("error",e)
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
