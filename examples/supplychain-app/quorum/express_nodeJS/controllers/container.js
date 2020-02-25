var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

//GET container with or without trackingID
router.get("/:trackingID?", function(req, res) {
  // GET for get single container 
  if (req.params.trackingID != null) {
    // TODO: Implement getContainerByID functionality
    const trackingID = req.params.trackingID;
    console.log(trackingID, "***");
    productContract.methods
      .getSingleContainer(req.params.trackingID)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then(response => {
        res.send(response);
      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  } else {

    // GET for get all containers
    productContract.methods
    .getAllContainers()
    .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})
    .then(response => {
      console.log(response);
      res.send(response);
    })
    .catch(err => {
      console.log(err);
      res.send(err);
    });
  }
});

//POST for new container
router.post("/", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement new container functionality
  let newContainer = {
    misc: req.body.misc,
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties.map(it =>
      it.indexOf("O=") != -1 ? it.split("O=")[1].split(",")[0] : it
    ) //filter out to only send org name
  }; //filter out to only send org
  var isInArray = false;
  console.log(newContainer.counterparties)
  if (newContainer.counterparties.includes(fromAddress)) {
    isInArray = true;
  }
  if (isInArray) {
    productContract.methods
      .addContainer(
        "health",
        JSON.stringify(newContainer.misc),
        newContainer.trackingID,
        "",
        newContainer.counterparties
      )
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .on("receipt", function(receipt) {
        if (receipt.status === true) {
            res.send(receipt.events.sendObject.returnValues[0]);

        }
        if (receipt.status === false) {
          res.send("Transaction not successful");
        }
      })
      .catch(error => {
        res.send("error");
        console.log(error);
      });
  } else {
    res.send(
      "Transaction not sent. Your address is not in counterparties list"
    );
  }
});

//PUT for changing custodian
router.put("/:trackingID/custodian", function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement change custodian functionality
  // receiveContainer(req.params.trackingID)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
});

//PUT for removing contents
router.put("/:containerTrackingID/unpackage", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement remove content from container
  var containerTrackingID = req.params.trackingID;
  var trackableID = req.body.contents;
  console.log(containerTrackingID);
  productContract.methods
  .unpackageTrackable(containerTrackingID, trackableID)
  .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
  .then( response => {
  res.send(response)
  })
  .catch(error => {
  console.log(error)
  res.send(error.message)
  })
 });

  //PUT for package trackable
  router.put("/:trackingID/package", function(req, res){
    console.log("send");
    
     let trackable = {
       containerID: req.params.trackingID,
       trackingID: req.body.trackingID
     };
     productContract.methods
     .packageTrackable(
       trackable.trackingID,
       trackable.containerID
     )
    .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
    .on("receipt", function(receipt) {
    console.log("send");
    // receipt example
    console.log(receipt);
    if (receipt.status === true) {
    res.send("Transaction successful");
    }
    if (receipt.status === false) {
    res.send("Transaction not successful");
    }
    })
    .on("error", function(error, receipt) {
    res.send("Error! "+ JSON.stringify(error, null, 4));
    console.log("error" + JSON.stringify(error, null, 4));
    console.log(error);
    });
   });

module.exports = router;
