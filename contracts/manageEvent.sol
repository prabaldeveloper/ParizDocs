// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./access/Ownable.sol";
import "./interface/IEvents.sol";

///@title Manage the events
///@author Prabal Srivastav
///@notice Event owner can start event or can cancel event

contract ManageEvent is Ownable {

    struct agendaDetails {
        uint256 eventTokenId;
        uint256 _agendaStartTime;
        uint256 _agendaEndTime;
        string agenda;
        string[] guestName;
        address[] guestAddress;
    }
    
    address private eventContract;

    mapping(uint256 => agendaDetails[]) public getAgendaInfo;

    mapping(uint256 => bool) public isEventStarted;

    mapping(uint256 => bool) public isEventCanceled;

    ///@param eventTokenId event Token Id
    ///@param guestName guest Name 
    ///@param guestAddress guest Address
    event GuestAdded(uint256 indexed eventTokenId,uint256 agendaStartTime, uint256 agendaEndTime, string agenda, string[] guestName, address[] guestAddress);

    ///@param eventTokenId event Token Id
    event EventStarted(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    event EventCanceled(uint256 indexed eventTokenId);

    event EventContractUpdated(address eventContract);

    ///@notice Add the event guests
    ///@param eventTokenId event Token Id
    ///@param agendaStartTime Agenda startTime
    ///@param agendaEndTime Agenda endTime
    ///@param agenda agenda of the event
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    function addAgenda(uint256 eventTokenId, uint256 agendaStartTime, uint256 agendaEndTime, string memory agenda, string[] memory guestName, address[] memory guestAddress) public{
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 startTime,
        uint256 endTime,
        address eventOrganiser) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser ,"ManageEvent: Invalid Address");
        require(block.timestamp >= startTime && endTime > block.timestamp, "ManageEvent: Event not live");
        getAgendaInfo[eventTokenId].push(agendaDetails(eventTokenId,
            agendaStartTime,
            agendaEndTime,
            agenda,
            guestName,
            guestAddress
        ));
        emit GuestAdded(eventTokenId, agendaStartTime, agendaEndTime, agenda, guestName, guestAddress);
    }

    ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEvent(uint256 eventTokenId) public {
        //Check if fees paid for venue
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 startTime,
        uint256 endTime,
        address eventOrganiser) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser ,"ManageEvent: Invalid Address");
        require(block.timestamp >= startTime && endTime > block.timestamp, "ManageEvent: Event not live");
        require(isEventStarted[eventTokenId] == false, "ManageEvent: Event already started");
        isEventStarted[eventTokenId] = true;
        emit EventStarted(eventTokenId);
    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEvent(uint256 eventTokenId) public {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 startTime,
        ,
        address eventOrganiser) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser ,"ManageEvent: Invalid address");
        require(startTime > block.timestamp, "ManageEvent: Event started");
        require(isEventCanceled[eventTokenId] == false, "ManageEvent: Event already canceled");
        isEventCanceled[eventTokenId] = true;
        emit EventCanceled(eventTokenId);

    }

    function updateEventContractAddress(address _eventContract) public onlyOwner {
        eventContract = _eventContract;
        emit EventContractUpdated(_eventContract);
    }

    function getEventContract() public view returns(address){
        return eventContract;
    }

}
