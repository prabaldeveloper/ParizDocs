// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEvents {
    function _exists(uint256 eventTokenId) external view returns(bool);
    function getEventDetails(uint256 tokenId) external view returns(uint256, uint256, address payable, bool, uint256, uint256);
    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId) external view returns (bool);
}
