var express = require('express')
  , router = express.Router()
const {getContainers, getContainerByID, newContainer, receiveContainer, packageGood,unPackageGood} = require('../api')
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

//GET container with or without trackingID
router.get('/:trackingID?', function (req, res) {
  if (req.params.trackingID != null){
    getContainerByID(req.params.trackingID)
    .then( response => {
      var newResponse = response
      var updatedCustodian = response.custodian.split(',')
      updatedCustodian[1] = updatedCustodian[1].replace("user+OU=","")
      newResponse.custodian = updatedCustodian.join(',')
      res.send(newResponse)
    })
    .catch(error => {
      console.log(error)
      res.send("error")
    })
  }else {
    getContainers()
    .then( response => {
      //repackage containers
      var containers = []
      response.map(item => {
        var newResponse = item
        var updatedCustodian = item.custodian.split(',')
        updatedCustodian[1] = updatedCustodian[1].replace("user+OU=","")
        newResponse.custodian = updatedCustodian.join(',')
        containers.push(newResponse)
      })
      res.send(containers)
    })
    .catch(error => {
      console.log(error)
      res.send("error")
    })
  }
})

//POST for new container
router.post('/',upload.array(),function(req,res) {
  res.setTimeout(15000);
  let newBody = {
   "health": " ", //fabric has health field that needs to be filled.. will be fixing to not need it
   "misc": req.body.misc,
   "trackingID": req.body.trackingID,
   "counterparties": req.body.counterparties
  }
  newContainer(newBody)
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
  receiveContainer(req.params.trackingID)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

//PUT for updatating contents
router.put('/:trackingID/package',upload.array(),function(req,res) {
  res.setTimeout(15000);
  packageGood(req.params.trackingID,req.body)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})


//PUT for removing contents
router.put('/:trackingID/unpackage',upload.array(),function(req,res) {
  res.setTimeout(15000);
  unPackageGood(req.params.trackingID,req.body)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})
module.exports = router
