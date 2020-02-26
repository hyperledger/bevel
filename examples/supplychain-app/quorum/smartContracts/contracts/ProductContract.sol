pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;
import "./Permission.sol";

contract ProductContract is Permission {

    address potentialCustodian;

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
        //participants array stores potential custodian addresses
        address[] participants;
    }

    /**
    *@dev array of all the products created, the key begins at 0
    */
    Product[] public allProducts;
    string[] public productKeys;

    mapping(string => Product) productSupplyChain;
    mapping(string => uint256) public trackingIDtoProductID;
    mapping (uint => string) public productIDtoTrackingID;
    // miscellaneous is a map of messages where tracking ID is the key
    mapping(string => string) public miscellaneous;

    modifier onlyCustodian(uint _productID) {
        require(allProducts[_productID].custodian == msg.sender,"This action must be performed by the current custodian");
        _;
      }

    event productAdded (string ID);
    event sendArray (Product[] array);
    event sendProduct(Product product);
    /**
    *@return a new product
    *@dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addProduct(string memory _trackingID,
        string memory _productName,
        string memory _health,
        //FIXME: Update to an array of key --> value pairs
        string memory _misc,
        string memory _lastScannedAt,
        address[] memory _participants
        ) public onlyOwner() returns (Product memory) {
        require(bytes(productSupplyChain[_trackingID].trackingID).length <= 0, "HTTP 400: product with this tracking ID already exists");
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
        allProducts.push(newProduct);
        productKeys.push(_trackingID);
        productSupplyChain[_trackingID] = newProduct;
        uint productID = allProducts.length - 1;

        trackingIDtoProductID[_trackingID] = productID;
        productIDtoTrackingID[productID] = _trackingID;

        // use trackingID as the key to view string value.
        miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        addCounterParties(productID,custodian);
        emit productAdded(_trackingID);
        emit sendProduct(newProduct);
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    /**
    *@dev updates the custodian of the product using the trackingID
    */
    function addCounterParties(uint _productID, address _custodian) internal{
        allProducts[_productID].participants.push(_custodian);
    }
    /**
    *@return all products
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
    *@dev You must be the current custodian to call this function
    */
    function updateCustodian(uint _productID,
                            address _newCustodian,
                            string memory _longLatsCoordinates )
                            public onlyCustodian(_productID) returns(bool){
        uint participantsCount = allProducts[_productID].participants.length;
        for(uint i = 0; i < participantsCount; i ++){
            if(_newCustodian == allProducts[_productID].participants[i]){
                allProducts[_productID].timestamp = now;
                allProducts[_productID].lastScannedAt = _longLatsCoordinates;
                allProducts[_productID].custodian = _newCustodian;
                return true;// incase another smart contract is calling this function
            }
        } revert("The new custodian is not a participant");
    }
   
   // returns a single product using tracking ID
   /**
    * @return one product
    */
    function getSingleProduct(string memory _trackingID) public returns(Product memory) {
        emit sendProduct(productSupplyChain[_trackingID]);
    }

    /**
    *@dev returns a single product using the product ID
    */
    function getProduct(uint _productID) public view returns (Product memory){
        return allProducts[_productID];
    }

    /**
    * gets all the products from the allProduct array that have empty containerID
    * puts them in a new array called containerlessProducts
    * containerlessProducts stores all products that are containerless and waiting to be packaged
    */
    function getContainerlessProduct () public view returns(Product[5] memory containerlessProducts){
        uint containerlessCounter = 0;
        for(uint i = 0; i < allProducts.length; i ++){
            bytes memory containerIDLength = bytes(allProducts[i].containerID);
            if(containerIDLength.length == 0){
                Product memory containerless = allProducts[i];
                containerlessProducts[containerlessCounter] = containerless;
                containerlessCounter += 1;
            }
        }
        return containerlessProducts;
    }
}