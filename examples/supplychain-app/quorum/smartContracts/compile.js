const path = require('path'); 
const fs = require('fs');
const solc = require('solc');


var createInput = function(dirname) {
  return new Promise(function(resolve, reject) {
    fs.readdir(dirname, function (err, files) {
        let data = {}
        if(err){
          console.log(err);
        }
        files.forEach(file=>{
          let fileName = file.split(".");
          if (fileName[1] === 'sol'){
            data[file] = { content: fs.readFileSync(path.resolve(dirname,file),'utf8') }
          }
        })
        resolve({...data})
    });
      
  });
}

async function GetByteCode(numberOfIterations, dirname, entrypoint, contractName){

  let source = await createInput(dirname)
  .then((data)=>{
    return (data);
  })
  .catch((err)=>{
    console.log("error while compiling", err)
  });

  const input = {
      language: 'Solidity',
      sources: {...source},
      settings: {
        optimizer: {
          enabled: true,
          runs: numberOfIterations
        },
          outputSelection: {
              '*': {
                  '*': [ '*' ]
              }
          }
      }
    };

  var output = JSON.parse(solc.compile(JSON.stringify(input))); // compiling the smart contract using the main entrypoint file
  var smartContract = {};
  smartContract.bytecode = output.contracts[`${entrypoint}`][`${contractName}`].evm.bytecode.object;
  smartContract.abi = output.contracts[`${entrypoint}`][`${contractName}`].abi;
  smartContract.gasEstimates = output.contracts[`${entrypoint}`][`${contractName}`].evm.gasEstimates;
  smartContract.totalCost = output.contracts[`${entrypoint}`][`${contractName}`].evm.gasEstimates.creation.totalCost;
  return smartContract;
}

module.exports = {GetByteCode};
