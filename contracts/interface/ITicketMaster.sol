// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Ticket Master contract
 */

interface ITicketMaster {
    function deployTicketNFT(uint eventId, string memory name, uint256[2] memory time, uint totalSupply) external returns(address);
}