pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./Permission.sol";

contract ProductContract is Permission {
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

    /**
    * @return a new product
    * @dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
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

    /**
    * @dev updates the custodian of the product using the trackingID
    */
    function addCounterParties(string memory _trackingID, address _custodian) internal{
        counterparties[_trackingID].push(_custodian);
    }

    /**
    * @return all products
    */
    function getAllProducts() public returns(Product[] memory) {
        emit sendProductArray(products);
        return products;
    }

    //TODO what is this? Remove if unused
    // function packageTrackable(string memory _trackingID, string memory _containerID) public returns(...) {

    // }

    /**
    * @return one product
    */
    //TODO implement get product

    /**
    * @return all containerless products
    */
    //TODO implement get containerless
}
