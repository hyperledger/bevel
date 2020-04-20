const path = require('path'); 
const fs = require('fs');
const solc = require('solc'); 

function GetByteCode(numberOfIterations){
  // Importing the contract main entrypoint and the supporting files for the smart contract
  const general = path.resolve(__dirname,'contracts','General.sol');
  const containerContract = path.resolve(__dirname,'contracts','ContainerContract.sol');
  const permission = path.resolve(__dirname,'contracts','Permission.sol');
  const productContract = path.resolve(__dirname,'contracts','ProductContract.sol');

  const solGeneral = fs.readFileSync(general,'utf8');
  const solContainerContract = fs.readFileSync(containerContract,'utf8');
  const solPermission = fs.readFileSync(permission,'utf8');
  const solProductContract = fs.readFileSync(productContract,'utf8');

  const input = {
      language: 'Solidity',
      sources: {
        'General.sol': {
            content: solGeneral
          },
        'ContainerContract.sol': {
            content: solContainerContract
          },
        'ProductContract.sol': { 
            content: solProductContract
          },
        'Permission.sol': {
            content: solPermission
          }
      },
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
  smartContract.bytecode = output.contracts['General.sol']['General'].evm.bytecode.object;
  smartContract.abi = output.contracts['General.sol']['General'].abi;
  smartContract.gasEstimates = output.contracts['General.sol']['General'].evm.gasEstimates;
  smartContract.totalCost = output.contracts['General.sol']['General'].evm.gasEstimates.creation.totalCost;
  return smartContract;
}
module.exports = {GetByteCode};
