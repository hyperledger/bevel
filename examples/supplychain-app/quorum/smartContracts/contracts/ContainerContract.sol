pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ProductContract.sol";

contract ContainerContract is ProductContract{
    /**
    * @dev stores the account address of the where this contract is deployed on in a variable called manufacturer
    */
    //TODO is this used? Delete if replaced by permission.sol/productManufacturer
    address containerManufacturer;

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

    Container[] public containerSupplyChain;
    mapping(string => Container) supplyChainMap;

    event containerAdded (string ID);
    event sendArray (Container[] array);
    event sendObject(Container container);

    function _addressToString(address x) private pure returns (string memory){
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
        return string(b);
    }

    /**
    * @return a new container
    * @dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addContainer(string memory _health, string memory _misc, string memory _trackingID,
        string memory _lastScannedAt, string[] memory _counterparties) public returns (string memory) {

        uint256 _timestamp = block.timestamp;
        string memory _custodian = _addressToString(msg.sender);
        string memory _containerID = "";

        containerSupplyChain.push(Container(_health, _misc, _custodian, _lastScannedAt, _trackingID, _timestamp, _containerID, _counterparties));
        supplyChainMap[_trackingID] = Container(_health, _misc, _custodian, _lastScannedAt,
            _trackingID, _timestamp, _containerID, _counterparties);
        count++;

        emit containerAdded(_trackingID);
        emit sendObject(containerSupplyChain[containerSupplyChain.length-1]);
    }

    /**
    * @return all containers in the containerSupplyChain[] array
    */
    function getAllContainers() public returns(Container[] memory) {
        emit sendArray(containerSupplyChain);
        return containerSupplyChain;
    }

    /**
    * @return one container by trackingID
    */
    function getSingleContainer(string memory _trackingID) public returns(Container memory) {
        emit sendObject(supplyChainMap[_trackingID]);
    }

    /**
    * @return container with updated custodian
    */
    //TODO implement update custodian

    /**
    * @return an updated container list with the package added
    */
    //TODO implement package

    /**
    * @return an updated container list with the package removed
    */
    //TODO implement unpackage
}