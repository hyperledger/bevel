pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract Permission is Ownable {
    address productManufacturer;

    /**
    * @dev set the manufacturer as the product originator
    */
    constructor() public{
        productManufacturer = msg.sender;
    }

    /**
    * @dev check that only the manufacturer can perform the task
    */
    modifier onlyManufacturer() {
        require(msg.sender == productManufacturer, "This function can only be executed by the manufacturer");
        _;
    }
}