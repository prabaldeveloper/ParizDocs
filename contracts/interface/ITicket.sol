// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Ticket NFT contract
 */

interface ITicket {
    function ownerOf(uint eventId) external returns(address);
}