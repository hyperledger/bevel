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
        string[] misc; //
        //participants array stores potential custodian addresses
        string[] participants;
    }

    event sendTrackingID(string);

    /**
    *@dev array of all the products created, the key begins at 0
    */
    Product[] public allProducts;
    string[] public productKeys;

    mapping(string => Product) productSupplyChain;

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
            _misc,
            _participants);
        allProducts.push(newProduct);
        productKeys.push(_trackingID);
        productSupplyChain[_trackingID] = newProduct;
        emit sendTrackingID(_trackingID);
        return newProduct;
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
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

     /**
    *@dev You must be the current custodian to call this function
    */

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
        require(bytes(productSupplyChain[_productID].containerID).length <= 0, "HTTP 404"); //product containerid is ""

        string memory ourAddress = addressToString(msg.sender);
        bool isParticipant = false;

        for(uint i = 0; i < productSupplyChain[_productID].participants.length; i++ ){
            string memory participant = _toLower(productSupplyChain[_productID].participants[i]);
            if(keccak256(abi.encodePacked((ourAddress))) == keccak256(abi.encodePacked((participant))) ) isParticipant = true;
        }
        require(isParticipant, "HTTP 404: your identity is not in particiapnt list");

        productSupplyChain[_productID].custodian = msg.sender;
        productSupplyChain[_productID].lastScannedAt = longLat;
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
