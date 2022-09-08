// SPDX-License-Identifier: UNLICENSED

import "./utils/TicketMetadata.sol";
pragma solidity ^0.8.0;

contract Ticket is TicketMetadata {
    function init_deploy(string memory _name, string memory _symbol, uint256 _totalSupply, uint256 _eventId, uint256[2] memory _time) public {
        _initializeNFT721Mint();
        Ownable.ownable_init();
        __ERC721_init(_name, _symbol, _totalSupply);
        time = _time;
        eventId = _eventId;
    }

    function mint(address userAddress) public returns(uint256 tokenId) {
       tokenId = _mintInternal(userAddress);
    }

    function updateTicketMasterContract(address _ticketMaster) external onlyOwner {
        masterContract = _ticketMaster;
    }
}