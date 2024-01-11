// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint private count;

    constructor() {
        count = 0;
    }

    function add(uint x) public {
        count += x;
    }

    function getCount() public view returns (uint) {
        return count;
    }
}
