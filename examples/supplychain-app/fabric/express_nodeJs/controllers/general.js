var express = require('express')
  , router = express.Router()
const {getSelf, getRole , scan, locationHistory} = require('../api')

router.get('/node-organization', function (req, res) {
  getSelf()
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

router.get('/node-organizationUnit', function (req, res) {
  getRole()
  .then( response => {
    //repackage organizationUnit
    let orgUnit = {"organizationUnit":response.organizationUnit[1]}
    res.send(orgUnit)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

router.get('/:trackingID/scan', function (req, res) {
  scan(req.params.trackingID)
  .then( response => {
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

router.get('/:trackingID/history', function (req, res) {
  locationHistory(req.params.trackingID)
  .then( response => {
    //repackage history
    var history = []
    response.map(item => {
      var updatedCustodian = item.custodian.split(',')
      updatedCustodian[1] = updatedCustodian[1].replace("user+OU=","")
      history.push({ "time":item.timestamp,"party":updatedCustodian.join(',')})
    })
    res.send(history)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

  module.exports = router
