// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Price conversion contract
 */

interface ITicketMaster {
    function deploy(uint eventId, string memory name, uint256[2] memory time, uint totalSupply) external returns(address);
}