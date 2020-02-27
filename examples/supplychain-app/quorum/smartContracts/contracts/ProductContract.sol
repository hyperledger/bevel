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
        string custodian; // Who currently owns the product
        uint256 timestamp;
        string lastScannedAt;
        string containerID;
        string[] misc; //
        //participants array stores potential custodian addresses
        string[] participants;
    }

    /**
    *@dev array of all the products created, the key begins at 0
    */
    Product[] public allProducts;
    string[] public productKeys;
    
    // mapping(address => mapping(uint256 => Shelf)) bookcase;
    // struct Shelf {
    //   string[] books;
    //   uint shelfId;
    
    mapping(string => string[]) miscellaneous;
    mapping(string => Product) productSupplyChain;
    // mapping(string => uint256) public trackingIDtoProductID;
    // mapping (uint => string) public productIDtoTrackingID;
    // miscellaneous is a map of messages where tracking ID is the key

    event locationEvent(string trackingID, string location);

    /**
    *@return a new product
    *@dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addProduct(string memory _trackingID,
        string memory _productName,
        string memory _health,
        //FIXME: Update to an array of key --> value pairs
        string[] memory _misc,
        string memory _lastScannedAt,
        string[] memory _participants
        ) public onlyManufacturer() returns (Product memory) {
        require(bytes(productSupplyChain[_trackingID].trackingID).length <= 0, "HTTP 400: product with this tracking ID already exists");
        uint256 _timestamp = now;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        string memory custodian = "msg.sender";


        Product memory newProduct = Product(_trackingID,
            _productName,
            _health,
            _sold,
            _recalled,
            custodian,
            _timestamp,
            _lastScannedAt,
            containerID,
            _misc,
            _participants);
        allProducts.push(newProduct);
        productKeys.push(_trackingID);
        productSupplyChain[_trackingID] = newProduct;

        // trackingIDtoProductID[_trackingID] = productID;
        // productIDtoTrackingID[productID] = _trackingID;
        
        // miscellaneous[_trackingID] = _misc;

        // use trackingID as the key to view string value.
        // miscellaneous[_trackingID] = _misc;
        //calls an internal function and appends the custodian to the product using the trackingID
        return newProduct;
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    /**
    *@dev updates the custodian of the product using the trackingID
    */

    function addMisc(string memory _trackingID, string[] memory _misc) internal {
        miscellaneous[_trackingID] = _misc;
    }

    function test(string memory _trackingID, string[] memory _misc,
        string memory _productName,
        string memory _health,
        //FIXME: Update to an array of key --> value pairs
        string memory _lastScannedAt,
        string[] memory _participants) public {

        addMisc(_trackingID, _misc);
        addProduct(_trackingID,
         _productName,
        _health,
        //FIXME: Update to an array of key --> value pairs
        _misc,
        _lastScannedAt,
         _participants);
    }

    function getMisc(string memory _trackingID) public view returns(string[] memory){
        return miscellaneous[_trackingID];

    }

    function getProductsLength() public view returns (uint) {
        return allProducts.length;
    }

    function getProductAt(uint index) public view returns (Product memory) {
        string memory trackingID = productKeys[index-1];
        return productSupplyChain[trackingID];
    }

     /**
    *@dev You must be the current custodian to call this function
    */
    // function updateCustodian(uint _productID,
    //                         string memory _longLatsCoordinates )
    //                         public returns(string memory){
    //     uint participantsCount = allProducts[_productID].participants.length;
    //     for(uint i = 0; i < participantsCount; i ++){
    //         if(msg.sender == allProducts[_productID].participants[i]){
    //             allProducts[_productID].timestamp = now;
    //             allProducts[_productID].lastScannedAt = _longLatsCoordinates;
    //             allProducts[_productID].custodian = msg.sender;
    //             return allProducts[_productID].trackingID;
    //         }
    //     } revert("The new custodian is not a participant");
    // }

   // returns a single product using tracking ID
   /**
    * @return one product
    */
    function getSingleProduct(string memory _trackingID) public view returns(Product memory) {
        require(bytes(productSupplyChain[_trackingID].trackingID).length > 0, "HTTP 400 product does not exist");
        return productSupplyChain[_trackingID];
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
