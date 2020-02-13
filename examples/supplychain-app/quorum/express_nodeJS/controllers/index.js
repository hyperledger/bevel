/* this file imports all express.js routes from container and product 
* so all endpoints can run with one command
*/

var express = require('express')
  , router = express.Router()

BASEURL = '/api/v1'

router.use( BASEURL + '/product', require('./product'))

module.exports = router
