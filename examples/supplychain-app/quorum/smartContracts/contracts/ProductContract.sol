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
        //participants array stores potential custodian addresses
        address[] participants;
    }
/////////////////////////////////////
    uint participantsCount;
    address potentialCustodian;
////////////////////////////////////

    // products array stores all of the products created.
    Product[] public products;
    //containerlessProducts stores all products that are containerless and waiting to be packaged
    Product[] public containerlessProducts;

    mapping (string => uint) public trackingIDtoProductID;
    mapping (uint => string) public productIDtoTrackingID;

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
    modifier onlyCustodian(uint _productID) {
        require(products[_productID].custodian == msg.sender,"This action must be performed by the current custodian");
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
        address[] memory _participants
        ) public returns (Product memory) {

        uint256 _timestamp = block.timestamp;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        address custodian = msg.sender;

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
        productIDtoTrackingID[productID] = _trackingID;

        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;

        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(productID,custodian);
        emit productAdded(_trackingID);
        emit sendProduct(newProduct);
    }

    function getProduct(uint _productID) public view returns (Product memory){
        return products[_productID];
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(uint _productID, address _custodian) internal{
        counterparties[_productID].push(_custodian);
    }
    function getParticipantCount(uint _productID) internal returns(uint) {
        participantsCount = products[_productID].participants.length;
        return participantsCount;
    }
    function getAllProducts() public returns(Product[] memory) {
        emit sendProductArray(products);
        return products;
    }
    // You must be the current custodian to call this function
    function updateCustodian(uint _productID,
                            address _newCustodian,
                            string memory _longLatsCoordinates )
                            public onlyCustodian(_productID) returns(bool){
        getParticipantCount(_productID);
        for(uint i=0; i == participantsCount; i ++){
            if(_newCustodian == products[_productID].participants[i]){
                products[_productID].timestamp = now;
                products[_productID].lastScannedAt = _longLatsCoordinates;
                products[_productID].custodian = _newCustodian;
                addCounterParties(_productID, _newCustodian); //the new custodian gets added to the counterparties map.
                return true;// incase another smart contract is calling this function
            }
        } revert("The new custodian is not a participant");
    }

    // You must be  the current custodian in order to updateProduct
    function updateProduct(string memory _health,
                            string memory _misc,
                            uint _productID)
                            public onlyCustodian(_productID) returns(bool){
            string memory _trackingID;
            productIDtoTrackingID[_productID] = _trackingID;
            products[_productID].health = _health;
            miscellaneous[_trackingID] = _misc;
            return true;
    }

    //gets all the containerless products from the products array that is waiting to be packaged
    function getContainerlessProduct() public returns(Product memory){
        for(uint i = 0; i == products.length; i ++){
            if(keccak256(abi.encodePacked(products[i].containerID)) == keccak256(abi.encodePacked(""))){
                containerlessProducts.push(products[i]);
            }
        }
    }
}
