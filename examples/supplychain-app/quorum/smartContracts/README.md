# Deploying a personal Ethereum network for testing

## Requirments 
Ganache CLI<br>
Truffle<br>

## Ganache CLI:
Ganache is a personal Ethereum network that allows you to test smart contracts during development. Install Ganache-cli with the command below:<br>

`npm install -g ganache-cli`

1. In terminal, change directory to quorum/smartContracts and run command below to start the personal network. You will see the addresses of available accounts that can be used when running the supply chain application <br>

        ganache-cli --allowUnlimitedContractSize --gasLimit=68219752232 



2. Open the .env file in quorum/express_nodeJS. Copy the first address generated from the Ganache-CLI and paste it in the .env file where 

        NODE_IDENTITY = "Enter an address"


## Truffle
3. Truffle is used for compiling smart contracts and deploying the smart contracts onto Ganache. Use the command below to install Truffle. <br>

        npm install -g truffle


4. Install truffle export abi, a tool used for extracting the ABI and storing it to a file named ABI.json. 

         npm install -g truffle-export-abi

5. Open a new terminal and inside the quorum/smartContracts directory, run the command truffle compile. This command will compile contracts in the correct order and ensure all dependencies are sent to the compiler. The contracts will not get deployed with this commmand. 
        
        truffle compile 

6. When you make a change to the smart contracts, you will need to update the productABI.js file. To do so, you will need to run the command below, copy the ABI from ABI.json and paste it in productABI.js. If no changes were made, move to the next step.

        truffle-export-abi

7.  Run truffle migrate to deploy the smart contracts on the network. 
        
        truffle migrate

8. Copy the **contract address** of _general_contract.js and past it in the .env file

        #CONTRACT ADDRESS
        PRODUCT_CONTRACT_ADDRESS = "Enter address where contract is deployed from "

<br> Once these steps are completed, follow the README in quorum/express directory to start the supply chain application.

# Deploying Smart Contract on Quorum network using javaScript

## Requirments 
- node<br>
- npm<br>


1. In terminal, change directory to quorum/smartContracts and run command below to install the required packages listed in package.json .<br>

        npm install 

2. In terminal, run the javaScript program deploy.js using the command below.<br>

        node deploy.js "< address of quorum node with RPC port >" "< path to the contracts folder>" "< main entrypoint contract filename >" "< Name of the contract >" "< Public keys in csv format for privateFor >"

 The program by default optimizes the smart contract and the gas to run the contract for 200 iterations, it can be increased or decresed using the environment variable *ITERATIONS*. Initial arguments to the smart contract is passed by setting the environment variable *INITARGUMENTS*.<br>

        export ITERATIONS=< number of iterations > && export INITARGUMENTS="<initial arguments >" && node deploy.js "< address of quorum node with RPC port >" "< path to the contracts folder>" "< main entrypoint contract filename >" "< Name of the contract >" "< Public keys in csv format for privateFor >"

The address where the smart contract is deployed will be returned and printed to the console and also exported to an environment variable *CONTRACT_ADDRESS* after the successful execution of the script.

