// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Ticket Master contract
 */

interface ITicketMaster {
    function deployTicketNFT(uint eventId, string memory name, uint256[2] memory time, uint totalSupply) external returns(address);
    function getUserTicketDetails(uint256 eventTokenId, uint256 ticketId) external view returns(uint256, address);
    function getTicketNFTAddress(uint256 eventTokenId) external view returns(address);
    function isERC721TokenAddress(address tokenAddress) external view returns(bool);
    function getTicketFeesBalance(uint256 eventTokenId, address tokenAddress) external view returns(uint256);
    function getTicketIds(address tokenAddress) external view returns(uint256[] memory);

}