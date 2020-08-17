# Deploying Smart Contract on Besu network using javaScript

## Requirments 
- node<br>
- npm<br>


1. In terminal, change directory to blockchain-automation-framework\examples\supplychain-app\besu and run command below to install the required packages listed in package.json .<br>

        npm install 

2. In terminal, run the javaScript program deploy.js using the command below.<br>

        node deploy.js --url "< address of besu node with RPC port >" --path "< path to the contracts folder>" --entryPoint "< main entrypoint contract filename >" --contractName "< Name of the contract >" --chainId <chainId> --orionKey "< orion key of the node, privateFrom >" --privateKey "< private key of the node >" --privateFor '< csv value of the privateFor orion public keys >' --numberOfIterations < optimizes for number of iteration > --output <"path to output folder default is ./build"> -v

 The program by default optimizes the smart contract and the gas to run the contract for 100. iterations.<br>


