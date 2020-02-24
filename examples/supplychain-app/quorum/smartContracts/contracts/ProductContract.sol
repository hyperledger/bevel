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
        //participants array stores potential custodian addresses
        address[] participants;
    }

    /**
    * @dev array of all the products created, the key begins at 0
    */
    Product[] public allProducts;
     /**
    * @dev array of all containerless products
    */
    Product[] public containerlessProducts;
    /**
    * @dev counterparties stores the current custodian plus the previous participants
    */
    mapping(uint => address[]) public counterparties;
    /**
    * @dev miscellaneous uses the trackingID as a key to view messages
    */
    mapping(string => string) public miscellaneous;
    mapping (string => uint) trackingIDtoProductID;
    mapping (uint => string) public productIDtoTrackingID;

    modifier onlyCustodian(uint _productID) {
        require(allProducts[_productID].custodian == msg.sender,"This action must be performed by the current custodian");
        _;
      }

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
        ) public onlyManufacturer() returns (Product memory) {

        uint256 _timestamp = block.timestamp;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        address custodian = msg.sender;
        address[] memory counterparties;

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
    function addCounterParties(uint _productID, address _custodian) internal{
        counterparties[_productID].push(_custodian);
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
    * @dev You must be the current custodian to call this function
    */
    function updateCustodian(uint _productID,
                            address _newCustodian,
                            string memory _longLatsCoordinates )
                            public onlyCustodian(_productID) returns(bool){
        uint participantsCount = allProducts[_productID].participants.length;
        for(uint i = 0; i == participantsCount; i ++){
            if(_newCustodian == allProducts[_productID].participants[i]){
                allProducts[_productID].timestamp = now;
                allProducts[_productID].lastScannedAt = _longLatsCoordinates;
                allProducts[_productID].custodian = _newCustodian;
                //the new custodian gets added to the counterparties map.
                addCounterParties(_productID, _newCustodian);
                return true;// incase another smart contract is calling this function
            }
        } revert("The new custodian is not a participant");
    }
    /**
    * @ return one product using the product ID
    */
    function getProduct(uint _productID) public view returns (Product memory){
        return allProducts[_productID];
    }

    /**
    * @ return all containerless products
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