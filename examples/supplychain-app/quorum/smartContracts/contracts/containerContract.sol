pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ProductContract.sol";

contract containerContract is ProductContract{

    address containerManufacturer; // stores the account address of the where this contract is deployed on in a variable called manufacturer.

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

    Container[] public containers;
    mapping(string => Container) supplyChainMap;

    event containerAdded (string ID);
    event sendArray (Container[] array);
    event sendObject(Container container);

    constructor() public{
        containerManufacturer = msg.sender;
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

        containers.push(Container(_health, _misc, _custodian, _lastScannedAt, _trackingID, _timestamp, _containerID, _counterparties));
        supplyChainMap[_trackingID] = Container(_health, _misc, _custodian, _lastScannedAt,
            _trackingID, _timestamp, _containerID, _counterparties);
        count++;

        emit containerAdded(_trackingID);
        emit sendObject(containers[containers.length-1]);
    }

    // the getAllContainers() function will return all containers in the containerSupplyChain[] array
    function getAllContainers() public returns(Container[] memory) {
        emit sendArray(containers);
        return containers;
    }

    function getSingleContainer(string memory _trackingID) public returns(Container memory) {
        emit sendObject(supplyChainMap[_trackingID]);
    }

    function packageTrackable(string memory _trackableTrackingID, string memory _containerTrackingID) public returns(string memory) {
        // container exists
        // trackable exists
        // custodian of container is our identity
        // custodian of trackable is our identity
        // container's containerID is empty ""
        // trackable's containerID is empty ""
        // packaged trackable custodian is updated
        if(supplyChainMap[_trackableTrackingID].trackingID > 0 && supplyChainMap(_containerTrackingID).trackingID > 0) {
            
        }

    }

}