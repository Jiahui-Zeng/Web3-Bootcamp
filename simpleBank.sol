// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;
    mapping(address => uint) public balances;

    struct Depositor {
        address addr;
        uint amount;
    }

    Depositor[3] public topDepositors;

    constructor() {
        owner = msg.sender;
    }

    // Allows deposits
    receive() external payable {
        deposit();
    }

    // Records the deposit amounts for each address
    function deposit() public payable{
        require (msg.value > 0, "Deposit must greater than 0");
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Keeps track of the top 3 deposit amounts in an array
    function updateTopDepositors(address depositor, uint amount) internal {
        for (uint i = 0; i < topDepositors.length; i++) {
            if (amount > topDepositors[i].amount) {
                for (uint j = topDepositors.length - 1; j > i; j--) {
                    topDepositors[j] = topDepositors[j - 1];
                }
                topDepositors[i] = Depositor(depositor, amount);
                break;
            }
        }
    }

    // Allows only the contract's owner to withdraw all deposits from the contract
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    // Check the balance of a specific address
    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }
}
