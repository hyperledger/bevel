let productABI = [
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "inputs": [],
    "name": "last_completed_migration",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "completed",
        "type": "uint256"
      }
    ],
    "name": "setCompleted",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "isOwner",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
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
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product",
        "name": "product",
        "type": "tuple"
      }
    ],
    "name": "sendProduct",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product[]",
        "name": "array",
        "type": "tuple[]"
      }
    ],
    "name": "sendProductArray",
    "type": "event"
  },
  {
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
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "isOwner",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
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
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "products",
    "outputs": [
      {
        "internalType": "string",
        "name": "trackingID",
        "type": "string"
      },
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
        "internalType": "address",
        "name": "custodian",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "lastScannedAt",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "containerID",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
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
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getAllProducts",
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product[]",
        "name": "",
        "type": "tuple[]"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
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
    "anonymous": false,
    "inputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product",
        "name": "product",
        "type": "tuple"
      }
    ],
    "name": "sendProduct",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product[]",
        "name": "array",
        "type": "tuple[]"
      }
    ],
    "name": "sendProductArray",
    "type": "event"
  },
  {
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
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "containers",
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
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "count",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
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
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "getAllProducts",
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "trackingID",
            "type": "string"
          },
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
            "internalType": "address",
            "name": "custodian",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "timestamp",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "lastScannedAt",
            "type": "string"
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
        "internalType": "struct ProductContract.Product[]",
        "name": "",
        "type": "tuple[]"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "isOwner",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
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
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "products",
    "outputs": [
      {
        "internalType": "string",
        "name": "trackingID",
        "type": "string"
      },
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
        "internalType": "address",
        "name": "custodian",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "lastScannedAt",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "containerID",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
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
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
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
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "getSingleContainer",
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
        "internalType": "struct containerContract.Container",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

  module.exports = {
      productABI
  }