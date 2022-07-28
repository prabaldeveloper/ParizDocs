// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
///@title Manage the events
///@author Prabal Srivastav
///@notice Event owner can start event or can cancel event

contract ManageEvent {

    ///@param eventTokenId event Token Id
    ///@param guestName guest Name 
    ///@param guestAddress guest Address
    event GuestAdded(uint256 indexed eventTokenId,string guestName, address guestAddress);

    ///@param eventTokenId event Token Id
    event EventStarted(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    event CancelEvent(uint256 indexed eventTokenId);

    ///@notice Add the event guests
    ///@param eventTokenId event Token Id
    ///@param startTime Agenda startTime
    ///@param endTime Agenda endTime
    ///@param agenda agenda of the event
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    
    function addAgenda(uint256 eventTokenId, uint256 startTime, uint256 endTime,string memory agenda, string[] memory guestName, address[] memory guestAddress) public{
        
    }


    ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEvent(uint256 eventTokenId) public {

    }

     ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEvent(uint256 eventTokenId) public {

    }

}
