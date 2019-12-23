var express = require('express')
  , router = express.Router()
const {getProducts, getProductByID, newProduct, receiveProduct, getContainerlessProducts} = require('../api')
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

router.get('/containerless', function (req,res){
  getContainerlessProducts()
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

//GET product with or without trackingID
router.get('/:trackingID?', function (req, res) {
  if (req.params.trackingID != null){
    getProductByID(req.params.trackingID)
    .then( response => {
      res.send(response)
    })
    .catch(error => {
      console.log(error)
      res.send("error")
    })
  }else {
    getProducts()
    .then( response => {
      res.send(response)
    })
    .catch(error => {
      console.log(error)
      res.send("error")
    })
  }
})

//POST for new product
router.post('/',upload.array(),function(req,res) {
  res.setTimeout(15000);
  let newBody = {
    "productName": req.body.productName,
    "misc": req.body.misc,
    "trackingID": req.body.trackingID,
    "counterparties": req.body.counterparties.map(it => (it.indexOf("O=") != -1 )?(it.split("O=")[1].split(',')[0]):(it)) //filter out to only send org name
  }
  newProduct(newBody)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

//PUT for changing custodian
router.put('/:trackingID/custodian', function(req,res) {
  res.setTimeout(15000);
  receiveProduct(req.params.trackingID)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

module.exports = router
