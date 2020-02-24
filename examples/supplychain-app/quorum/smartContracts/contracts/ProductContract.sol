pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

<<<<<<< HEAD
 

import "./ownable.sol";

 

contract ProductContract is Ownable {

 

    // Keeps the manufacturer address as some actions can only be done by the manufacturer
    address productManufacturer;

 

    // allProducts is a mapping of all the products created. The key begins at 1.
    Product[] public allProducts;
    string[] public productKeys;

 

    mapping(string => Product) productSupplyChain;
    mapping (string => uint) trackingIDtoProductID;
    mapping(string => string) public miscellaneous;
    // counterparties stores the current custodian plus the previous participants
    mapping(string => address[]) public counterparties;

 

    event productAdded (string ID);
    event sendArray (Product[] array);
    event sendProduct(Product product);

 

=======
import "./Permission.sol";

contract ProductContract is Permission {
>>>>>>> d228ea61d78d737b6832165315b441cb071bf4f2
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

<<<<<<< HEAD
 

    // FIXME: This should be the owner, there should be a way to have the manufacturer added and an array of manufacturers
    constructor() public{
        productManufacturer = msg.sender;
    }

 

    // FIXME: move into a new contract called permissions
    // only manufacturer Modifier checks that only the manufacturer can perform the task
    modifier onlyManufacturer() {
        require(msg.sender == productManufacturer, "This function can only be executed by the manufacturer");
        _;
    }
 

    // FIXME: This should be the owner, there should be a way to have the manufacturer added and an array of manufacturers
=======
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

>>>>>>> d228ea61d78d737b6832165315b441cb071bf4f2

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