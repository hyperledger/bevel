// Copyright Accenture. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
pragma solidity >0.6.0;
pragma experimental ABIEncoderV2;
import "./Permission.sol";

contract ProductContract is Permission {

    address potentialCustodian;
    uint256 public containerless = 0;

    struct Product {
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
        string[] misc;
        //participants array stores potential custodian addresses
        string[] participants;
    }

    struct Transaction {
        address custodian;
        uint256 timestamp;
        string lastScannedAt;
    }

    /**
    *@dev array of all the products created
    */
    Product[] public allProducts;
    string[] public productKeys;

    mapping(string => Product) productSupplyChain;
    mapping(string => Transaction[]) history;

    event locationEvent(string trackingID, string location);
    event sendTrackingID(string);

    /**
    *@return a new product
    *@dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addProduct(string memory _trackingID,
        string memory _productName,
        string memory _health,
        string[] memory _misc,
        string memory _lastScannedAt,
        string[] memory _participants
        ) public onlyManufacturer() returns (Product memory) {
        require(bytes(productSupplyChain[_trackingID].trackingID).length <= 0, "HTTP 400: product with this tracking ID already exists");
        uint256 _timestamp = block.timestamp;
        bool _sold = false;
        bool _recalled = false;
        string memory containerID = "";
        address _custodian = msg.sender;
        //getContainerless counter
        containerless += 1;

        Product memory newProduct = Product(_trackingID,
            _productName,
            _health,
            _sold,
            _recalled,
            _custodian,
            _timestamp,
            _lastScannedAt,
            containerID,
            _misc,
            _participants);
        allProducts.push(newProduct);
        productKeys.push(_trackingID);
        productSupplyChain[_trackingID] = newProduct;

        Transaction memory newTransaction = Transaction(_custodian,_timestamp, _lastScannedAt);
        history[_trackingID].push(newTransaction);

        emit sendTrackingID(_trackingID);
        return newProduct;
    }
    /**
    *@dev updates the custodian of the product using the trackingID
    */

    function getProductsLength() public view returns (uint) {
        return allProducts.length;
    }

    function getProductAt(uint index) public view returns (Product memory) {
        string memory trackingID = productKeys[index-1];
        return productSupplyChain[trackingID];
    }

function addressToString(address _addr) internal pure returns(string memory) {
    bytes32 value = bytes32(uint256(_addr));
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(42);
    str[0] = '0';
    str[1] = 'x';
    for (uint i = 0; i < 20; i++) {
        str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
        str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
    }
    return string(str);
}

function _toLower(string memory str) internal pure returns (string memory) {
		bytes memory bStr = bytes(str);
		bytes memory bLower = new bytes(bStr.length);
		for (uint i = 0; i < bStr.length; i++) {
			// Uppercase character...
			if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
				// So we add 32 to make it lowercase
				bLower[i] = bytes1(uint8(bStr[i]) + 32);
			} else {
				bLower[i] = bStr[i];
			}
		}
		return string(bLower);
	}


    function updateCustodian(string memory _productID, string memory longLat ) public returns(string memory, string memory){
        require(bytes(productSupplyChain[_productID].trackingID).length > 0, "HTTP 404"); //product exists in supply chain

        address newCustodian;
        string memory ourAddress = addressToString(msg.sender);
        bool isParticipant = false;
        string memory _trackingID;
        string memory lowercaseLongLat = _toLower(longLat);
        bytes memory yourIdentity = abi.encodePacked(ourAddress,",",lowercaseLongLat);

        for(uint i = 0; i < productSupplyChain[_productID].participants.length; i++ ){
            string memory participant = _toLower(productSupplyChain[_productID].participants[i]);
            if(keccak256(yourIdentity) == keccak256(abi.encodePacked((participant))) ) {
                newCustodian = msg.sender;
                _trackingID = productSupplyChain[_productID].trackingID;
                isParticipant = true;
            }
        }
        require(isParticipant, "HTTP 404: your identity is not in participant list");

        uint256 _timestamp = block.timestamp;
        productSupplyChain[_productID].custodian = msg.sender;
        productSupplyChain[_productID].lastScannedAt = longLat;
        history[_trackingID].push(Transaction(newCustodian, _timestamp, longLat));

        emit sendTrackingID(_productID);
    }

   // returns a single product using tracking ID
   /**
    * @return one product
    */
    function getSingleProduct(string memory _trackingID) public view returns(Product memory) {
        require(bytes(productSupplyChain[_trackingID].trackingID).length > 0, "HTTP 400 product does not exist");
        return productSupplyChain[_trackingID];
    }

    /**
    *@dev The containerID gets updated in productSupplyChain when a product gets added to a container.
    *The getContainerlessAt function will get called to iterate though the allProduct array to get the trackingID of each product
    *Then it lookups that product using the productSupplyChain map.
    *It converts the string containerID into bytes and compares it to see if it is empty
    * if it's empty, the product will be returned.
    */
    function getContainerlessAt (uint256 index) public view returns(Product memory){
        string memory containerlessTrackingID;
        containerlessTrackingID = allProducts[index].trackingID;
        bytes memory containerIDLength = bytes(productSupplyChain[containerlessTrackingID].containerID);
        if(containerIDLength.length == 0){
            return productSupplyChain[containerlessTrackingID];
        }
    }
}
