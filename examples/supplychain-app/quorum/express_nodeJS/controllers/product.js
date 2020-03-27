var express = require('express')
  , router = express.Router();

const { productContract, fromAddress, fromNodeSubject } = require('../web3services');
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
          product.productName = toPush.productName;
          product.health = toPush.health;
          product.sold = toPush.sold;
          product.recalled = toPush.recalled;
          product.misc = {};
          for (var j = 0; j < toPush.misc.length; j++) {
            var json = JSON.parse(toPush.misc[j]);
            var key = Object.keys(json);
            product.misc[key] = json[key];
          }
          product.custodian = toPush.custodian,
          product.trackingID = toPush.trackingID,
          product.timestamp = toPush.timestamp,
          product.containerID = toPush.containerID,
          product.linearId = {
          "externalId": null,
          "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
          },
          product.participants = toPush.participants;
          containerlessArray.push(product);
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


        product.custodian = newProduct.custodian,
          product.trackingID = newProduct.trackingID,
          product.timestamp = newProduct.timestamp,
          product.containerID = newProduct.containerID,
          product.linearId = {
            "externalId": null,
            "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
          },
          product.participants = newProduct.participants
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


          product.custodian = toPush.custodian,
            product.trackingID = toPush.trackingID,
            product.timestamp = toPush.timestamp,
            product.containerID = toPush.containerID,
            product.linearId = {
              "externalId": null,
              "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
            },
            product.participants = toPush.participants
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
  res.setTimeout(15000);
  // TODO: Create product
  let newProduct = {
    productName: req.body.productName,
    misc: req.body.misc,
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties
  };
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
      "",
      newProduct.counterparties
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

//PUT for changing custodian
router.put('/:trackingID/custodian', function (req, res) {
  res.setTimeout(15000);
  // TODO: Implement change custodian functionality
  var identityArray = fromNodeSubject.split(',');
  var trackingID = req.params.trackingID;
  var longLatCoordinates = identityArray[3];
  console.log(trackingID);
  console.log(longLatCoordinates);
  productContract.methods
    .updateCustodian(trackingID, longLatCoordinates)
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
