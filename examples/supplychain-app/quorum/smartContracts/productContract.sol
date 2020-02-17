pragma solidity 0.6.1; 

contract productContract {
    
    Product[] public supplyChain; //stores all of the products created.
    mapping(string => Transaction) public transactionDetail; // uses the trackingID as the key to view current custodian and their address.
    mapping(string => string) public miscellaneous; // use the trackingID as the key to view miscellaneous messages.
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.
    
    
    modifier onlyManufacturer() {  // only manufacturer can call the addProduct function. 
        require(msg.sender == manufacturer);
        _;
    }

    uint256 public totalProductsCreated = 0;

    struct Product{
        string productName;
        string health;
        bool sold;
        bool recalled;
        string custodian; //who currently owns the product
        string trackingID; 
        string lastScannedAt;
    }
    
    struct Transaction{ //stores current information of the product
        uint256 timestamp;
        string containerID;
        string custodian;
        address custodianAddress;
        string lastScannedAt;

    }

    event productAdded (string ID);

    constructor() public{
        manufacturer = msg.sender;
    }
    
    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is created.
    function addProduct(string memory _productName, string memory _health, string memory _misc, string memory _trackingID, string memory _lastScannedAt) public onlyManufacturer{
        
        uint256 _timestamp = block.timestamp;
        bool _sold = false; 
        bool _recalled = false;
        string memory _containerID = "";
        string memory _custodian = "manufacturer";

        
        transactionDetail[_trackingID] = (Transaction(_timestamp, _containerID, _custodian, manufacturer,_lastScannedAt)); // uses trackingID to get the timestamp, containerID, custodian and custodian_Address.
        
        supplyChain.push(Product(_productName,_health,_sold,_recalled,_custodian,_trackingID,_lastScannedAt)); // pushes the new product to the array 
        
        miscellaneous[_trackingID] = _misc; // use trackingID as the key to view string value. 
        
        addCounterParties(_trackingID,_custodian);//calls an internal function and appends the custodian to the product using the trackingID 
        
        emit productAdded(_trackingID);
        totalProductsCreated += 1;
    }

    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(string memory _trackingID, string memory _custodian) internal{
        counterparties[_trackingID].push(_custodian);
    }
    
    //The updateCustodian method updates custodian when custodianship changes
    function updateCustodian(string memory _trackingID, string memory longLatsCoordinates ) public { 
        if(msg.sender != manufacturer){ // if the account calling this function is not the manufacturer, the following will be performed:
            address _custodianAddress = msg.sender;
            string memory _custodian = 'store';
            uint256 _timestamp = block.timestamp;
            transactionDetail[_trackingID].timestamp = _timestamp; 
            transactionDetail[_trackingID].lastScannedAt = longLatsCoordinates; 
            transactionDetail[_trackingID].custodian = _custodian; 
            transactionDetail[_trackingID].custodianAddress = _custodianAddress;
            addCounterParties(_trackingID,_custodian); //the new custodian gets added to the counterparties map.
        }
    }
}