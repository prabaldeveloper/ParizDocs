// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./access/Ownable.sol";
import "./interface/IEvents.sol";
import "./interface/IVenue.sol";

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
        string agenda;
        string[] guestName;
        address[] guestAddress;
        uint8 initiateStatus;
    }

    //mapping for getting agenda details
    mapping(uint256 => agendaDetails[]) public getAgendaInfo;

    //mapping for getting number of agendas
    mapping(uint256 => uint256) public noOfAgendas;

    //mapping for event start status
    mapping(uint256 => bool) public isEventStarted;

    //mapping for event cancel status
    mapping(uint256 => bool) public isEventCanceled;

    //Event contract address
    address private eventContract;

    //venue contract address
    address private venueContract;

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    ///@param agendaStartTime agendaStartTime
    ///@param agendaEndTime agendaEndTime
    ///@param agenda agenda
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    event GuestAdded(uint256 indexed eventTokenId,uint256 agendaId, uint256 agendaStartTime, uint256 agendaEndTime, string agenda, string[] guestName, address[] guestAddress, uint8 initiateStatus);

    ///@param eventTokenId event Token Id
    ///@param payNow pay venue fees now if(didn't pay earlier)
    event EventStarted(uint256 indexed eventTokenId, bool payNow);

    ///@param eventTokenId event Token Id
    event EventCanceled(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    event AgendaStarted(uint256 indexed eventTokenId, uint256 agendaId);

    ///@param eventContract eventContractAddress
    event EventContractUpdated(address eventContract);

    ///@param venueContract venueContract address
    event VenueContractUpdated(address venueContract);

    //modifier for checking valid time
    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "invalid time input"
        );
        _;
    }

    //modifier for checking event organiser address
    modifier isEventOrganiser(uint256 eventTokenId) {
        (, ,
        address eventOrganiser,
        ,
        ) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser ,"ManageEvent: Invalid Address");
        _;
    }

     function initialize() public initializer {
        Ownable.ownable_init();
    }

    ///@notice updates venueContract address
    ///@param _venueContract venueContract address
    function updateVenueContract(address _venueContract) external onlyOwner {
        require(_venueContract.isContract(), "ManageEvent: Address is not a contract");
        venueContract = _venueContract;
        emit VenueContractUpdated(_venueContract);
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
    ///@param agenda agenda of the event
    ///@param guestName[] guest Name 
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    function addAgenda(uint256 eventTokenId, uint256 agendaStartTime, uint256 agendaEndTime, string memory agenda, string[] memory guestName, address[] memory guestAddress, uint8 initiateStatus) isValidTime(agendaStartTime, agendaEndTime) isEventOrganiser(eventTokenId) external {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 eventStartTime,
        uint256 eventEndTime,
        , ,) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(agendaStartTime >= eventStartTime && agendaEndTime < eventEndTime, "ManageEvent: Invalid agenda time" );
        noOfAgendas[eventTokenId]++;
        uint256 agendaId = noOfAgendas[eventTokenId];
        getAgendaInfo[eventTokenId].push(agendaDetails(agendaId,
            agendaStartTime,
            agendaEndTime,
            agenda,
            guestName,
            guestAddress,
            initiateStatus
        ));
        emit GuestAdded(eventTokenId, agendaId, agendaStartTime, agendaEndTime, agenda, guestName, guestAddress, initiateStatus);
    }

    ///@notice Start the event
    ///@param eventTokenId event Token Id
    ///@param tokenAddress erc20 tokenAddress
    ///@param venueFeeAmount fee of the venue
    function startEvent(uint256 eventTokenId, address tokenAddress, uint256 venueFeeAmount) isEventOrganiser(eventTokenId) external payable{
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 startTime,
        uint256 endTime,
        ,
        bool payNow,
        uint256 venueTokenId) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(block.timestamp >= startTime && endTime > block.timestamp, "ManageEvent: Event not live");
        require(isEventStarted[eventTokenId] == false, "ManageEvent: Event already started");
        if(payNow == false) {
            /*if(tokenAddress!= address(0)) 
                IVenue(getVenueContract()).bookVenue(msg.sender, eventTokenId, venueTokenId, tokenAddress, venueFeeAmount);
            
            else {
             IVenue(getVenueContract()).bookVenue{value: msg.value}(msg.sender, eventTokenId, venueTokenId, tokenAddress, venueFeeAmount);
            }*/
            payNow = true;
        }
        isEventStarted[eventTokenId] = true;
        emit EventStarted(eventTokenId, payNow);
    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEvent(uint256 eventTokenId) isEventOrganiser(eventTokenId) external {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        (uint256 startTime,
        ,
        , ,) = IEvents(getEventContract()).getEventDetails(eventTokenId);
        require(startTime > block.timestamp, "ManageEvent: Event started");
        require(isEventCanceled[eventTokenId] == false, "ManageEvent: Event already canceled");
        //Return amount 
        IEvents(getEventContract()).burn(eventTokenId);
        isEventCanceled[eventTokenId] = true;
        emit EventCanceled(eventTokenId);

    }

    ///@notice To initiate a session
    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    function initiateSession(uint256 eventTokenId, uint256 agendaId) isEventOrganiser(eventTokenId) external {
        require((IEvents(getEventContract())._exists(eventTokenId)), "ManageEvent: TokenId does not exist");
        require(getAgendaInfo[eventTokenId][agendaId - 1].initiateStatus == 2, "ManageEvent: Auto Session");
        require(block.timestamp >= getAgendaInfo[eventTokenId][agendaId - 1].agendaStartTime, "ManageEvent: Invalid Time");
        emit AgendaStarted(eventTokenId, agendaId);
    }

    ///@notice Returns event contract address
    function getEventContract() public view returns(address){
        return eventContract;
    }

    ///@notice Returns venue contract address
    function getVenueContract() public view returns(address) {
        return venueContract;
    }

}

