var containerABI = [
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
		"name": "containerAdded",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "health",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "misc",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "custodian",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "lastScannedAt",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "trackingID",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "containerID",
						"type": "string"
					},
					{
						"internalType": "string[]",
						"name": "participants",
						"type": "string[]"
					}
				],
				"indexed": false,
				"internalType": "struct containerContract.Container[]",
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
						"name": "health",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "misc",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "custodian",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "lastScannedAt",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "trackingID",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "containerID",
						"type": "string"
					},
					{
						"internalType": "string[]",
						"name": "participants",
						"type": "string[]"
					}
				],
				"indexed": false,
				"internalType": "struct containerContract.Container",
				"name": "container",
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
			},
			{
				"internalType": "string[]",
				"name": "_counterparties",
				"type": "string[]"
			}
		],
		"name": "addContainer",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
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
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "containerSupplyChain",
		"outputs": [
			{
				"internalType": "string",
				"name": "health",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "misc",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "custodian",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "lastScannedAt",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "trackingID",
				"type": "string"
			},
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
		"name": "getAllContainers",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "health",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "misc",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "custodian",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "lastScannedAt",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "trackingID",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timestamp",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "containerID",
						"type": "string"
					},
					{
						"internalType": "string[]",
						"name": "participants",
						"type": "string[]"
					}
				],
				"internalType": "struct containerContract.Container[]",
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

module.exports = containerABI;