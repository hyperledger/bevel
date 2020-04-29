const Web3 = require('web3');
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

const deploy = async ()=>{

    const smartContract = await contract.GetByteCode(numberOfIterations,contractPath,contractEntryPoint,contractName); // Converting smart contract to byte code, optimizing the bytecode conversion for numer of Iterations
    const accounts = await web3.eth.getAccounts(); // Get the accounts created on the quorum node
    console.log("from account: ", accounts[0])
    const bytecode = `0x${smartContract.bytecode}`;
    const gasEstimate = parseInt(smartContract.gasEstimates.creation.executionCost*numberOfIterations)+parseInt(smartContract.gasEstimates.creation.codeDepositCost); // Gas Estimation
    const payload = initArguments !== " " || initArguments !== Number(0) ?{data: bytecode, arguments : initArguments} : {data: bytecode}; // If Initial Argumants are set in ENV variable

    //TODO account unlocking
    // web3.eth.personal.unlockAccount(accounts[0], unlockPassPhrase , parseInt(timeTillUnlocked)) 
    // .then(console.log('Account unlocked!'));

    let myContract = new web3.eth.Contract(smartContract.abi); // defigning the contract using interface
    let parameter = {
        type: "quorum",
        from: accounts[0],
        gasPrice: 0,
        gas: gasEstimate
    }
    
    
    myContract.deploy(payload).send(parameter, (err, transactionHash) => { //deploying the contract
        if(err){
            console.log("Error")
            console.log('Error :', err);
        }
    })
    .then((newContractInstance) => {
        let address = newContractInstance.options.address;
        console.log("contract is stored at the address:",address);
        console.log("contract Name: ", contractName)
        process.env.CONTRACT_ADDRESS = address;
        return(address)
    })
    .catch((data)=>{console.log("promise got rejected",data)});
}

deploy();



