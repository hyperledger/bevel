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
        if(Object.keys(response.events).length !== 0 && response.events.sendObject) {
          var container = response.events.sendObject.returnValues[0];
          //response.events.sendObject.returnValues[0]
        res.send(
          {
            "health": container.health,
            "sold": container.sold,
            "recalled": container.recalled,
            "misc": container.misc,
            "custodian": container.custodian,
            "trackingID": container.trackingID,
            "timestamp": container.timestamp,
            "containerID": container.containerID,
            "contents": container.contents,
            "linearId": {
                "externalId": null,
                "id": "2059484c-0c3b-43a7-9604-4a61d3039639"
            },
             "participants": container.participants
              }
          ); 
        }
        else if(Object.keys(response.events).length !== 0 && response.events.sendString) res.send(response.events.sendString.returnValues[0]);
        else res.send(response);
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
    .getProductsLength()
    .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})
    .then(async response => {
      arrayLength = response;
      for(var i = 0; i < arrayLength; i++){
        var toPush = await productContract.methods
        .getContainerAt(i)
        .call({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})
          var container = {};
          container.health = toPush.health;
          container.sold = toPush.sold;
          container.recalled = toPush.recalled;
          container.misc = JSON.parse(toPush.misc);
          container.custodian = toPush.custodian;
          container.trackingID = toPush.trackingID;
          container.timestamp = toPush.timestamp;
          container.containerID = toPush.containerID;
          container.linearId = {};
          container.linearId.externalId = null;
          container.linearId.id = container.trackingID;
          container.participants = toPush.participants;

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
  if (newContainer.counterparties.includes(fromAddress)) {
    isInArray = true;
  }
  
  var misc = [];
  var keys = Object.keys(newContainer.misc);

  for(var i = 0; i < keys.length; i++){
    misc.push(keys[i]);
    misc.push(newContainer.misc[keys[i]])
  }


  if (isInArray) {
    productContract.methods
      .addContainer(
        "health",
        misc,
        newContainer.trackingID,
        "",
        newContainer.counterparties
      )
      .send({ from: fromAddress, gas: 6721900, gasPrice: "30000000" })
      .on("receipt", function(receipt) {

        if (receipt.status === true) {
          res.send({generatedID: newContainer.trackingID});
        }
        if (receipt.status === false) {
          res.send("Transaction not successful");
        }
      })
      .catch(error => {
        res.send(error.message);
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
  var trackingID = req.params.trackingID;
  console.log(trackingID);
    productContract.methods
      .updateContainerCustodian(trackingID)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then( response => {
        res.send(response)
      })
      .catch(error => {
        console.log(error)
        res.send(error.message)
      })
});

//PUT for removing contents
router.put("/:containerTrackingID/unpackage", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement remove content from container
  var containerTrackingID = req.params.containerTrackingID;
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

// PUT for package trackable
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
