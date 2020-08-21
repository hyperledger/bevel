# Deploying Smart Contract on Besu network using javaScript

## Requirments 
- node<br>
- npm<br>


1. In terminal, go to examples/supplychain-app/besu/smartContracts directory and run command below to install the required packages listed in package.json .<br>

```
    npm install 
```

2. In terminal, run the javaScript program deploy.js using the command below.<br>

```
node deploy.js -v --url "< address of besu node with RPC port >" --path "< path to the contracts folder>" --entryPoint "< main entrypoint contract filename >" --contractName "< Name of the contract >" --chainId <chainId> --orionKey "< orion key of the node, privateFrom >" --privateKey "< private key of the node without 0x>" --privateFor '< csv value of the privateFor orion public keys >' --numberOfIterations < optimizes for number of iteration > --output <"path to output folder default is ./build">

#Example
node deploy.js -v --url "http://store.bes.demo.aws.blockchaincloudpoc.com:15041" --path "../../quorum/smartContracts/contracts/" --entryPoint "General.sol" --contractName "General" --chainId 2018 --orionKey "de4w15LpzAPKQEsras7xRlFgfBiJKw703qQYEyCQvzg=" --privateKey "a734ba183d3d78d6eccf581e8f330d9eb6509ed279cbe41adf20fdb4ff140aff" --privateFor "yaLJyJ22sQX9g3qEAnlXjQ/vhLpPtPsip64dNzemNjc=,PJFup1IFQr94venAt4/40VnceyjfjwkwqRt3iiJV3E4=" --numberOfIterations 20

```

 The program by default optimizes the smart contract and the gas to run the contract for 100 iterations if you do not provide that parameter.<br>
