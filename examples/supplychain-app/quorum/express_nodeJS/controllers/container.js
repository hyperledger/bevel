var express = require('express')
  , router = express.Router();

const {productContract, fromAddress, fromNodeSubject} = require('../web3services');
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
      .call({ from: fromAddress, gas: 6721975, gasPrice: "0" })
      .then(response => {
          var newContainer = response;
          var container = {};
          container.health = newContainer.health;
          container.sold = newContainer.sold;
          container.recalled = newContainer.recalled;
          container.misc = {};
          console.log(newContainer.misc);
          for(var j = 0; j < newContainer.misc.length; j++){
            var json = JSON.parse(newContainer.misc[j]);
            var key = Object.keys(json);
            console.log(json, key);
            container.misc[key] = json[key];
          }
          container.custodian = newContainer.custodian;
          container.custodian = container.custodian + "," + newContainer.lastScannedAt;
          container.trackingID = newContainer.trackingID;
          container.timestamp  = (new Date(newContainer.timestamp * 1000)).getTime();
          container.containerID = newContainer.containerID;
          container.linearId = {};
          container.linearId.externalId = null;
          container.linearId.id = container.trackingID;
          container.participants = newContainer.participants;
          container.contents = newContainer.containerContents;

        res.send(container
          ); 
        
      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  } else {
    var arrayLength;
    var displayArray = [];
    // GET for get all containers
    productContract.methods
    .getContainersLength()
    .call({ from: fromAddress, gas: 6721975, gasPrice: "0"})
    .then(async response => {
      arrayLength = response;
      for(var i = 1; i <= arrayLength; i++){
        var toPush = await productContract.methods
        .getContainerAt(i)
        .call({ from: fromAddress, gas: 6721975, gasPrice: "0"})
        console.log(toPush);
          var container = {};
          container.health = toPush.health;
          container.sold = toPush.sold;
          container.recalled = toPush.recalled;
          container.misc = {};
          for(var j = 0; j < toPush.misc.length; j++){
            var json = JSON.parse(toPush.misc[j]);
            var key = Object.keys(json);
            container.misc[key] = json[key];
          }

          container.custodian = toPush.custodian;
          container.custodian = container.custodian + "," + toPush.lastScannedAt;
          container.lastScannedAt = toPush.lastScannedAt;
          container.trackingID = toPush.trackingID;
          container.timestamp  = (new Date(toPush.timestamp * 1000)).getTime();
          container.containerID = toPush.containerID;
          container.linearId = {};
          container.linearId.externalId = null;
          container.linearId.id = container.trackingID;
          container.participants = toPush.participants;
          container.contents = toPush.containerContents;


          displayArray.push(container);
      }
      res.send(displayArray);
    })
    .catch(err => {
      console.log(err);
      res.send(err);
    });
  }
});

//POST for new container
router.post("/", upload.array(), function(req, res) {
  // TODO: Implement new container functionality
  let newContainer = {
    misc: req.body.misc,
    trackingID: req.body.trackingID,
    lastScannedAt: fromNodeSubject,
    counterparties: req.body.counterparties
  };
  // Add this.address in the counterparties list
  newContainer.counterparties.push(fromAddress+","+fromNodeSubject);

  
  var misc = [];
  var keys = Object.keys(newContainer.misc);

  for(var i = 0; i < keys.length; i++){
    var x = "{ \""+keys[i] + '\": ' + JSON.stringify(newContainer.misc[keys[i]]) + "}";
    misc.push(x)
  }

  productContract.methods
    .addContainer(
      "health",
      misc,
      newContainer.trackingID,
      newContainer.lastScannedAt,
      newContainer.counterparties,
    )
    .send({ from: fromAddress, gas: 6721900, gasPrice: "0" })
    .on("receipt", function(receipt) {

      if (receipt.status === true) {
        res.send({generatedID: newContainer.trackingID});
      }
    })
    .catch(error => {
      res.send(error.message);
      console.log(error);
    });
  
});

//PUT for updating custodian
router.put("/:trackingID/custodian", function(req, res) {
  // TODO: Implement change custodian functionality
  var trackingID = req.params.trackingID;
  var lastScannedAt = fromNodeSubject;
  console.log(trackingID);
    productContract.methods
      .updateContainerCustodian(trackingID, lastScannedAt)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "0" })
      .then( response => {
        res.send(trackingID)
      })
      .catch(error => {
        console.log(error)
        res.send(error.message)
      })
});

//PUT for removing contents
router.put("/:containerTrackingID/unpackage", upload.array(), function(req, res) {
  // TODO: Implement remove content from container
  var containerTrackingID = req.params.containerTrackingID;
  var trackableID = req.body.contents;
  productContract.methods
    .unpackageTrackable(containerTrackingID, trackableID)
    .send({ from: fromAddress, gas: 6721975, gasPrice: "0" })
      .then( response => {
        res.send(containerTrackingID)
      })
      .catch(error => {
        res.send(error.message)
      })
});

// PUT for package trackable
router.put("/:containerID/package", function(req, res){
	let trackable = {
		containerID: req.params.containerID,
    trackingID: req.body.contents
  };    console.log(trackable.containerID);
  console.log(trackable.trackingID);

	productContract.methods
	.packageTrackable(
		trackable.trackingID,
    trackable.containerID,
	)
  .send({ from: fromAddress, gas: 6721975, gasPrice: "0" })
    .on("receipt", function(receipt) {
      if (receipt.status === true) {
        res.send(trackable.containerID);
        console.log(res.send(trackable.containerID));
      }
    })
    .on("error", function(error, receipt) {
      res.send("Error! "+ JSON.stringify(error, null, 4));
      console.log(error);
    });
});
module.exports = router;
