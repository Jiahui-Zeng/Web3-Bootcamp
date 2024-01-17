// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    constructor() ERC721("kakaToken", "KAKA") Ownable(msg.sender) { 
    }

    function mint(address to) public onlyOwner returns(uint256) {
        tokenIds.increment();
        uint256 newTokenId = tokenIds.current();
        _mint(to, newTokenId);
        return newTokenId;
    }
}