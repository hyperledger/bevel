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
        address custodian; // Who currently owns the product
        uint256 timestamp;
        string lastScannedAt;
        string containerID;
        string[] participants;
    }

    /**
    * @dev mapping of all the products created, the key begins at 1
    */
    
    Product[] public allProducts;
    string[] public productKeys;

    /**
    * @dev counterparties stores the current custodian plus the previous participants
    */
    mapping(string => Product) productSupplyChain;
    mapping (string => uint) trackingIDtoProductID;
    mapping(string => string) public miscellaneous;
    mapping(string => address[]) public counterparties;

    event productAdded (string ID);
    event sendArray (Product[] array);
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
        allProducts.push(newProduct);
        productSupplyChain[_trackingID] = newProduct;
        uint productID = allProducts.length - 1;
        trackingIDtoProductID[_trackingID] = productID;
        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(_trackingID,custodian);
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
        delete allProducts;
        for(uint i = 0; i < productKeys.length; i++){
            string memory trackingID = productKeys[i];
            allProducts.push(productSupplyChain[trackingID]);
        }
        emit sendArray(allProducts);
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