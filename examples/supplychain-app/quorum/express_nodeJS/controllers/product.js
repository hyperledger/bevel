var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

router.get('/containerless', function (req,res){
  // TODO: Get products not assigned to a container
  // getContainerlessProducts()
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
})

//GET product with or without trackingID
// Get single product
router.get('/:trackingID?', function (req, res) {
  if (req.params.trackingID != null) {
    const trackingID = req.params.trackingID;
    console.log(trackingID, "***");
    productContract.methods
      .getSingleProduct(req.params.trackingID)
      .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then(response => {
        console.log("#@#$#$@#$@#$", response);
        res.send({
          "productName": response.responseName,
          "health": response.health,
          "sold": false,
          "recalled": false,
          "misc": response.misc,
          "custodian": response.custodian,
          "trackingID": response.trackingID,
           "timestamp": response.timestamp,
           "containerID": response.containerID,
          "linearId": {
              "externalId": null,
              "id": response.trackingID
          },
          "participants": response.participants
      });
      
      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  }else {
    // TODO: Get all products
    var arrayLength;
    var displayArray = [];
    productContract.methods //do thing with 5 array 
    .getProductsLength()
    .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})
    .then(async response => {
      arrayLength = response; 
      for(var i = 1; i <= arrayLength; i++){
        var toPush = await productContract.methods
        .getProductAt(i)
        .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})

        var product = {
          "productName": toPush.productName,
          "health": toPush.health,
          "sold": false,
          "recalled": false,
          "misc": toPush.misc,
          "custodian": toPush.custodian,
          "trackingID": toPush.trackingID,
           "timestamp": toPush.timestamp,
           "containerID": toPush.containerID,
          "linearId": {
              "externalId": null,
              "id": "af9efb7f-d13b-4b68-a10b-e680b5d2b2b0"
          },
          "participants": toPush.participants
      };
        console.log("^^^^",toPush.trackingID);
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
router.post('/',upload.array(),function(req,res) {
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

  for(var i = 0; i < keys.length; i++){
    misc.push(keys[i]);
    misc.push(newProduct.misc[keys[i]])
  }

  productContract.methods
    .addProduct( 
      newProduct.trackingID,
      newProduct.productName,
      "health",
      misc,
      "",
      []
    )
    .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
    .on("receipt", function(receipt) {
      // receipt example
      if (receipt.status === true) {
        res.send({generatedID: newProduct.trackingID});
      }
      if (receipt.status === false) {
        console.log("Request error");
        res.send("Transaction not successful");
      }
    })
    .on("error", function(error) {
      res.send("Error! "+ error);
      console.log("error" + JSON.stringify(error, null, 4));
      console.log(error);
    });
})

//PUT for changing custodian
router.put('/:trackingID/custodian', function(req,res) {
  res.setTimeout(15000);
  // TODO: Implement change custodian functionality
  var trackingID = req.params.trackingID;
  console.log(trackingID);
    productContract.methods
      .updateCustodian(trackingID,"","" )
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then( response => {
        res.send(response)
      })
      .catch(error => {
        console.log(error)
        res.send(error.message)
      })
});

module.exports = router
