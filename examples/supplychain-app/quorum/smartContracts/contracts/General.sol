pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ContainerContract.sol";

contract General is ContainerContract {
    /**
    * @return whether a tracking ID is owned and if so whether the scanning user is the owner
    */
    function scan(string memory _trackingID) public view returns(string memory) {
        if((containerSupplyChain[_trackingID].custodian == msg.sender) || productSupplyChain[_trackingID].custodian == msg.sender) {
            return("{'status': 'owned'}");
        }
        if((containerSupplyChain[_trackingID].custodian == address(0)) || productSupplyChain[_trackingID].custodian == address(0)) {
            return("{'status': 'new'}");
        }
        else {
            return("{'status': 'unowned'}");
        }
    }

    /**
    * @return a list of objects with the location, timestamp of custodian change, and new custodian
    */
    //TODO implement location history
}