pragma solidity 0.6.1; 

contract productContract {
    
    
    mapping(uint => Product) public supplyChain; // supplyChain is a mapping of all the products created. The key begins at 1.
    mapping(string => Transaction) public transactionHistory;
    mapping(string => string) public miscellaneous;
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.
    
    modifier onlyManufacturer() {  // only manufacturer can call the addProduct function. 
        require(msg.sender == manufacturer);
        _;
    }

    uint256 public count = 0;

    struct Product{
        string productName;
        string health;
        bool sold;
        bool recalled;
        string custodian; //who currently owns the product
        string trackingID;
        string lastScannedAt;
    }
    
    struct Transaction{
        uint256 timestamp;
        string containerID;
            
    }

    event productAdded (string ID);

    constructor() public{
        manufacturer = msg.sender;
    }
    
    // The addProduct will create a new product only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addProduct(string memory _productName, string memory _health, string memory _misc, string memory _trackingID, string memory _lastScannedAt) public onlyManufacturer {
        
        uint256 _timestamp = block.timestamp;
        count += 1;
        bool _sold = false; 
        bool _recalled = false;
        string memory _containerID = "";
        string memory _custodian = "manufacturer";
       
        
        transactionHistory[_trackingID] = (Transaction(_timestamp, _containerID)); // uses trackingID to get the timestamp and containerID.
        
        supplyChain[count] = (Product(_productName,_health,_sold,_recalled,_custodian,_trackingID,_lastScannedAt));
        
        miscellaneous[_trackingID] = _misc; // use trackingID as the key to view string value. 
        
        addCounterParties(_trackingID,_custodian);//calls an internal function and appends the custodian to the product using the trackingID 
        
        emit productAdded(_trackingID);
    }
    
    //addCounterParties is a private method that updates the custodian of the product using the trackingID
    function addCounterParties(string memory _trackingID, string memory _custodian) internal{
        counterparties[_trackingID].push(_custodian);
    }
}