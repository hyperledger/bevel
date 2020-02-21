var express = require('express')
  , router = express.Router()

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
  // TODO: Implement scan function
  // scan(req.params.trackingID)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
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
