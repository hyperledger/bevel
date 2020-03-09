var express = require('express')
  , router = express.Router();

const {productContract, fromAddress, fromNodeOrganization, fromNodeOrganizationUnit} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');
////
router.use(bodyParser.json()); // for parsing application/json

router.get('/node-organization', function (req, res) {

  res.send({organization:fromNodeOrganization})
  
})

router.get('/node-organizationUnit', function (req, res) {

  res.send({organizationUnit:fromNodeOrganizationUnit})

})

router.get('/:trackingID/scan', function (req, res) {
  productContract.methods 
  .scan(req.params.trackingID)
  .send({ from: fromAddress, gas: 324234, gasPrice: "30000000" })
  .then(response => { 
    res.send(response.events.sendString.returnValues[0]);
  })
  .catch(error => {
    console.log(error);
    res.send("error");
  });
})

/*
var transaction = productContract.productHistoryEvent();
  transaction.watch(function(error, result) {
    if(!error){
      (result);
    }}
*/

router.get('/:trackingID/history', function (req, res) {
  //TODO: Implement location history
  var transactionCount;
  var trackingID = req.params.trackingID;
  var allTransaction = [];
  productContract.methods
    .getHistoryLength(trackingID)
    
    .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
    .then(async response => {
      transactionCount = response;
      console.log("LENGTH ", response);
      for (var i = 1; i <= transactionCount; i++) { 
        var toPush = await productContract.methods
          .getHistory((i - 1), trackingID)
          .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
          var productHistory = {};
          productHistory.custodian = toPush.custodian,
          productHistory.lastScannedAt = toPush.lastScannedAt,
          productHistory.timestamp = toPush.timestamp,
          allTransaction.push(productHistory);
          console.log[trackingID][0];
    }
    res.send(allTransaction)
  })
});
/*
router.get('/:trackingID/history', function (req, res) {
  //productContract.methods
    productContract.methods.productHistoryEvent({fromBlock: 0}) 
    .send({ from: fromAddress, gas: 324234, gasPrice: "30000000" })
    .on("receipt", function (receipt) {
    var productTransaction = {}
    productTransaction[req.params.trackingID] = [];
    console.log(receipt.events.productHistoryEvent.returnValues)

    
    let eventTrigger = receipt.event.returnValues;

    productTransaction[req.params.trackingID].push(eventTrigger);
    console.log(productTransaction);
    */
    /*
    productTransaction.custodian = eventTrigger.custodian;
    productTransaction.lastScannedAt = eventTrigger.lastScannedAt;
    productTransaction.timestamp = eventTrigger.timestamp;*/
    
/*
    obj[trackingID] = [];
    obj[tackingID].push(event)
    
     
    
    array.push(obj())
    */
     

 
 // module.exports = 
  module.exports = router
