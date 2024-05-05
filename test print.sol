// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ExampleContract {
    // Define an event
    event LogMessage(string str,uint intgr, bytes32 bte,bytes32 bte2);

    // Constructor
    constructor() {
        // Emit a message indicating the contract deployment
        (uint value, bytes32 secret) = (3, bytes32(uint(0)));
        emit LogMessage("test",value,secret,keccak256(abi.encodePacked(value, secret)));
    }
}
