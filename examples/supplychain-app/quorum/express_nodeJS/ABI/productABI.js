let productABI = [
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "trackingID",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "location",
        "type": "string"
      }
    ],
    "name": "locationEvent",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "",
        "type": "string"
      }
    ],
    "name": "sendTrackingID",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      },
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
        "internalType": "string[]",
        "name": "_misc",
        "type": "string[]"
      },
      {
        "internalType": "string",
        "name": "_lastScannedAt",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "_participants",
        "type": "string[]"
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
            "name": "misc",
            "type": "string[]"
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
    "name": "allProducts",
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
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "containerKeys",
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
    "name": "containerless",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
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
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getContainerlessAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getProductAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getProductsLength",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
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
    "name": "getSingleProduct",
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
            "name": "misc",
            "type": "string[]"
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
    "name": "productKeys",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_productID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "longLat",
        "type": "string"
      }
    ],
    "name": "updateCustodian",
    "outputs": [
      {
        "internalType": "string",
        "name": "",
        "type": "string"
      },
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_health",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "_misc",
        "type": "string[]"
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
        "components": [
          {
            "internalType": "string",
            "name": "health",
            "type": "string"
          },
          {
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "getContainersLength",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getContainerAt",
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "health",
            "type": "string"
          },
          {
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "view",
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
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_containerID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_lastScannedAt",
        "type": "string"
      }
    ],
    "name": "updateContainerCustodian",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackableTrackingID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_containerTrackingID",
        "type": "string"
      }
    ],
    "name": "packageTrackable",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_containerID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_trackableID",
        "type": "string"
      }
    ],
    "name": "unpackageTrackable",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "trackingID",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "location",
        "type": "string"
      }
    ],
    "name": "locationEvent",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "",
        "type": "string"
      }
    ],
    "name": "sendTrackingID",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_health",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "_misc",
        "type": "string[]"
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
        "components": [
          {
            "internalType": "string",
            "name": "health",
            "type": "string"
          },
          {
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
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
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      },
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
        "internalType": "string[]",
        "name": "_misc",
        "type": "string[]"
      },
      {
        "internalType": "string",
        "name": "_lastScannedAt",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "_participants",
        "type": "string[]"
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
            "name": "misc",
            "type": "string[]"
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
    "name": "allProducts",
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
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "containerKeys",
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
    "name": "containerless",
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
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getContainerAt",
    "outputs": [
      {
        "components": [
          {
            "internalType": "string",
            "name": "health",
            "type": "string"
          },
          {
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
        "name": "",
        "type": "tuple"
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
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getContainerlessAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "getContainersLength",
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
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getProductAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "getProductsLength",
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
            "internalType": "string[]",
            "name": "misc",
            "type": "string[]"
          },
          {
            "internalType": "address",
            "name": "custodian",
            "type": "address"
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
          },
          {
            "internalType": "string[]",
            "name": "containerContents",
            "type": "string[]"
          }
        ],
        "internalType": "struct ContainerContract.Container",
        "name": "",
        "type": "tuple"
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
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "getSingleProduct",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackableTrackingID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_containerTrackingID",
        "type": "string"
      }
    ],
    "name": "packageTrackable",
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
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "productKeys",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_containerID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_trackableID",
        "type": "string"
      }
    ],
    "name": "unpackageTrackable",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_containerID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_lastScannedAt",
        "type": "string"
      }
    ],
    "name": "updateContainerCustodian",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_productID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "longLat",
        "type": "string"
      }
    ],
    "name": "updateCustodian",
    "outputs": [
      {
        "internalType": "string",
        "name": "",
        "type": "string"
      },
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "scan",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "getHistoryLength",
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
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "getHistory",
    "outputs": [
      {
        "components": [
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
          }
        ],
        "internalType": "struct ProductContract.Transaction",
        "name": "",
        "type": "tuple"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
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
        "indexed": false,
        "internalType": "string",
        "name": "trackingID",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "location",
        "type": "string"
      }
    ],
    "name": "locationEvent",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "string",
        "name": "",
        "type": "string"
      }
    ],
    "name": "sendTrackingID",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "allProducts",
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
    "name": "containerless",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
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
    "name": "productKeys",
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      },
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
        "internalType": "string[]",
        "name": "_misc",
        "type": "string[]"
      },
      {
        "internalType": "string",
        "name": "_lastScannedAt",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "_participants",
        "type": "string[]"
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
            "name": "misc",
            "type": "string[]"
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
    "name": "getProductsLength",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getProductAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "_productID",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "longLat",
        "type": "string"
      }
    ],
    "name": "updateCustodian",
    "outputs": [
      {
        "internalType": "string",
        "name": "",
        "type": "string"
      },
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
    "inputs": [
      {
        "internalType": "string",
        "name": "_trackingID",
        "type": "string"
      }
    ],
    "name": "getSingleProduct",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "getContainerlessAt",
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
            "name": "misc",
            "type": "string[]"
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
    "stateMutability": "view",
    "type": "function"
  }
];

module.exports = {
  productABI
}
