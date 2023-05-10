// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


contract TicketControllerStorage {
    
    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;
    
    address public adminContract;


    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}