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

    event sendString(string);
    event sendArray(Container[]);
    event sendObject(Container);

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
        uint256 _timestamp = block.timestamp;
        address _custodian = msg.sender;
        string memory _containerID = "";
        string[] memory _containerContents;

        containerKeys.push(_trackingID);
        containerSupplyChain[_trackingID] = Container(
            _health,
            _misc,
            _custodian,
            _lastScannedAt,
            _trackingID,
            _timestamp,
            _containerID,
            _counterparties,
            _containerContents
        );

        emit sendString(_trackingID);
        emit sendObject(containerSupplyChain[_trackingID]);
    }

    /**
    * @return all containers in the containerSupplyChain[] array
    */
    function getAllContainers() public returns (Container[] memory) {
        delete allContainers;
        for (uint256 i = 0; i < containerKeys.length; i++) {
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
    */
    function updateContainerCustodian(string memory _containerID) public {
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
    //TODO implement package

    /**
    * @return an updated container list with the package removed
    */
    //TODO implement unpackage

}
