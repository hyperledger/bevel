pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ProductContract.sol";

contract ContainerContract is ProductContract {
    /**
    * @dev stores the account address of the where this contract is deployed on in a variable called manufacturer
    */
    //TODO is this used? Delete if replaced by permission.sol/productManufacturer
    address containerManufacturer;

    uint256 public count = 0;

    struct Container {
        string health;
        string misc;
        address custodian; //who currently owns the product
        string lastScannedAt;
        string trackingID;
        uint256 timestamp;
        string containerID;
        string[] participants;
        string[] containerContents;
    }

    string[] public containerKeys;
    Container[] public allContainers;
    mapping(string => Container) containerSupplyChain;

    event containerAdded (string);
    event sendArray (Container[]);
    event sendObject(Container);
    event sendString(string);

    /**
    * @return a new container
    * @dev Only if the caller is the manufacturer. Sold and Recall values are set to false and containerID is "" when a product is newly created.
    */
    function addContainer(
        string memory _health,
        string memory _misc,
        string memory _trackingID,
        string memory _lastScannedAt,
        string[] memory _counterparties
    ) public returns (string memory) {
        require(bytes(containerSupplyChain[_trackingID].trackingID).length <= 0, "HTTP 400: Container with this tracking ID already exists");
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
    function getSingleContainer(string memory _trackingID) public returns (Container memory) {
        if(bytes(containerSupplyChain[_trackingID].trackingID).length > 0) emit sendObject(containerSupplyChain[_trackingID]);
        else emit sendString("No container exists with that tracking ID");
        return containerSupplyChain[_trackingID];
    }

    /**
    * return container with updated custodian
    */
    function updateContainerCustodian(string memory _containerID) public {
        require(bytes(containerSupplyChain[_containerID].trackingID).length > 0, "HTTP 404");
        require(bytes(containerSupplyChain[_containerID].containerID).length <= 0, "HTTP 404");

        containerSupplyChain[_containerID].custodian = msg.sender;
        for (uint256 i = 0; i < containerSupplyChain[_containerID].containerContents.length; i++) {
            if (bytes(productSupplyChain[containerSupplyChain[_containerID].containerContents[i]].trackingID).length > 0) {
                productSupplyChain[containerSupplyChain[_containerID]
                    .containerContents[i]]
                    .custodian = msg.sender;
            } else if (bytes(containerSupplyChain[containerSupplyChain[_containerID].containerContents[i]].trackingID).length > 0) {
                updateContainerCustodian(
                    containerSupplyChain[_containerID].containerContents[i]
                );
            }
        }
        emit sendObject(containerSupplyChain[_containerID]);
    }

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
    * an updated container list with the package removed
    */
    function unpackageTrackable(string memory _containerID, string memory _trackableID) public{
        require(bytes(containerSupplyChain[_containerID].trackingID).length > 0, "HTTP 400: container does not exist");
        require((bytes(productSupplyChain[_trackableID].trackingID).length > 0) ||
                (bytes(containerSupplyChain[_trackableID].trackingID).length > 0), "HTTP 400: trackable does not exist");

        require(containerSupplyChain[_trackableID].custodian == msg.sender, "HTTP 400: container custodian not same as sender address");
        require((productSupplyChain[_trackableID].custodian == msg.sender) ||
                containerSupplyChain[_trackableID].custodian == msg.sender, "HTTP 400: trackable custodian not same as sender address");

        require(bytes(containerSupplyChain[_containerID].containerID).length <= 0, "HTTP 400");
        require(keccak256(bytes(productSupplyChain[_trackableID].containerID)) == keccak256(bytes(_containerID)) ||
                keccak256(bytes(containerSupplyChain[_trackableID].containerID)) == keccak256(bytes(_containerID)), "HTTP 404");

        uint length = containerSupplyChain[_containerID].containerContents.length;//remove product4
        string[] memory newArr = containerSupplyChain[_containerID].containerContents; //[product4, container3]
        delete containerSupplyChain[_containerID].containerContents; //[]

        for(uint i = 0; i < length; i++){
            if(keccak256(bytes(newArr[i])) == keccak256(bytes(_trackableID))){
                if(bytes(containerSupplyChain[_trackableID].trackingID).length > 0) containerSupplyChain[_trackableID].containerID = "";
                else if(bytes(productSupplyChain[_trackableID].trackingID).length > 0) productSupplyChain[_trackableID].containerID = "";
            } else {
                containerSupplyChain[_containerID].containerContents.push(newArr[i]);
            }
        }
    }


}
