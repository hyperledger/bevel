pragma solidity 0.6.1; 

contract productContract {
    
<<<<<<< HEAD
    Product[] public supplyChain; //stores all of the products created.
    mapping(string => Transaction) public transactionDetail; // uses the trackingID as the key to view current custodian and their address.
    mapping(string => string) public miscellaneous; // use the trackingID as the key to view miscellaneous messages.
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.

=======
    
    mapping(uint => Product) public supplyChain; // supplyChain is a mapping of all the products created. The key begins at 1.
    mapping(string => Transaction) public transactionHistory;
    mapping(string => string) public miscellaneous;
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.
    
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
    modifier onlyManufacturer() {  // only manufacturer can call the addProduct function. 
        require(msg.sender == manufacturer);
        _;
    }

<<<<<<< HEAD
    uint256 public totalProductsCreated = 0;
=======
    uint256 public count = 0;
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25

    struct Product{
        string productName;
        string health;
        bool sold;
        bool recalled;
        string custodian; //who currently owns the product
<<<<<<< HEAD
        string trackingID; 
        string lastScannedAt;
    }

    struct Transaction{ //stores current information of the product
        uint256 timestamp;
        string containerID;
        string custodian;
        address custodianAddress;
        string lastScannedAt;

=======
        string trackingID;
        string lastScannedAt;
    }
    
    struct Transaction{
        uint256 timestamp;
        string containerID;
            
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
    }

    event productAdded (string ID);

    constructor() public{
        manufacturer = msg.sender;
    }
<<<<<<< HEAD

    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is created.
    function addProduct(string memory _productName, string memory _health, string memory _misc, string memory _trackingID, string memory _lastScannedAt) public onlyManufacturer{

        uint256 _timestamp = block.timestamp;
=======
    
    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addProduct(string memory _productName, string memory _health, string memory _misc, string memory _trackingID, string memory _lastScannedAt) public onlyManufacturer {
        
        uint256 _timestamp = block.timestamp;
        count += 1;
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
        bool _sold = false; 
        bool _recalled = false;
        string memory _containerID = "";
        string memory _custodian = "manufacturer";
<<<<<<< HEAD

        
        transactionDetail[_trackingID] = (Transaction(_timestamp, _containerID, _custodian, manufacturer,_lastScannedAt)); // uses trackingID to get the timestamp, containerID, custodian and custodian_Address.
        
        supplyChain.push(Product(_productName,_health,_sold,_recalled,_custodian,_trackingID,_lastScannedAt));
=======
       
        
        transactionHistory[_trackingID] = (Transaction(_timestamp, _containerID)); // uses trackingID to get the timestamp and containerID.
        
        supplyChain[count] = (Product(_productName,_health,_sold,_recalled,_custodian,_trackingID,_lastScannedAt));
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
        
        miscellaneous[_trackingID] = _misc; // use trackingID as the key to view string value. 
        
        addCounterParties(_trackingID,_custodian);//calls an internal function and appends the custodian to the product using the trackingID 
        
        emit productAdded(_trackingID);
<<<<<<< HEAD
        totalProductsCreated += 1;
    }

=======
    }
    
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(string memory _trackingID, string memory _custodian) internal{
        counterparties[_trackingID].push(_custodian);
    }
<<<<<<< HEAD

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
=======
>>>>>>> eb6cb2e9f09a359d16277799f6953fdc38e36b25
}