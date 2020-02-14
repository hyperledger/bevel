/**
This file is the smart contract for container 
 */

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

contract containerContract {
    Container[] public containerSupplyChain;
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

    function _addressToString(address x) private returns (string memory){
    bytes memory b = new bytes(20);
    for (uint i = 0; i < 20; i++)
        b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
    return string(b);
}


    // The addContainer will create a new container only if they are the manufacturer.  Sold and Recall values are set to false and containerID is "" when a product is newly created.
    function addContainer(string memory _health, string memory _misc, string memory _trackingID,
        string memory _lastScannedAt, string[] memory _counterparties) public returns (string memory) {

        uint256 _timestamp = block.timestamp;
        string memory _custodian = _addressToString(msg.sender);
        string memory _containerID = "";

        transactionHistory[_trackingID] = (Transaction(_timestamp, _containerID));

        containerSupplyChain.push(Container(_health, _misc, _custodian, _lastScannedAt, _trackingID, _timestamp, _containerID, _counterparties));
        count++;
        miscellaneous[_trackingID] = _misc;

        emit containerAdded(_trackingID);
        emit sendObject(containerSupplyChain[containerSupplyChain.length-1]);
    }

    // the getAllContainers() function will return all containers in the containerSupplyChain[] array
    function getAllContainers() public returns(Container[] memory) {
        emit sendArray(containerSupplyChain);
        return containerSupplyChain;
    }

}