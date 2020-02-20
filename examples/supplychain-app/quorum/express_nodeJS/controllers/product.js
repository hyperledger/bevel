var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

router.get('/containerless', function (req,res){
  // TODO: Get products not assigned to a container
  // getContainerlessProducts()
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
})

//GET product with or without trackingID
router.get('/:trackingID?', function (req, res) {
  if (req.params.trackingID != null){
    // TODO: Get product by ID
    // getProductByID(req.params.trackingID)
    // .then( response => {
    //   res.send(response)
    // })
    // .catch(error => {
    //   console.log(error)
    //   res.send("error")
    // })
  }else {
    // TODO: Get all products
    productContract.methods
    .getAllProducts()
    .send({ from: fromAddress})
    .then(response => {
    res.send(response.events.sendProductArray.returnValues.array);
    })
    .catch(err => {
    console.log(err);
    })
  }
})

//POST for new product
router.post('/',upload.array(),function(req,res) {
  res.setTimeout(15000);
  // TODO: Create product
  // let newBody = {
  //   "productName": req.body.productName,
  //   "misc": req.body.misc,
  //   "trackingID": req.body.trackingID,
  //   "counterparties": req.body.counterparties.map(it => (it.indexOf("O=") != -1 )?(it.split("O=")[1].split(',')[0]):(it)) //filter out to only send org name
  // }
  // newProduct(newBody)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
  let newProduct = {
    productName: req.body.productName,
    misc: { name: req.body.misc.name },
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties
  };

  productContract.methods
    .addProduct(
      newProduct.productName,
      "health",
      JSON.stringify(newProduct.misc),
      newProduct.trackingID,
      ""
    )
    .send({ from: fromAddress,  gas: 6721975, gasPrice: '30000000' })
    .on("receipt", function(receipt) {
      // receipt example
      console.log(receipt);
      if (receipt.status === true) {
        //FIXME: Write transaction properly
        console.log("Request successful");
        res.send("Transaction successful");
      }
      if (receipt.status === false) {
        console.log("Request error");
        res.send("Transaction not successful");
      }
    })
    .on("error", function(error) {
      res.send("Error! "+ error);
      console.log("error" + JSON.stringify(error, null, 4));
      console.log(error);
    });
})

//PUT for changing custodian
router.put('/:trackingID/custodian', function(req,res) {
  // TODO: Update product custodian
  // res.setTimeout(15000);
  // receiveProduct(req.params.trackingID)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
})

// 	productContract.methods
// 	.packageTrackable(
// 		trackable.trackingID,
// 		trackable.containerID
// 	)
// 	.send({ from: fromAddress })
//     .on("receipt", function(receipt) {
//       // receipt example
//       console.log(receipt);
//       if (receipt.status === true) {
//         res.send("Transaction successful");
//       }
//       if (receipt.status === false) {
//         res.send("Transaction not successful");
//       }
//     })
//     .on("error", function(error, receipt) {
//       res.send("Error! "+ JSON.stringify(error, null, 4));
//       console.log("error" + JSON.stringify(error, null, 4));
//       console.log(error);
//     });
// });

module.exports = router
