pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ContainerContract.sol";

contract General is ContainerContract {

    event sendString(string);


    /**
    * @return whether a tracking ID is owned and if so whether the scanning user is the owner
    */
    function scan(string memory _trackingID) public returns(string memory) {
        if((containerSupplyChain[_trackingID].custodian == msg.sender) || productSupplyChain[_trackingID].custodian == msg.sender) {
            emit sendString("status: owned");
            return("{'status': 'owned'}");
        }
        if((containerSupplyChain[_trackingID].custodian == address(0)) || productSupplyChain[_trackingID].custodian == address(0)) {
            emit sendString("status: new");
            return("{'status': 'new'}");
        }
        else {
            emit sendString("status: unowned");
            return("{'status': 'unowned'}");
        }
    }
    /**
    * @return a list of objects with the location, timestamp of custodian change, and new custodian
    */
    //TODO implement location history
    function getHistoryLength(string memory trackingID) public view returns(uint) {
       uint total = history[trackingID].length;
       return total;

       /* for(uint i =0; i < history[trackingID].length; i++){

        } */
    }
    function getHistory(uint index, string memory _trackingID)public view returns(Transaction memory){
        return(history[_trackingID][index]);
    }
}