pragma solidity >0.6.0;
pragma experimental ABIEncoderV2;

import "./ContainerContract.sol";

contract General is ContainerContract {

    /**
    * @return whether a tracking ID is owned and if so whether the scanning user is the owner
    */
    function scan(string memory _trackingID) public view returns(string memory){


        // Checking to see if msg.sender is the current custodian
        if((containerSupplyChain[_trackingID].custodian == msg.sender) || productSupplyChain[_trackingID].custodian == msg.sender) {
            return('owned');
        }
        if((containerSupplyChain[_trackingID].custodian != msg.sender && (containerSupplyChain[_trackingID].custodian != address(0)) ||
            productSupplyChain[_trackingID].custodian != msg.sender && productSupplyChain[_trackingID].custodian != address(0))) {
            return('unowned');
        }
        else if((containerSupplyChain[_trackingID].custodian == address(0)) || productSupplyChain[_trackingID].custodian == address(0)) {
             return('new');
        }
    }
    /**
    * @return a list of objects with the location, timestamp of custodian change, and new custodian
    */
    function getHistoryLength(string memory _trackingID) public view returns(uint) {
        uint total = history[_trackingID].length;
        uint containertotal = containerHistory[_trackingID].length;

        if(total > 0 ){
            return total;
        }
        else if(containertotal > 0 ){
            return containertotal;
        }
    }
    /**
    * @return an array of transactions for that trackingID, regardless if it is a container or product
    */
    function getHistory(uint index, string memory _trackingID)public view returns(Transaction memory){

        if(history[_trackingID].length > 0){
            return(history[_trackingID][index]);
        }
        else if(containerHistory[_trackingID].length > 0){
            return(containerHistory[_trackingID][index]);
        }
    }
}