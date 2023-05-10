
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEventCall {
    function completeInternal(uint256 eventTokenId) external;
    function startEventInternal(uint256 eventTokenId) external;
    function endInternal(uint256 eventTokenId) external;
    function cancelEventInternal(uint256 eventTokenId) external;
    function joinInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 joinTime) external view returns(address);
    function userExitEventInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 exitTime) external view returns(address);
    function updateEventInternal(uint256 eventTokenId) external view returns(uint256) ;
    function isEventEnded(uint256 eventId) external view returns(bool);
    function isEventStarted(uint256 eventId) external view returns (bool);
    function isEventCancelled(uint256 eventId) external view returns (bool);
    

}