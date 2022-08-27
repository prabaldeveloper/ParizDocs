// SPDX-License-Identifier: UNLICENSED

import "./utils/TicketMetadata.sol";
pragma solidity ^0.8.0;

contract Ticket is TicketMetadata {
    function initialize(string memory name, string memory symbol, uint256 totalSupply) public initializer {
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
        __ERC721_init(name, symbol, totalSupply);

    }

    function mint(string memory _tokenIPFSPath) public {
        _mintInternal(_tokenIPFSPath);
    }
}