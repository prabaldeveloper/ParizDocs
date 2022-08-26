// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Ticket.sol";

contract TicketMaster {

    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    function deploy(uint eventId, string memory name, uint256[2] memory time, uint totalSupply) external returns(address ticketNFTContract) {
        // create ticket NFT contract
        bytes memory bytecode = type(Ticket).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, eventId));
        assembly {
            ticketNFTContract := create2(
                0,
                add(bytecode, 32),
                mload(bytecode),
                salt
            )
        }
        ticketNFTAddress[eventId] = ticketNFTContract;
        Ticket(ticketNFTContract).initialize(
            name,
            "EventTicket",
            totalSupply
        );
    }
}