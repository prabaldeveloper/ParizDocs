// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./access/Ownable.sol";
import "./interface/IEvents.sol";

///@title Manage the events
///@author Prabal Srivastav
///@notice Event owner can start event or can cancel event

contract ManageEvent is Ownable {

    using AddressUpgradeable for address;

    //Details of the agenda
    struct agendaDetails {
        uint256 agendaId;
        uint256 agendaStartTime;
        uint256 agendaEndTime;
        string agendaType;
        string[] guestName;
        string[] guestAddress;
        uint8 initiateStatus;
    }

    //mapping for getting agenda details
    mapping(uint256 => agendaDetails[]) public getAgendaInfo;

    //mapping for getting number of agendas
    mapping(uint256 => uint256) public noOfAgendas;

    // //mapping for event start status
    // mapping(uint256 => bool) public eventStartedStatus;

    // //mapping for event cancel status
    // mapping(uint256 => bool) public eventCanceledStatus;

    mapping(uint256 => uint256[]) public agendaInEvents;

    //Event contract address
    address private eventContract;

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    ///@param agendaStartTime agendaStartTime
    ///@param agendaEndTime agendaEndTime
    ///@param agenda agenda
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    event AgendaAdded(uint256 indexed eventTokenId,uint256 agendaId, uint256 agendaStartTime, uint256 agendaEndTime, string agenda, string[] guestName, string[] guestAddress, uint8 initiateStatus);

    // ///@param eventTokenId event Token Id
    // ///@param payNow pay venue fees now if(didn't pay earlier)
    // event EventStarted(uint256 indexed eventTokenId, bool payNow);

    // ///@param eventTokenId event Token Id
    // event EventCanceled(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    event AgendaStarted(uint256 indexed eventTokenId, uint256 agendaId);

    ///@param eventContract eventContractAddress
    event EventContractUpdated(address eventContract);

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    event AgendaDeleted(uint256 indexed eventTokenId, uint256 indexed agendaId);

    //modifier for checking valid time
    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "invalid time input"
        );
        _;
    }

    // modifier for checking event organiser address
    modifier isEventOrganiser(uint256 eventTokenId) {
        (, ,
        address eventOrganiser,
        , ,
        ) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser ,"ManageEvent: Invalid Address");
        _;
    }

     function initialize() public initializer {
        Ownable.ownable_init();
    }

    ///@notice updates eventContract address
    ///@param _eventContract eventContract address
    function updateEventContract(address _eventContract) external onlyOwner {
        require(_eventContract.isContract(),"ManageEvent: Address is not a contract");
        eventContract = _eventContract;
        emit EventContractUpdated(_eventContract);
    }

    ///@notice Add the event guests
    ///@param eventTokenId event Token Id
    ///@param agendaStartTime agendaStartTime
    ///@param agendaEndTime agendaEndTime
    ///@param agendaType agendaType of the event
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    function addAgenda(uint256 eventTokenId, uint256 agendaStartTime, uint256 agendaEndTime, string memory agendaType, string[] memory guestName, string[] memory guestAddress, uint8 initiateStatus) 
    isValidTime(agendaStartTime, agendaEndTime) 
    isEventOrganiser(eventTokenId) external {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 eventStartTime,
        uint256 eventEndTime,
        , , ,) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(agendaStartTime >= eventStartTime && agendaEndTime <= eventEndTime, "ManageEvent: Invalid agenda time" );
        require(guestName.length == guestAddress.length, "ManageEvent: Invalid input");
        uint256 agendaId = noOfAgendas[eventTokenId];
        noOfAgendas[eventTokenId]++;
        require(isAgendaTimeAvailable(eventTokenId, agendaId, agendaStartTime, agendaEndTime),"ManageEvent: Agenda Time not available");
        getAgendaInfo[eventTokenId].push(agendaDetails(agendaId,
            agendaStartTime,
            agendaEndTime,
            agendaType,
            guestName,
            guestAddress,
            initiateStatus
        ));
        emit AgendaAdded(eventTokenId, agendaId, agendaStartTime, agendaEndTime, agendaType, guestName, guestAddress, initiateStatus);
    }

    function deleteAgenda(uint256 eventTokenId, uint256 agendaId) isEventOrganiser(eventTokenId) external  {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        require(block.timestamp < getAgendaInfo[eventTokenId][agendaId].agendaStartTime, "ManageEvent: Agenda already started");
        delete getAgendaInfo[eventTokenId][agendaId];
        emit AgendaDeleted(eventTokenId, agendaId);
    }


    ///@notice To initiate a session(1 - autoInitiate, 2 - Manual Initiate)
    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    function initiateSession(uint256 eventTokenId, uint256 agendaId) isEventOrganiser(eventTokenId) external {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        require(getAgendaInfo[eventTokenId][agendaId].initiateStatus == 2, "ManageEvent: Auto Session");
        //Add endTime condition check
        require(block.timestamp >= getAgendaInfo[eventTokenId][agendaId].agendaStartTime, "ManageEvent: Session not started");
        require(block.timestamp < getAgendaInfo[eventTokenId][agendaId].agendaEndTime, "ManageEvent: Session ended");
        emit AgendaStarted(eventTokenId, agendaId);
    }

    ///@notice Returns event contract address
    function getEventContract() public view returns(address){
        return eventContract;
    }

    // function isEventCanceled(uint256 eventId) public view returns(bool) {
    //     return eventCanceledStatus[eventId];
    // }

    // function isEventStarted(uint256 eventId) public view returns(bool) {
    //     return eventStartedStatus[eventId];
    // }

    function isAgendaTimeAvailable(uint256 eventTokenId, uint256 agendaId, uint256 agendaStartTime, uint256 agendaEndTime) internal returns(bool _isAvailable) {
        uint256[] memory bookedAgendas = agendaInEvents[eventTokenId]; 
        uint256 currentTime = block.timestamp;
        for(uint256 i=0; i<bookedAgendas.length; i++) { 
            uint256 bookedStartTime = getAgendaInfo[eventTokenId][bookedAgendas[i]].agendaStartTime;
            uint256 bookedEndTime = getAgendaInfo[eventTokenId][bookedAgendas[i]].agendaEndTime;
            if(currentTime >= bookedEndTime) continue;
            if(currentTime >= bookedStartTime && currentTime <= bookedEndTime) {
                if(agendaStartTime >=bookedEndTime) {
                    continue;
                } else {
                    return false;
                }
            }
            else {
                //check for future event
                if (agendaEndTime <= bookedStartTime || agendaStartTime >= bookedEndTime) {
                    continue;
                } else {
                    return false;
                }
            }
        }
        agendaInEvents[eventTokenId].push(agendaId);
        return true;
    } 
}
//Event organiser first has to start the event then user can join

// manageContract => addAgenda,
// Graph for addAgenda(Done)

// Web3 for addAgenda

// Graph for event Contract buy, join and //favourite

// Web3 for buy, join and favourite

//Query for addAgenda

//Check whether payNow is changing it's value in graph after fees is paid
//To test startEvent function