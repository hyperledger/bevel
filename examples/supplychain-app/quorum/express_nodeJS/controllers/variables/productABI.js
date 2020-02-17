var productABI = [
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
		"anonymous": false,
		"inputs": [
			{
				"components": [
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
				"indexed": false,
				"internalType": "struct productContract.Product[]",
				"name": "array",
				"type": "tuple[]"
			}
		],
		"name": "sendArray",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"components": [
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
				"indexed": false,
				"internalType": "struct productContract.Product",
				"name": "product",
				"type": "tuple"
			}
		],
		"name": "sendObject",
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
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "allProds",
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
		"constant": false,
		"inputs": [],
		"name": "getAllProducts",
		"outputs": [
			{
				"components": [
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
				"internalType": "struct productContract.Product[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
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
				"name": "misc",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_trackingID",
				"type": "string"
			},
			{
				"internalType": "string[]",
				"name": "_counterparties",
				"type": "string[]"
			}
		],
		"name": "updateProduct",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

 
module.exports = productABI;