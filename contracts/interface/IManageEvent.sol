
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IManageEvent {
    function isEventEnded(uint256 eventId) external view returns(bool);
    function isEventStarted(uint256 eventId) external view returns (bool);
    function isEventCancelled(uint256 eventId) external view returns (bool);
}
