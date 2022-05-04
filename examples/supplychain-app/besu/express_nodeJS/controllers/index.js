/////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright Accenture. All Rights Reserved.                                                  //
//                                                                                             //
//  SPDX-License-Identifier: Apache-2.0                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////

var express = require('express')
  , router = express.Router()

BASEURL = '/api/v1'

router.use( BASEURL, require('./general'))
router.use( BASEURL + '/container', require('./container'))
router.use( BASEURL + '/product', require('./product'))

module.exports = router
