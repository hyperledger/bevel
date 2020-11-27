var express = require('express')
  , router = express.Router();

const {productContract, fromAddress, fromNodeOrganization, fromNodeOrganizationUnit,protocol} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

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
  .call({ from: fromAddress, gas: 324234, gasPrice: "0" })
  .then(response => { 
    var statusOf = response
    res.send({status:statusOf});
    })
  .catch(error => {
    console.log(error);
    res.send("error");
  });
})

router.get('/:trackingID/history', function (req, res) {
  //TODO: Implement location history

  var transactionCount;
  var trackingID = req.params.trackingID;
  console.log(trackingID);
  var allTransaction = [];
  productContract.methods
    .getHistoryLength(req.params.trackingID)
    .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
    .then(async response => {
       transactionCount = response;
       console.log("LENGTH ", transactionCount);
    
      for (var i = 1; i <= transactionCount; i++) { 
        var toPush = await productContract.methods
          .getHistory((i - 1), trackingID)
          .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
          var history = {};
          history.party = toPush.custodian;
          history.party = history.party+","+toPush.lastScannedAt;
          if(protocol==="raft")
            history.time  = (new Date(toPush.timestamp/1000000)).getTime();
          else
            history.time  = (new Date(toPush.timestamp * 1000)).getTime(); 
          history.location = toPush.lastScannedAt;
          allTransaction.push(history);
    }
    res.send(allTransaction)
  })
  .catch(error => {
    console.log(error);
    res.send("error");
  });
});

  module.exports = router
