var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

router.get('/node-organization', function (req, res) {

  // TODO: Implement get self organization
  // getSelf()
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
})

router.get('/node-organizationUnit', function (req, res) {

  // TODO: Implement get organization unit
  // getRole()
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
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

router.get('/:trackingID/history', function (req, res) {
  // TODO: Implement location history
  // locationHistory(req.params.trackingID)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
})

  module.exports = router
