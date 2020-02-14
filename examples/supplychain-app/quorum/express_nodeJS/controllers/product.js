/* This file contains all routes and API calls for the Product Smart Contract
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
var address = process.env['TOADDRESS'];
var fromAddress = process.env['FROMADDRESS'];

/* ABI generated from smart contract
* has definition for all methods and variables in contract
*/
var abi = [
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "ID",
				"type": "string"
			}
		],
		"name": "productAdded",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_productName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_health",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_misc",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_trackingID",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_lastScannedAt",
				"type": "string"
			}
		],
		"name": "addProduct",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "count",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "counterparties",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAllProducts",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "miscellaneous",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "supplyChain",
		"outputs": [
			{
				"internalType": "string",
				"name": "productName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "health",
				"type": "string"
			},
			{
				"internalType": "bool",
				"name": "sold",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "recalled",
				"type": "bool"
			},
			{
				"internalType": "string",
				"name": "custodian",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "trackingID",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "lastScannedAt",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "transactionHistory",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "containerID",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

//instantiate the product smartcontract 
var productContract = new web3.eth.Contract(abi, address);

//POST METHODS

//Post New Product Method 
router.post("/api/v1/product", function(req, res) {
  let newProduct = {
    productName: req.body.productName,
    misc: { name: req.body.misc.name },
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties
  };

  productContract.methods
    .addProduct(
      newProduct.productName,
      "health",
      JSON.stringify(newProduct.misc),
      newProduct.trackingID,
      ""
    )
    .send({ from: fromAddress })
    .on("receipt", function(receipt) {
      // receipt example
      console.log(receipt);
      if (receipt.status === true) {
        res.send("Transaction successful");
      }
      if (receipt.status === false) {
        res.send("Transaction not successful");
      }
    })
    .on("error", function(error, receipt) {
      res.send("Error! "+ JSON.stringify(error, null, 4));
      console.log("error" + JSON.stringify(error, null, 4));
      console.log(error);
    });
});



module.exports = router;