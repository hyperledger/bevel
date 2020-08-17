const path = require('path'); // For resolving paths
const fs = require('fs'); // For reading files
const solc = require('solc'); // solidity compiler

//The function creates the input object by reading the folder provided
var createInput = function(dirname) {
  return new Promise(function(resolve, reject) {
    fs.readdir(dirname, function (err, files) { // Reading the specified folder from parameter for .sol files
        let data = {}
        if(err){
          console.log(err);
        }
        files.forEach(file=>{ // For each file in the folder
          let fileName = file.split(".");
          if (fileName[1] === 'sol'){ // Reading the file only if the extention is .sol
            data[file] = { content: fs.readFileSync(path.resolve(dirname,file),'utf8') } // adding the content of file to the data object in perticular format required by the compiler
          }
        })
        resolve({...data})
    });
      
  });
}

//Main function to convert the solidity code in directory dirname to the bytecode and abi
async function GetByteCode(numberOfIterations, dirname, entrypoint, contractName){

  let source = await createInput(dirname) // running the createInput function for returning the sources object
  .then((data)=>{
    return (data);
  })
  .catch((err)=>{
    console.log("error while compiling", err)
  });

  const input = { //for compiler purpose
      language: 'Solidity', 
      sources: {...source}, // from the createInput() function
      settings: {
        optimizer: {
          enabled: true,
          runs: numberOfIterations // code is optimized to run for numberOfIterations iterations
        },
          outputSelection: { // format of output
              '*': {
                  '*': [ '*' ]
              }
          }
      }
    };

  var output = JSON.parse(solc.compile(JSON.stringify(input))); // compiling the smart contract using the main entrypoint file
  var smartContract = {}; // Creating an object to return only the required data to the caller
  smartContract.bytecode = output.contracts[`${entrypoint}`][`${contractName}`].evm.bytecode.object; // adding bytecode to the variable
  smartContract.abi = output.contracts[`${entrypoint}`][`${contractName}`].abi; // adding abi to the smartContract variable
  smartContract.gasEstimates = output.contracts[`${entrypoint}`][`${contractName}`].evm.gasEstimates; // adding gas estimation to the smartContract variable
  smartContract.totalCost = output.contracts[`${entrypoint}`][`${contractName}`].evm.gasEstimates.creation.totalCost;
  return smartContract;
}

module.exports = {GetByteCode}; //Exporting the GetByteCode() function
