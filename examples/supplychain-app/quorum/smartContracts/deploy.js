const Web3 = require('web3');
const fs = require('fs'); // Importing for writing a file
const contract = require('./compile'); //Importing the function to compile smart contract

const url = process.argv[2];  // url of RPC port of quorum node
const contractPath = process.argv[3]; // path to the contract directory
const contractEntryPoint = process.argv[4]; // Smart contract entrypoint eg Main.sol
const contractName = process.argv[5]; // Smart Contract Class Nameconst initArguments = process.env.INITARGUMENTS | " ";
const initArguments = process.env.INITARGUMENTS | " ";
const unlockPassPhrase = process.env.PASSPHRASE | " "; // Passphrase to unlock the account
const timeTillUnlocked = process.env.TIMETILLUNLOCKED | 600;
const numberOfIterations = parseInt(process.env.ITERATIONS) | 200; // Number of Iterations of execution of code for calculation of gas

const web3 = new Web3(`${url}`); // Creating a provider

var transactionHash = "";  // to store transaction hash to get the transaction recipt 

const deploy = async ()=>{

    const smartContract = await contract.GetByteCode(numberOfIterations,contractPath,contractEntryPoint,contractName); // Converting smart contract to byte code, optimizing the bytecode conversion for numer of Iterations
    const accounts = await web3.eth.getAccounts(); // Get the accounts created on the quorum node
    console.log("Trying to deploy contract using account: ", accounts[0])
    const bytecode = `0x${smartContract.bytecode}`; // adding 0x prefix to the bytecode
    const gasEstimate = parseInt(smartContract.gasEstimates.creation.executionCost*numberOfIterations)+parseInt(smartContract.gasEstimates.creation.codeDepositCost); // Gas Estimation
    const payload = initArguments !== " " || initArguments !== Number(0) ?{data: bytecode, arguments : initArguments} : {data: bytecode}; // If Initial Argumants are set in ENV variable

    //TODO account unlocking
    // web3.eth.personal.unlockAccount(accounts[0], unlockPassPhrase , parseInt(timeTillUnlocked)) 
    // .then(console.log('Account unlocked!'));

    let myContract = await new web3.eth.Contract(smartContract.abi); // defigning the contract using interface
    let parameter = {
        type: "quorum", // type of the network
        from: accounts[0], // Account used to deploy the smartContract
        gasPrice: 0, // price of a unit of gas in ether
        gas: gasEstimate // available gas unit to be spent
    }

    // use the privateFor if found in arguments
    if(process.argv[6] && process.argv[6] !== "0"){ // "0" is used for the automation purposes
        parameter["privateFor"] = process.argv[6].split(','); //splitting the string of the private keys by ',' to convert it in array.
    }
    DeployContract(payload, parameter, myContract); // run deploy Contract function
    PostDeployKeeping(smartContract.abi, smartContract.bytecode) // For writing the ABI and the smartContract bytecode in build 
}

const DeployContract = (payload, parameter, myContract) =>{
    myContract.deploy(payload).send(parameter, (err, hash) => { //deploying the contract
        if(err){
            console.log("Error")  // consoling the Error for ansible purposes
            console.log('Error :', err); // logging the error on the screen
        }
        transactionHash = hash; // storing transaction hash to get the transaction recipt
    })
    .then((newContractInstance) => {
        let address = newContractInstance.options.address;
        console.log("contract is stored at the address:",address); // consoling the contract address on the screen
        console.log("contract Name: ", contractName); // returning the contract address
        process.env.CONTRACT_ADDRESS = address; // exporting the contract address to an Environment variable
        web3.eth.getTransactionReceipt(transactionHash).then((transaction)=>{
            console.log("Transaction Recipt for the transaction hash ",transactionHash," : ",transaction); // logging the transaction recipt
        });
        return(address);
    })
    .catch((data)=>{console.log("promise got rejected",data)}); // catching the error in the promise
}

const PostDeployKeeping = (abi, bytecode) =>{
    try {
        fs.writeFileSync("./build/abi.json", JSON.stringify(abi)) // writing the ABI file
      } catch (err) {
        console.error(err)
      }
      try {
        fs.writeFileSync("./build/bin.json", JSON.stringify(bytecode)) // writing binary code to the file
      } catch (err) {
        console.error(err)
      }
}

deploy(); // calling the deploy() function
