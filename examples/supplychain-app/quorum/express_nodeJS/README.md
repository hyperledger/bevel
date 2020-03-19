# Supply Chain Application for Quorum
This is a guide for starting the supply chain application on a personal Quorum network using Ganache and Truffle. 

## Requirments 

1. If you need to install Node.js, run the command `brew install node`. 

2. This application requires Express. Run the command to install express:
     `npm install express`



## Starting the Supply Chain App

3. In terminal, cd to the /quorum/express_nodeJS directory and install the dependencies 

        npm install

4. Run the command below to start the first node. You will need a minimum of 3 nodes running for the supply chain app. The manufacturer, carrier and warehouse will each have a node.

        node app.js

5. Open a new terminal, cd to the /quorum/express_nodeJS directory. Run the command below to start another node. This node will be for the carrier. Use another address from the Ganache CLI that have not been used already.

        PORT=8081 NODE_IDENTITY=0x.... NODE_ORGANIZATION=PartyB NODE_ORGANIZATIONUNIT=Carrier nodemon app.js 

6. Repeat step 5. This node is for the warehouse.

        PORT=8082 NODE_IDENTITY=0x... NODE_ORGANIZATION=PartyC NODE_ORGANIZATIONUNIT=Warehouse nodemon app.js

