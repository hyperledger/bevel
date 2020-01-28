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
    res.send(response)
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
    res.send(response)
  })
  .catch(error => {
    console.log(error)
    res.send("error")
  })
})

  module.exports = router
