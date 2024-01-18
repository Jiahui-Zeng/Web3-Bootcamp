// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount) external returns (bool);
}

// Basic implementation of an ERC20 token
contract MyToken is ERC20 {

    constructor() ERC20("kakaToken", "KAKA") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    function transferWithCallback(address recipient, uint256 amount) external returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, recipient, amount);
        if (isContract(recipient)) {
            bool success = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
            require(success, "No tokens received");
        }
        return true;
    }

    function isContract(address _addr) public view returns(bool) {
        uint32 size;
        assembly {size := extcodesize(_addr)} // Return the size of the bytecode
        return (size > 0);
    }
}
