/////////////////////////////////////////////////////////////////////////////////////////////////
//  Copyright Accenture. All Rights Reserved.                                                  //
//                                                                                             //
//  SPDX-License-Identifier: Apache-2.0                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////

var express = require('express')
  , router = express.Router();

const {productContract, fromAddress, fromNodeSubject, protocol, web3} = require('../web3services');
const {productContractAddress, privateKey} = require("../config");
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
          if(protocol==="raft")
            container.timestamp  = (new Date(newContainer.timestamp/1000000)).getTime();
          else
            container.timestamp  = (new Date(newContainer.timestamp*1000)).getTime();     
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
          if(protocol==="raft")
            container.timestamp  = (new Date(toPush.timestamp/1000000)).getTime();
          else
            container.timestamp  = (new Date(toPush.timestamp*1000)).getTime(); 
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
  const myData = productContract.methods.addContainer("health",misc,newContainer.trackingID,newContainer.lastScannedAt,newContainer.counterparties).encodeABI();
  web3.eth.getTransactionCount(fromAddress).then(txCount => {

    const txObject = {
      nonce: web3.utils.toHex(txCount),
      to: productContractAddress,
      value: '0x00',
      gasLimit: web3.utils.toHex(2100000),
      gasPrice: web3.utils.toHex(web3.utils.toWei('0', 'gwei')),
      data: myData  
    }

    web3.eth.accounts.signTransaction(
      txObject,
      privateKey
    ).then(signedTx => {
      web3.eth.sendSignedTransaction(
        signedTx.rawTransaction
      ).then( receipt => {
        res.send({generatedID: newContainer.trackingID});
      })
      .catch(e => {
        res.send("Error while creating container")
        console.error('Error while creating container: ', e);
      });
    })
  })
});

//PUT for updating custodian
router.put("/:trackingID/custodian", function(req, res) {
  // TODO: Implement change custodian functionality
  var trackingID = req.params.trackingID;
  var lastScannedAt = fromNodeSubject;
  console.log(trackingID);

  const myData = productContract.methods.updateContainerCustodian(trackingID, lastScannedAt).encodeABI();
  web3.eth.getTransactionCount(fromAddress).then(txCount => {
    const txObject = {
      nonce: web3.utils.toHex(txCount),
      to: productContractAddress,
      value: '0x00',
      gasLimit: web3.utils.toHex(2100000),
      gasPrice: web3.utils.toHex(web3.utils.toWei('0', 'gwei')),
      data: myData  
    }

    web3.eth.accounts.signTransaction(
      txObject,
      privateKey
    ).then(signedTx => {
      web3.eth.sendSignedTransaction(
        signedTx.rawTransaction
      ).then( receipt => {
        res.send(trackingID);
      })
      .catch(e => {
        res.send("Error while reclaiming the container")
        console.error('Error while reclaiming the container: ', e);
      });
    })
  });
});

//PUT for removing contents
router.put("/:containerTrackingID/unpackage", upload.array(), function(req, res) {
  // TODO: Implement remove content from container
  var containerTrackingID = req.params.containerTrackingID;
  var trackableID = req.body.contents;

  const myData = productContract.methods.unpackageTrackable(containerTrackingID, trackableID).encodeABI();
  web3.eth.getTransactionCount(fromAddress).then(txCount => {
    const txObject = {
      nonce: web3.utils.toHex(txCount),
      to: productContractAddress,
      value: '0x00',
      gasLimit: web3.utils.toHex(2100000),
      gasPrice: web3.utils.toHex(web3.utils.toWei('0', 'gwei')),
      data: myData  
    }

    web3.eth.accounts.signTransaction(
      txObject,
      privateKey
    ).then(signedTx => {
      web3.eth.sendSignedTransaction(
        signedTx.rawTransaction
      ).then( receipt => {
        res.send(containerTrackingID);
      })
      .catch(e => {
        res.send("Error while unpacking item from a container")
        console.error('Error while packing item from a container: ', e);
      });
    })
  });
});

// PUT for package trackable
router.put("/:containerID/package", function(req, res){
	let trackable = {
		containerID: req.params.containerID,
    trackingID: req.body.contents
  };
  console.log(trackable.containerID);
  console.log(trackable.trackingID);

  const myData = productContract.methods.packageTrackable(trackable.trackingID, trackable.containerID).encodeABI();
  web3.eth.getTransactionCount(fromAddress).then(txCount => {
    const txObject = {
      nonce: web3.utils.toHex(txCount),
      to: productContractAddress,
      value: '0x00',
      gasLimit: web3.utils.toHex(2100000),
      gasPrice: web3.utils.toHex(web3.utils.toWei('0', 'gwei')),
      data: myData  
    }

    web3.eth.accounts.signTransaction(
      txObject,
      privateKey
    ).then(signedTx => {
      web3.eth.sendSignedTransaction(
        signedTx.rawTransaction
      ).then( receipt => {
        res.send(trackable.containerID);
      })
      .catch(e => {
        res.send("Error while packing item into a container")
        console.error('Error while packing item into a container: ', e);
      });
    })
  });
});
module.exports = router;
