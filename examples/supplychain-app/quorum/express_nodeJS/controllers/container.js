/* This file contains all routes and API calls for the Container Smart Contract
*/

var Web3 = require("web3");
var express = require("express"),
  router = express();
var bodyParser = require("body-parser");
require('dotenv').config(".env");

const web3Host = process.env['WEB3_LOCAL_HOST'];
const port = process.env['PORT'];

web3 = new Web3(new Web3.providers.HttpProvider(web3Host));

//set up the express router
router.use(bodyParser.json()); // for parsing application/json
// const port = 8000;
router.get("/", (req, res) => res.send("You have reached the correct endpoint, please use complete API paths for requests"));
router.listen(port, () =>
  console.log(`App listening on port ${port}!`)
);

/* address of smart contract
*/ 
var address = process.env['CONTAINERADDRESS'];
var fromAddress = process.env['CONTAINERFROMADDRESS'];

/* ABI generated from smart contract
* has definition for all methods and variables in contract
*/
var abi = require("./variables/containerABI");

//instantiate the product smartcontract 
var containerContract = new web3.eth.Contract(abi, address);

//POST METHODS

//Post New Container Method 
router.post("/api/v1/container", function(req, res) {
  let newContainer = {
    misc: { name: req.body.misc.name },
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties
  };

  var isInArray = false;

  if(newContainer.counterparties.includes(fromAddress)){

    isInArray = true;
  } 
  console.log(isInArray);
  if(isInArray) {
    containerContract.methods
        .addContainer(
        "health",
        JSON.stringify(newContainer.misc),
        newContainer.trackingID,
        "",
        newContainer.counterparties,
        )
        .send({ from: fromAddress, gas: 6721975, gasPrice: '30000000' })
        .on("receipt", function(receipt) {
        console.log(receipt);
        console.log(receipt.events.sendObject.returnValues);
        if (receipt.status === true) {
            res.send("Transaction successful");
        }
        if (receipt.status === false) {
            res.send("Transaction not successful");
        }
        })
        .on("error", function(error, receipt) {
        res.send({message: "Error! "});
        console.log(error);
        });
} else {
    res.send("Transaction not sent. Your address is not in counterparties list");
}
});

// Get Containers method 
router.get("/api/v1/container", function(req, res) {
	containerContract.methods
	.getAllContainers()
	.send({ from: fromAddress, gas: 6721975, gasPrice: '30000000'})
	.then(response => {
	res.send(response.events.sendArray.returnValues.array);
	})
	.catch(err => {
	console.log(err);
	})
});



module.exports = router;