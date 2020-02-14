pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

contract containerContract {
    Container[] public supplyChain;
    mapping(string => Transaction) public transactionHistory;
    mapping(string => string) public miscellaneous;
    mapping(string => string[]) public counterparties; // counterparties stores the current custodian plus the previous participants

    address manufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.

    uint256 public count = 0;

    struct Container{
        string health;
        string misc;
        string custodian; //who currently owns the product
        string lastScannedAt;
        string trackingID;
        uint timestamp;
        string containerID;
        string[] participants;
    }

    struct Transaction{
        uint256 timestamp;
        string containerID;
    }

    event containerAdded (string ID);
    event sendArray (Container[] array);
    event sendObject(Container container);

    constructor() public{
        manufacturer = msg.sender;
    }


    // The addContainer will create a new container only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addContainer(string memory _health, string memory _misc, string memory _trackingID,
        string memory _lastScannedAt, string[] memory _counterparties) public returns (string memory) {
        // require(
        //     counterparties.includes(keccak256(abi.encodePacked((msg.sender)))),
        //     "HTTP 404"
        // );

        uint256 _timestamp = block.timestamp;
        // string memory _custodian = keccak256(abi.encodePacked((msg.sender)));
        string memory _custodian = "manug";
        string memory _containerID = "";

        transactionHistory[_trackingID] = (Transaction(_timestamp, _containerID)); // uses trackingID to get the timestamp and containerID.

        supplyChain.push(Container(_health, _misc, _custodian, _lastScannedAt, _trackingID, _timestamp, _containerID, _counterparties));
        count++;
        miscellaneous[_trackingID] = _misc; // use trackingID as the key to view string value.

        // counterparties(_trackingID, _custodian);//calls an internal function and appends the custodian to the product using the trackingID

        emit containerAdded(_trackingID);
        emit sendObject(supplyChain[supplyChain.length-1]);
    }

}