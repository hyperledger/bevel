pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./ContainerContract.sol";

contract General is ContainerContract {
    /**
    * @return whether a tracking ID is owned and if so whether the scanning user is the owner
    */
    //TODO implement scan

    /**
    * @return a list of objects with the location, timestamp of custodian change, and new custodian
    */
    //TODO implement location history
}