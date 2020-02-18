var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

//GET container with or without trackingID
router.get("/:trackingID?", function(req, res) {
  if (req.params.trackingID != null) {
    // TODO: Implement getContainerByID functionality
    const trackingID = req.body.trackingID;
    productContract.methods
      .getSingleContainer(req.body.trackingID)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then(response => {
        res.send(response.events.sendObject.returnValues.container);
      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  } else {
    // TODO: Implement get all containers functionality
    // getContainers()
    productContract.methods
    .getAllContainers()
    .send({ from: fromAddress})
    .then(response => {
      console.log(response);
      res.send(response.events.sendArray.returnValues[0]);
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
        console.log(receipt);
        console.log(receipt.events.sendObject.returnValues);
        if (receipt.status === true) {
          res.send("Transaction successful");
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

//PUT for updatating contents
router.put("/:trackingID/package", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement update content packages
  // packageGood(req.params.trackingID,req.body)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
});

//PUT for removing contents
router.put("/:trackingID/unpackage", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement remove content from container
  // unPackageGood(req.params.trackingID,req.body)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
});

// PUT for package trackable
// router.put("/api/v1/container/{containerTrackingID}/package", function(req, res){
// 	let trackable = {
// 		containerID: req.params.("containerID"),
// 		trackingID: req.body.trackingID
// 	};

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
module.exports = router;
