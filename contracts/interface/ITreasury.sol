// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Price conversion contract
 */

interface ITreasury {
    function claimFunds(address to, address tokenAddress, uint256 amount) external ;
}