var express = require('express')
  , router = express.Router();

const { productContract, fromAddress, fromNodeSubject,protocol } = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

// Get products not assigned to a container

router.get('/containerless', function (req, res) {
  var productCount;
  var containerlessArray = [];
  productContract.methods
    .getProductsLength()
    .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
    .then(async response => {
      productCount = response;
      console.log("LENGTH ", response);
      for (var i = 1; i <= productCount; i++) {
        var toPush = await productContract.methods
          .getContainerlessAt(i - 1)
          .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
        var product = {};
        if (toPush.trackingID != 0) {
          product.trackingID = toPush.trackingID;
          product.productName = toPush.productName;
          product.health = toPush.health;
          product.sold = toPush.sold;
          product.recalled = toPush.recalled;
          product.custodian = toPush.custodian;
          product.custodian = product.custodian + "," + toPush.lastScannedAt;
          if(protocol==="raft")
            product.time  = (new Date(toPush.timestamp/1000000)).getTime();
          else
            product.time  = (new Date(toPush.timestamp * 1000)).getTime();
          product.lastScannedAt = toPush.lastScannedAt;
          product.containerID = toPush.containerID;
          product.misc = {};
          for (var j = 0; j < toPush.misc.length; j++) {
            var json = JSON.parse(toPush.misc[j]);
            var key = Object.keys(json);
            product.misc[key] = json[key];
          }
          product.linearId = {
            "externalId": null,
            "id": toPush.trackingID
          };
          product.participants = toPush.participants;
          containerlessArray.push(product);
        }
      }
      res.send(containerlessArray)
    })
});

//GET product with or without trackingID
// Get single product
router.get('/:trackingID?', function (req, res) {
  if (req.params.trackingID != null) {
    const trackingID = req.params.trackingID;
    console.log(trackingID, "***");
    productContract.methods
      .getSingleProduct(req.params.trackingID)
      .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
      .then(response => {
        var newProduct = response;
        var product = {};
        product.productName = newProduct.productName;
        product.health = newProduct.health;
        product.sold = false;
        product.recalled = false;
        product.misc = {};

        for (var j = 0; j < newProduct.misc.length; j++) {
          var json = JSON.parse(newProduct.misc[j]);
          var key = Object.keys(json);
          product.misc[key] = json[key];
        }

        product.custodian = newProduct.custodian;
          product.custodian = product.custodian + "," + newProduct.lastScannedAt;
          product.trackingID = newProduct.trackingID;
          if(protocol==="raft")
            product.timestamp  = (new Date(newProduct.timestamp/1000000)).getTime();
          else
            product.timestamp  = (new Date(newProduct.timestamp * 1000)).getTime();
          product.containerID = newProduct.containerID;
          product.linearId = {
            "externalId": null,
            "id": newProduct.trackingID
          };
          product.participants = newProduct.participants;
        res.send(product);

      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  } else {
    // TODO: Get all products
    var arrayLength;
    var displayArray = [];
    productContract.methods
      .getProductsLength()
      .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
      .then(async response => {
        arrayLength = response;
        console.log("LENGTH ", response);
        for (var i = 1; i <= arrayLength; i++) {
          var toPush = await productContract.methods
            .getProductAt(i)
            .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
          var product = {};
          product.productName = toPush.productName;
          product.health = toPush.health;
          product.sold = false;
          product.recalled = false;
          product.misc = {};
          for (var j = 0; j < toPush.misc.length; j++) {
            var json = JSON.parse(toPush.misc[j]);
            var key = Object.keys(json);
            product.misc[key] = json[key];
          }


          product.custodian = toPush.custodian;
            product.custodian = product.custodian + "," + toPush.lastScannedAt;
            product.trackingID = toPush.trackingID;
            if(protocol==="raft")
              product.timestamp  = (new Date(toPush.timestamp/1000000)).getTime();
            else
              product.timestamp  = (new Date(toPush.timestamp * 1000)).getTime();
            product.containerID = toPush.containerID;
            product.linearId = {
              "externalId": null,
              "id": toPush.trackingID
            };
            product.participants = toPush.participants;
          displayArray.push(product);
        }
        res.send(displayArray)
      })
      .catch(err => {
        res.send(err.message);
        console.log(err);
      })
  }
})

//POST for new product
router.post('/', upload.array(), function (req, res) {
  // TODO: Create product
  let newProduct = {
    productName: req.body.productName,
    misc: req.body.misc,
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties,
    lastScannedAt: fromNodeSubject
  };
  // Add this.address in the counterparties list
  newProduct.counterparties.push(fromAddress+","+fromNodeSubject);
  var misc = [];
  var keys = Object.keys(newProduct.misc);

  for (var i = 0; i < keys.length; i++) {
    var x = "{ \"" + keys[i] + '\": ' + JSON.stringify(newProduct.misc[keys[i]]) + "}";
    misc.push(x);
  }
  console.log(misc);
  productContract.methods
    .addProduct(
      newProduct.trackingID,
      newProduct.productName,
      "health",
      misc,
      newProduct.lastScannedAt,
      newProduct.counterparties,
    )
    .send({ from: fromAddress, gas: 6721975, gasPrice: "0" })
    .on("receipt", function (receipt) {
      // receipt example
      if (receipt.status === true) {
        res.send({ generatedID: newProduct.trackingID });
        console.log(receipt.events.productHistoryEvent.returnValues)

      }
      if (receipt.status === false) {
        console.log("Request error");
        res.send("Transaction not successful");
      }
    })
    .on("error", function (error) {
      res.send("Error! " + error);
      console.log("error" + JSON.stringify(error, null, 4));
      console.log(error);
    });
})

//PUT for updating custodian
router.put('/:trackingID/custodian', function (req, res) {
  // TODO: Implement change custodian functionality
  var identityArray = fromNodeSubject.split(',');
  var trackingID = req.params.trackingID;
  var longLatCoordinates = identityArray[3];
  var lastScannedAt = fromNodeSubject;
  console.log(trackingID);
  console.log(longLatCoordinates);
  productContract.methods
    .updateCustodian(trackingID, lastScannedAt)
    .send({ from: fromAddress, gas: 6721975, gasPrice: "0" })
    .then(response => {
      res.send(response)
    })
    .catch(error => {
      console.log(error)
      res.send(error.message)
    })
});

module.exports = router
