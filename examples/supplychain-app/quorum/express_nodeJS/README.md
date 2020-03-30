# Supply Chain Application for Quorum
This is a guide for starting the supply chain application on a personal Quorum network using Ganache and Truffle. 

## Requirments 

1. If you need to install Node.js run the command 

        brew install node 

     For **Ubuntu** OS:

        sudo apt-get update
        sudo apt-get install nodejs

     You will need to install npm, which is Node.js package manager.  

        sudo apt-get install npm

2. This application requires Express. Run the command to install express:
        
        npm install express



## Starting the Supply Chain App

3. In terminal, cd to the /quorum/express_nodeJS directory and install the dependencies 

        npm install

4. You will need a minimum of 3 nodes running for the supply chain app. The manufacturer, carrier and warehouse will each have a node. Update the NODE_SUBJECT in .env file to O=Manufacturer,OU=Manufacturer,L=47.38/8.54/Zurich,C=CH. Run the following command to start the node for the manufacturer:

        node app.js

5. Open a new terminal, cd to the /quorum/express_nodeJS directory. Run the command below to start another node. This node will be for the carrier. Use another address from the Ganache CLI that have not been used already. Update the NODE_SUBJECT to reflect the carrier.

        PORT=8081 NODE_IDENTITY=0x.... NODE_ORGANIZATION=PartyB NODE_ORGANIZATIONUNIT=Carrier node app.js 

6. Repeat step 5. This node is for the warehouse.

        PORT=8082 NODE_IDENTITY=0x... NODE_ORGANIZATION=PartyC NODE_ORGANIZATIONUNIT=Warehouse node app.js

Once you have 3 nodes running, you should be ready to able to use Postman to test the APIs.

