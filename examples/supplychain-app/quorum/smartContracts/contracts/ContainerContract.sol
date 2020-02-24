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
        address custodian; //who currently owns the product
        string lastScannedAt;
        string trackingID;
        uint timestamp;
        string containerID;
        string[] participants;
        string[] containerContents;
    }

    string[] public containerKeys;
    Container[] public allContainers;
    mapping(string => Container) containerSupplyChain;

    event containerAdded (string ID);
    event sendArray (Container[] array);
    event sendObject(Container container);

    /**
    * @return a new container
    * @dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addContainer(string memory _health, string memory _misc, string memory _trackingID,
        string memory _lastScannedAt, string[] memory _counterparties) public returns (string memory) {

        uint256 _timestamp = block.timestamp;
        address _custodian = msg.sender;
        string memory _containerID = "";
        string[] memory _containerContents;

        containerKeys.push(_trackingID);
        containerSupplyChain[_trackingID] = Container(_health, _misc, _custodian, _lastScannedAt,
            _trackingID, _timestamp, _containerID, _counterparties, _containerContents);

        emit containerAdded(_trackingID);
        emit sendObject(containerSupplyChain[_trackingID]);
    }

    /**
    * @return all containers in the containerSupplyChain[] array
    */
    function getAllContainers() public returns(Container[] memory) {
        delete allContainers;
        for(uint i = 0; i < containerKeys.length; i++){
            string memory trackingID = containerKeys[i];
            allContainers.push(containerSupplyChain[trackingID]);
        }
        emit sendArray(allContainers);
    }

    /**
    * @return one container by trackingID
    */
    function getSingleContainer(string memory _trackingID) public returns(Container memory) {
        emit sendObject(containerSupplyChain[_trackingID]);
        return containerSupplyChain[_trackingID];
    }

    /**
    * @return container with updated custodian
    */
    //TODO implement update custodian

    /**
    * @return an updated container list with the package added
    */
    function packageTrackable(string memory _trackableTrackingID, string memory _containerTrackingID) public returns(string memory) {
            if(bytes(containerSupplyChain[_trackableTrackingID].trackingID).length > 0 &&
                bytes(containerSupplyChain[_containerTrackingID].trackingID).length > 0) {
                    if(containerSupplyChain[_trackableTrackingID].custodian == msg.sender &&
                        containerSupplyChain[_containerTrackingID].custodian == msg.sender) {
                            if(bytes(containerSupplyChain[_trackableTrackingID].containerID).length == 0 &&
                                bytes(containerSupplyChain[_containerTrackingID].containerID).length == 0){
                                    containerSupplyChain[_trackableTrackingID].containerID = _containerTrackingID;
                                    containerSupplyChain[_trackableTrackingID].custodian = containerSupplyChain[_containerTrackingID].custodian;
                                    containerSupplyChain[_containerTrackingID].containerContents.push(_trackableTrackingID);
                                    return containerSupplyChain[_containerTrackingID].containerID;
                            }
                    }
            }
            else if(bytes(productSupplyChain[_trackableTrackingID].trackingID).length > 0 &&
                bytes(containerSupplyChain[_containerTrackingID].trackingID).length > 0) {
                    if(productSupplyChain[_trackableTrackingID].custodian == msg.sender &&
                        containerSupplyChain[_containerTrackingID].custodian == msg.sender) {
                            if(bytes(productSupplyChain[_trackableTrackingID].containerID).length == 0 &&
                                bytes(containerSupplyChain[_containerTrackingID].containerID).length == 0){
                                    productSupplyChain[_trackableTrackingID].containerID = _containerTrackingID;
                                    productSupplyChain[_trackableTrackingID].custodian = containerSupplyChain[_containerTrackingID].custodian;
                                    containerSupplyChain[_containerTrackingID].containerContents.push(_trackableTrackingID);
                                    return productSupplyChain[_containerTrackingID].containerID;
                            }
                    }
            }
            else {
                return("HTTP400");
            }
    }

    /**
    * @return an updated container list with the package removed
    */
    //TODO implement unpackage
}
