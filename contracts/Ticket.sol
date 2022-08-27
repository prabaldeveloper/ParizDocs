// SPDX-License-Identifier: UNLICENSED

import "./utils/TicketMetadata.sol";
pragma solidity ^0.8.0;

contract Ticket is TicketMetadata {
    function initialize(string memory name, string memory symbol, uint256 totalSupply) public initializer {
        _initializeNFT721Mint();
        __ERC721_init(name, symbol, totalSupply);

    }

    function mint() public returns(uint256 tokenId) {
       tokenId = _mintInternal();
    }
}