pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

contract productContract {
    
    
    mapping(uint => Product) public supplyChain; // supplyChain is a mapping of all the products created. The key begins at 1.
    mapping(string => Transaction) public transactionHistory;
    mapping(string => string) public miscellaneous;
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    Product[] public allProds;

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.
    
    modifier onlyManufacturer() {  // only manufacturer can call the addProduct function. 
        require(msg.sender == manufacturer);
        _;
    }

    uint256 public count = 0;


    struct Container{
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

    event containerAdded (string ID);
    event sendArray (Product[] array);

    constructor() public{
        manufacturer = msg.sender;
    }

    // The addContainer will create a new container only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addContainer(string memory _health, string memory _misc, string memory _trackingID, string memory _lastScannedAt, string[] counterparties) public returns(string memory) {
        require(
            counterparties.includes(keccak256(abi.encodePacked((msg.sender)))),
            return "HTTP 404"
        );

        uint256 _timestamp = block.timestamp;
        string _custodian = keccak256(abi.encodePacked((msg.sender))); 
        string _containerID = "";

        transactionHistory[_trackingID] = (Transaction(_timestamp, _containerID)); // uses trackingID to get the timestamp and containerID.
        
        supplyChain.push(Product(_productName,_health,_sold,_recalled,_custodian,_trackingID,_lastScannedAt));
        
        miscellaneous[_trackingID] = _misc; // use trackingID as the key to view string value. 
        
        addCounterParties(_trackingID,_custodian); //calls an internal function and appends the custodian to the product using the trackingID 
        count += 1;

        emit containerAdded(_trackingID);
        emit sendObject(allProds[allProds.length-1]);
    }

}