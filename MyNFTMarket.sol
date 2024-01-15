// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyToken.sol";

contract KakaMarket {

    struct Listing {
        uint256 tokenID;
        address seller;
        uint256 price;
    }

    IERC721 public nft;
    // IERC20 public erc20Token;
    NewToken public token;

    mapping(uint256 => Listing) public listings;

    constructor(address _nft, address tokenAddress) {
        nft = IERC721(_nft);
        // erc20Token = IERC20(_erc20Token);
        token = NewToken(tokenAddress);
    }

    function listNFT(uint256 tokenID, uint256 price) public {
        require(nft.ownerOf(tokenID) == msg.sender, "Not the token owner");
        nft.transferFrom(msg.sender, address(this), tokenID);
        listings[tokenID] = Listing(tokenID, msg.sender, price);
    }

    function buyNFT(uint256 tokenID, uint256 amount) public {
        Listing memory listing = listings[tokenID];
        require(listing.tokenID == tokenID, "NFT not listed");
        require(amount >= listing.price, "Insufficient amount");
        token.transferFrom(msg.sender, listing.seller, amount);
        nft.transferFrom(address(this), msg.sender, tokenID);
        
        delete listings[tokenID];
    }
}