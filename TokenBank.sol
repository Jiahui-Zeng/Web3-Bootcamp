// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MyToken.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// Add callback function

// Handle the deposit of tokens and keep track of each user's balance
contract TokenBank is TokenRecipient, MyToken {

    MyToken public token;
    address public owner;
    mapping(address => uint256) public balances;

    constructor(address tokenAddress) {
        token = MyToken(tokenAddress);
        owner = msg.sender;
    }

    function deposit(uint256 amount) public {
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
    }

    // Allows only the owner to withdraw all tokens
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner, balance), "Transfer failed");
    }

    function getBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function tokensReceived(address sender, uint amount) external returns (bool) {
        require(msg.sender == address(token), "Invalid"); 
        balances[sender] += amount;
        return true;
    }
}
