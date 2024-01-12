// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBigBank {
    function withdraw() external payable;
}

// Withdraw funds
contract Ownable {
    
    IBigBank public bigBankInstance;

    function withdrawFromBigBank(address _bigBankAddress) public payable {
        IBigBank(_bigBankAddress).withdraw();
    }

    receive() external payable { }

}

// Handle deposits
contract BigBank {
    address public owner;
    mapping(address => uint) public balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the Ownable contract");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    modifier minDeposit {
        require (msg.value > 0.001 ether, "Deposit must be greater than 0.001 ether");
        _;
    }

    receive() external payable {
        deposit();
    }

    // Records the deposit amounts for each address
    function deposit() public payable minDeposit{
        balances[msg.sender] += msg.value;
    }

    // Allows only the owner to withdraw all deposits from the contract
    function withdraw() external payable onlyOwner{
        uint amount = address(this).balance;
        (bool success,) = payable(owner).call{value: amount }("");
        if (!success){
            revert();
        }
    }

    // Check the balance of a specific address
    function getBalance(address user) public view returns (uint) {
        return balances[user];
    }
}