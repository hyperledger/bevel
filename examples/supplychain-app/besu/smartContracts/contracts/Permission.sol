// Copyright Accenture. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
pragma solidity >0.6.0;

contract Permission {
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