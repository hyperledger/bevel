pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;
import "./Permission.sol";

contract ProductContract is Permission {
    // Keeps the manufacturer address as some actions can only be done by the manufacturer

    // allProducts is a mapping of all the products created. The key begins at 1.

    mapping(string => Product) productSupplyChain;
    mapping(string => uint256) trackingIDtoProductID;
    mapping(string => string) public miscellaneous;
    // counterparties stores the current custodian plus the previous participants
    mapping(string => address[]) public counterparties;

    struct Product {
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

    event productAdded (string);
    event sendArray (Product[]);
    event sendProduct(Product);


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
    )
        public
        returns (
            //FIXME: Add counterparties
            Product memory
        )
    {
        require(bytes(productSupplyChain[_trackingID].trackingID).length <= 0, "HTTP 400: product with this tracking ID already exists");
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
        productKeys.push(_trackingID);
        productSupplyChain[_trackingID] = newProduct;
        uint productID = allProducts.length - 1;
        trackingIDtoProductID[_trackingID] = productID;
        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(_trackingID, custodian);
        emit productAdded(_trackingID);
        emit sendProduct(newProduct);
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    /**
    * @dev updates the custodian of the product using the trackingID
    */
    function addCounterParties(string memory _trackingID, address _custodian)
        internal
    {
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

   /**
    * @return one product
    */
    function getSingleProduct(string memory _trackingID) public returns(Product memory) {
        emit sendProduct(productSupplyChain[_trackingID]);
    }

    /**
    * @return all containerless products
    */
    //TODO implement get containerless

}
