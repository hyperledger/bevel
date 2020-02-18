pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract ProductContract is Ownable {

    // Keeps the manufacturer address as some actions can only be done by the manufacturer
    address productManufacturer;

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
        string[] participants;
    }

    // supplyChain is a mapping of all the products created. The key begins at 1.
    Product[] public products;

    mapping (string => uint) trackingIDtoProductID;

    mapping(string => string) public miscellaneous;
    // counterparties stores the current custodian plus the previous participants
    mapping(string => address[]) public counterparties;

    // FIXME: move into a new contract called permissions
    // only manufacturer Modifier checks that only the manufacturer can perform the task
    modifier onlyManufacturer() {
        require(msg.sender == productManufacturer, "This function can only be executed by the manufacturer");
        _;
    }

    event productAdded (string ID);
    event sendProductArray (Product[] array);
    event sendProduct(Product product);

    // FIXME: This should be the owner, there should be a way to have the manufacturer added and an array of manufacturers
    constructor() public{
        productManufacturer = msg.sender;
    }

    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addProduct(string memory _productName,
        string memory _health,
        //FIXME: Update to an array of key --> value pairs
        string memory _misc,
        string memory _trackingID,
        string memory _lastScannedAt
        //FIXME: Add counterparties
        ) public returns (Product memory) {

        uint256 _timestamp = now;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        address custodian = msg.sender;
        string[] memory participants;
        // participants[1] = "Test";

         // uses trackingID to get the timestamp and containerID.
        Product memory newProduct = Product(_trackingID,
            _productName,
            _health,
            _sold,
            _recalled,
            custodian,
            _timestamp,
            _lastScannedAt,
            containerID,
            participants);
        products.push(newProduct);
        uint productID = products.length - 1;
        trackingIDtoProductID[_trackingID] = productID;
        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(_trackingID,custodian);
        emit productAdded(_trackingID);
        emit sendProduct(newProduct);
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(string memory _trackingID, address _custodian) internal{
        counterparties[_trackingID].push(_custodian);
    }

    function getAllProducts() public returns(Product[] memory) {
        emit sendProductArray(products);
        return products;
    }

    // function packageTrackable(string memory _trackingID, string memory _containerID) public returns(...) {

    // }


}