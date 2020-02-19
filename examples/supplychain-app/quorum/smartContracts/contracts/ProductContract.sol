pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract ProductContract is Ownable {

    // Keeps the manufacturer address as some actions can only be done by the manufacturer
    address manufacturer;

    struct Product{
        string trackingID;
        string productName;
        string health;
        bool sold;
        bool recalled;
        // Who currently owns the product
        address custodian;
        uint256 timestamp;
        string lastScannedAt;
        string containerID;
        //participants are potential custodians
        string[] participants;
    }
/////////////////////////////////////
    uint participantsCount;
    address potentialCustodian;
////////////////////////////////////

    // products array stores all of the products created.
    Product[] public products;

    mapping (string => uint) public trackingIDtoProductID;
    //miscellaneous uses the trackingID as a key to view messages
    mapping(string => string) public miscellaneous;
    // counterparties stores a history of the previous custodians plus the current.
    mapping(uint => address[]) public counterparties;

    // FIXME: move into a new contract called permissions
    // only manufacturer Modifier checks that only the manufacturer can perform the task
    modifier onlyManufacturer() {
        require(msg.sender == manufacturer, "This function can only be executed by the manufacturer");
        _;
    }

    event productAdded (string ID);
    event sendProductArray (Product[] array);
    event sendProduct(Product product);

    // FIXME: This should be the owner, there should be a way to have the manufacturer added and an array of manufacturers
    constructor() public{
        manufacturer = msg.sender;
    }

    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addProduct(string memory _productName,
        string memory _health,
        //FIXME: Update to an array of key --> value pairs
        string memory _misc,
        string memory _trackingID,
        string memory _lastScannedAt,
        string[] memory _participants
        ) public onlyManufacturer returns (Product memory) {

        uint256 _timestamp = block.timestamp;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        address custodian = msg.sender;
        _participants[1] = "Test";
        //counterparties = _participants;

        Product memory newProduct = Product(_trackingID,
            _productName,
            _health,
            _sold,
            _recalled,
            custodian,
            _timestamp,
            _lastScannedAt,
            containerID,
            _participants);
        products.push(newProduct);

        uint productID = products.length - 1;
        // uses trackingID to get the productID.
        trackingIDtoProductID[_trackingID] = productID;
        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(productID,custodian);
        emit productAdded(_trackingID);
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(uint _productID, address _custodian) internal{
        counterparties[_productID].push(_custodian);
    }

    function getParticipantCount(uint _productID) public returns(uint) {
        participantsCount = products[_productID].participants.length;
        return participantsCount;
}
 /*
    //The updateCustodian method updates custodian when custodianship changes
    function updateCustodian(uint _productID, string memory longLatsCoordinates ) public {
    // if the account calling this function is not the manufacturer, the following will be performed:
        getParticipantCount(_productID);
        for(uint i=0; participantsCount; i ++){
            potentialCustodian = msg.sender;
          if(potentialCustodian == products[_productID].participants[i]){
            address _custodian = msg.sender;
            uint256 _timestamp = block.timestamp;
            products[_productID].timestamp = _timestamp;
            products[_productID].lastScannedAt = longLatsCoordinates;
            products[_productID].custodian = _custodian;
            addCounterParties(_productID, _custodian); //the new custodian gets added to the counterparties map.
      }  }
    }
/*
    // You must updateCustodian before you could updateProduct
    function updateProduct(string memory _health, string memory _misc, string memory _trackingID, string memory _custodian) public {
        if(transactionDetail[_trackingID].custodianAddress == msg.sender && keccak256(abi.encodePacked((transactionDetail[_trackingID].custodian))) == keccak256(abi.encodePacked((_custodian)))) {


            trackingIDtoProductID[_trackingID] = _productID;
            products[_productID].health = _health;
            miscellaneous[_trackingID] = _misc;
            //supplyChain[_index].health = _health;

        }
    } */
}