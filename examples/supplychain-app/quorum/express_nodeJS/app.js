const express = require('express')
const app = express()
var timeout = require('connect-timeout')
const {port} = require('./config.js')
var cors = require('cors')

//TODO:Fix this as changing the following is dangerous to security
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

//TODO: A safe solution would be as such but I dont know the crt
//require('ssl-root-cas/latest')
//.inject()
//.addFile('path to crt here')

app.use(cors())
app.use(timeout(15000))
app.use(require('./controllers'))

app.listen(port, '0.0.0.0', function()  {console.log(`Example app listening on port ${port}!`)})
