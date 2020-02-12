pragma solidity 0.6.1;

contract productContract {
    string public productName;
    string public health;
    bool sold;
    bool recalled;
    //misc
    string public custodian;
    string public lastScannedAt;
    string public trackingID;
    int64 timestamp;
    string containerID;
    string[] participants;


    function setProductName(string memory name) public { //create a product
        productName = name;
    }
    function setHealth(string memory status) public {
        health = status;
    }
    function setTrackingID(string memory ID) public {
        trackingID = ID;
    }
    function setLastScannedAt(string memory location) public {
        lastScannedAt = location;
    }
    
   // function setCustodian(string memory owner) public {
   //     custodian = owner;
  //  }

  //  function createProduct(custodian, productName) public {

  //      if (custodian == "manufacturer") {
  //          setProductName(productName);
 //       }
  //  }

}