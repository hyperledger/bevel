const contract = require('./compile'); //Importing the function to compile smart contract
const Web3 = require('web3');

const numberOfIterations = parseInt(process.env.ITERATIONS) | 200; // Number of Iterations of execution of code for calculation of gas
const smartContract = contract.GetByteCode(numberOfIterations); // Converting smart contract to byte code, optimizing the bytecode conversion for numer of Iterations
const url = process.env.URL;  // url of RPC port of quorum node
const web3 = new Web3(`${url}`); // Creating a provider
const initArguments = process.env.INITARGUMENTS | " ";
const bytecode = `0x${smartContract.bytecode}`;
const unlockPassPhrase = process.env.PASSPHRASE | " ";
const timeTillUnlocked = process.env.TIMETILLUNLOCKED | 600;
const gasEstimate = parseInt(smartContract.gasEstimates.creation.executionCost*numberOfIterations)+parseInt(smartContract.gasEstimates.creation.codeDepositCost); // Gas Estimation
const payload = initArguments !== " " ?{data: bytecode, arguments : initArguments} : {data: bytecode}; // If Initial Argumants are set in ENV variable

const deploy = async ()=>{

    const accounts = await web3.eth.getAccounts(); // Get the accounts created on the quorum node

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
            console.log('Error :', err);
        }
    })
    .then((newContractInstance) => {
        let address = newContractInstance.options.address;
        console.log(address)
        process.env.CONTRACT_ADDRESS = address;
        return(address)
    })
    .catch((data)=>{console.log("promise got rejected",data)});
}

deploy();



