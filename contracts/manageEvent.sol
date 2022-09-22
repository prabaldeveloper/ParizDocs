// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./access/Ownable.sol";
import "./interface/IEvents.sol";
import "./interface/IAdminFunctions.sol";
import "./interface/IVerifySignature.sol";
import "./interface/ITreasury.sol";
import "./interface/ITicket.sol";
import "./interface/ITicketMaster.sol";
import "./utils/ManageEventStorage.sol";

///@notice Event owner can start event or can cancel event

contract ManageEvent is Ownable, ManageEventStorage {
    using AddressUpgradeable for address;

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    ///@param agendaStartTime agendaStartTime
    ///@param agendaEndTime agendaEndTime
    ///@param agendaName agenda
    ///@param guestName[] guest Name
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    event AgendaAdded(
        uint256 indexed eventTokenId,
        uint256 agendaId,
        uint256 agendaStartTime,
        uint256 agendaEndTime,
        string agendaName,
        string[] guestName,
        string[] guestAddress,
        uint8 initiateStatus
    );

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    event AgendaStarted(uint256 indexed eventTokenId, uint256 agendaId);

    event AgendaUpdated(
        uint256 indexed eventTokenId,
        uint256 agendaId,
        uint256 agendaStartTime,
        uint256 agendaEndTime,
        string agenda,
        string[] guestName,
        string[] guestAddress,
        uint8 initiateStatus
    );

    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    event AgendaDeleted(
        uint256 indexed eventTokenId,
        uint256 indexed agendaId,
        bool deletedStatus
    );

    event Exited(
        uint256 indexed tokenId,
        address indexed user,
        uint256 leavingTime
    );

    ///@param eventTokenId event Token Id
    event EventCompleted(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    event EventEnded(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id
    event EventStarted(uint256 indexed eventTokenId);

    ///@param eventTokenId event Token Id   
    event EventCancelled(uint256 indexed eventTokenId);

    event TicketFeesRefund(uint256 indexed eventTokenId, address user, uint256 ticketId);

    event TicketFeesClaimed(uint256 indexed eventTokenId, address eventOrganiser, address[] tokenAddress);

    //modifier for checking valid time
    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "Invalid time input"
        );
        _;
    }

    // modifier for checking event organiser address
    modifier isEventOrganiser(uint256 eventTokenId) {
        (, , address eventOrganiser, , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser, "ManageEvent: Invalid Address");
        _;
    }

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "Events: Address is not a contract"
        );
        adminContract = _adminContract;

    }

    ///@notice Add the event guests
    ///@param eventTokenId event Token Id
    ///@param agendaStartTime agendaStartTime
    ///@param agendaEndTime agendaEndTime
    ///@param agendaName agendaName of the event
    ///@param guestName[] guest Name
    ///@param guestAddress[] guest Address
    ///@param initiateStatus Auto(1) or Manual(2)
    function addAgenda(
        uint256 eventTokenId,
        uint256 agendaStartTime,
        uint256 agendaEndTime,
        string memory agendaName,
        string[] memory guestName,
        string[] memory guestAddress,
        uint8 initiateStatus
    )
        external
        isValidTime(agendaStartTime, agendaEndTime)
        isEventOrganiser(eventTokenId)
    {
        require(
            (IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId)),
            "ManageEvent: TokenId does not exist"
        );
        (uint256 eventStartTime, uint256 eventEndTime, , , , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);
        require(
            agendaStartTime >= eventStartTime && agendaEndTime <= eventEndTime,
            "ManageEvent: Invalid agenda time"
        );
        require(
            guestName.length == guestAddress.length,
            "ManageEvent: Invalid input"
        );
        uint256 agendaId = noOfAgendas[eventTokenId];
        noOfAgendas[eventTokenId]++;
        require(
            isAgendaTimeAvailable(
                eventTokenId,
                agendaId,
                agendaStartTime,
                agendaEndTime,
                0
            ),
            "ManageEvent: Agenda Time not available"
        );
        getAgendaInfo[eventTokenId].push(
            agendaDetails(
                agendaId,
                agendaStartTime,
                agendaEndTime,
                agendaName,
                guestName,
                guestAddress,
                initiateStatus,
                false
            )
        );
        emit AgendaAdded(
            eventTokenId,
            agendaId,
            agendaStartTime,
            agendaEndTime,
            agendaName,
            guestName,
            guestAddress,
            initiateStatus
        );
    }

    function updateAgenda(
        uint256 eventTokenId,
        uint256 agendaId,
        uint256 agendaStartTime,
        uint256 agendaEndTime,
        string memory agendaName,
        string[] memory guestName,
        string[] memory guestAddress,
        uint8 initiateStatus
    )
        external
        isValidTime(agendaStartTime, agendaEndTime)
        isEventOrganiser(eventTokenId)
    {
        require(
            block.timestamp <
                getAgendaInfo[eventTokenId][agendaId].agendaStartTime,
            "ManageEvent: Agenda already started"
        );
        require(
            isAgendaTimeAvailable(
                eventTokenId,
                agendaId,
                agendaStartTime,
                agendaEndTime,
                1
            ),
            "ManageEvent: Agenda Time not available"
        );
        require(
            getAgendaInfo[eventTokenId][agendaId].isAgendaDeleted == false,
            "ManageEvent: agenda deleted"
        );
        getAgendaInfo[eventTokenId][agendaId].agendaStartTime = agendaStartTime;
        getAgendaInfo[eventTokenId][agendaId].agendaEndTime = agendaEndTime;
        getAgendaInfo[eventTokenId][agendaId].agendaName = agendaName;
        getAgendaInfo[eventTokenId][agendaId].guestName = guestName;
        getAgendaInfo[eventTokenId][agendaId].guestAddress = guestAddress;
        getAgendaInfo[eventTokenId][agendaId].initiateStatus = initiateStatus;
        emit AgendaUpdated(
            eventTokenId,
            agendaId,
            agendaStartTime,
            agendaEndTime,
            agendaName,
            guestName,
            guestAddress,
            initiateStatus
        );
    }

    function deleteAgenda(uint256 eventTokenId, uint256 agendaId)
        external
        isEventOrganiser(eventTokenId)
    {
        require(
            (IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId)),
            "ManageEvent: TokenId does not exist"
        );
        require(
            block.timestamp <
                getAgendaInfo[eventTokenId][agendaId].agendaStartTime,
            "ManageEvent: Agenda already started"
        );
        getAgendaInfo[eventTokenId][agendaId].isAgendaDeleted = true;
        emit AgendaDeleted(eventTokenId, agendaId, true);
    }

    ///@notice To initiate a session(1 - autoInitiate, 2 - Manual Initiate)
    ///@param eventTokenId event Token Id
    ///@param agendaId agendaId
    function initiateSession(uint256 eventTokenId, uint256 agendaId)
        external
        isEventOrganiser(eventTokenId)
    {
        require(
            (IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId)),
            "ManageEvent: TokenId does not exist"
        );
        require(
            getAgendaInfo[eventTokenId][agendaId].initiateStatus == 2,
            "ManageEvent: Auto Session"
        );
        require(
            getAgendaInfo[eventTokenId][agendaId].isAgendaDeleted == false,
            "ManageEvent: Agenda deleted"
        );
        require(
            block.timestamp >=
                getAgendaInfo[eventTokenId][agendaId].agendaStartTime,
            "ManageEvent: Session not started"
        );
        require(
            block.timestamp <
                getAgendaInfo[eventTokenId][agendaId].agendaEndTime,
            "ManageEvent: Session ended"
        );
        emit AgendaStarted(eventTokenId, agendaId);
    }

    ///@notice Called by event organiser to mark the event status as completed
    ///@param eventTokenId event token id
    function complete(uint256 eventTokenId) external {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ManageEvent: TokenId does not exist");
        (
            , uint256 endTime,
            address payable eventOrganiser
            , , , 
        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        
        require(
            block.timestamp >= endTime,
            "ManageEvent: Event not ended"
        );
        require(
            isEventCancelled(eventTokenId) == false,
            "ManageEvent: Event is cancelled"
        );
        require(
            isEventStarted(eventTokenId) == true,
            "ManageEvent: Event is not started"
        );
        require(msg.sender == eventOrganiser, "ManageEvent: Invalid Caller");
        eventCompletedStatus[eventTokenId] = true;
        emit EventCompleted(eventTokenId);
    }

    function exit(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId
        ) external {
            require(
                IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).recoverSigner(
                    IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).getMessageHash(ticketHolder, eventTokenId, 0),
                    signature
                ) == IAdminFunctions(adminContract).getSignerAddress(),
                "ManageEvent: Signature does not match"
            );
            require(
                IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId),
                "ManageEvent: TokenId does not exist"
            );
            require(
                isEventStarted(eventTokenId) == true,
                "ManageEvent: Event not started"
            );
            exitEventStatus[ticketHolder][eventTokenId] = true;
            emit Exited(eventTokenId, ticketHolder, block.timestamp);

    }

    function end(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId
        ) external {
            require(
                IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).recoverSigner(
                    IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).getMessageHash(ticketHolder, eventTokenId, 0),
                    signature
                ) == IAdminFunctions(adminContract).getSignerAddress(),
                "ManageEvent: Signature does not match"
            );
            require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ManageEvent: TokenId does not exist");
            require(
                isEventCancelled(eventTokenId) == false,
                "ManageEvent: Event is cancelled"
            );
            require(
                isEventStarted(eventTokenId) == true,
                "ManageEvent: Event is not started"
            );
             (, , address payable eventOrganiser , , , ) = IEvents(
                IAdminFunctions(adminContract).getEventContract()
            ).getEventDetails(eventTokenId);
            require(ticketHolder == eventOrganiser, "ManageEvent: Invalid Caller");
            eventEndedStatus[eventTokenId] = true;
            emit EventEnded(eventTokenId);
    }

    ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEvent(uint256 eventTokenId) external {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ManageEvent: TokenId does not exist");
        (
            uint256 startTime,
            uint256 endTime,
            address eventOrganiser,
            bool payNow,
            ,

        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        require(
            block.timestamp >= startTime && endTime > block.timestamp,
            "ManageEvent: Event not live"
        );
        require(msg.sender == eventOrganiser, "ManageEvent: Invalid Address");
        require(payNow == true, "ManageEvent: Fees not paid");
        eventStartedStatus[eventTokenId] = true;
        emit EventStarted(eventTokenId);

    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEvent(uint256 eventTokenId) external {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ManageEvent: TokenId does not exist");
        (
            ,
            ,
            address payable eventOrganiser,
            ,
            ,

        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        require(isEventStarted(eventTokenId) == false, "ManageEvent: Event started");
        require(msg.sender == eventOrganiser, "ManageEvent: Invalid Address");
        require(
            eventCancelledStatus[eventTokenId] == false,
            "ManageEvent: Event already cancelled"
        );
        eventCancelledStatus[eventTokenId] = true;
        emit EventCancelled(eventTokenId);
    }

    function claimTicketFees(uint256 eventTokenId, address[] memory tokenAddress) external {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId),
            "ManageEvent: TokenId does not exist"
        );
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == false && IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ManageEvent: Event is cancelled"
        );
        (, , address payable eventOrganiser, , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser, "ManageEvent: Invalid Address");
        for(uint256 i = 0; i< tokenAddress.length; i++) {
            if((ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).isERC721TokenAddress(tokenAddress[i])) == true) {
                uint256[] memory ticketIds = ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).getTicketIds(tokenAddress[i]);
                
                for(uint256 j = 0; j < ticketIds.length; j++) {
                    (uint256 refundAmount,
                    ) = ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).
                    getUserTicketDetails(eventTokenId, ticketIds[j]);

                    if(refundAmount > 0 && claimERC721TicketStatus[eventTokenId][ticketIds[j]] == false) {
                        ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimNft(eventOrganiser, tokenAddress[i], refundAmount);
                        claimERC721TicketStatus[eventTokenId][ticketIds[j]] = true;

                    }
                }
            }
            else {
                uint256 amount = ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).getTicketFeesBalance(eventTokenId, tokenAddress[i]);
                if(amount > 0 && claimERC20TicketStatus[eventTokenId][tokenAddress[i]] == false) {
                    ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(eventOrganiser, tokenAddress[i], amount);
                    claimERC20TicketStatus[eventTokenId][tokenAddress[i]] = true;
                }
            }
        }
        emit TicketFeesClaimed(eventTokenId, eventOrganiser, tokenAddress);
    }

    function refundTicketFees(uint256 eventTokenId, uint256[] memory ticketIds) external {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId),
            "ManageEvent: TokenId does not exist"
        );
        (, uint256 endTime , , , , uint256 actualPrice) = IEvents(IAdminFunctions(adminContract).getEventContract())
        .getEventDetails(eventTokenId);
        require(actualPrice != 0, "ManageEvent: Event is free");
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == true || IAdminFunctions(adminContract).isEventStarted(eventTokenId) == false && block.timestamp > endTime,
            "ManageEvent: Event is neither cancelled nor expired"
        );
        address ownerAddress = msg.sender;
        for(uint256 i=0; i < ticketIds.length; i++) {
            if(refundTicketFeesStatus[eventTokenId][ticketIds[i]] == false) {
                if(ownerAddress == ITicket(ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).getTicketNFTAddress(eventTokenId)).ownerOf(ticketIds[i])) {
                    (uint256 refundAmount,
                    address tokenAddress) = ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).
                    getUserTicketDetails(eventTokenId, ticketIds[i]);
                    if((ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract()).isERC721TokenAddress(tokenAddress)) == true) {
                        ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimNft(ownerAddress, tokenAddress, refundAmount);
                    }
                    else {
                        ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(ownerAddress, tokenAddress, refundAmount);
                    }
                    refundTicketFeesStatus[eventTokenId][ticketIds[i]] = true;
                    emit TicketFeesRefund(eventTokenId, ownerAddress, ticketIds[i]);
                 }
            }
        }
    }

    function isEventEnded(uint256 eventId) public view returns (bool) {
        return eventEndedStatus[eventId];   
    }

    function isEventStarted(uint256 eventId) public view returns (bool) {
        return eventStartedStatus[eventId];
    }

    function isEventCancelled(uint256 eventId) public view returns (bool) {
        return eventCancelledStatus[eventId];
    }

    function isAgendaTimeAvailable(
        uint256 eventTokenId,
        uint256 agendaId,
        uint256 agendaStartTime,
        uint256 agendaEndTime,
        uint256 timeType
    ) internal returns (bool _isAvailable) {
        uint256[] memory bookedAgendas = agendaInEvents[eventTokenId];
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < bookedAgendas.length; i++) {
            if (
                bookedAgendas[i] == agendaId ||
                getAgendaInfo[eventTokenId][bookedAgendas[i]].isAgendaDeleted ==
                true
            ) continue;
            uint256 bookedStartTime = getAgendaInfo[eventTokenId][
                bookedAgendas[i]
            ].agendaStartTime;
            uint256 bookedEndTime = getAgendaInfo[eventTokenId][
                bookedAgendas[i]
            ].agendaEndTime;
            if (currentTime >= bookedEndTime) continue;
            if (
                currentTime >= bookedStartTime && currentTime <= bookedEndTime
            ) {
                if (agendaStartTime >= bookedEndTime) {
                    continue;
                } else {
                    return false;
                }
            } else {
                //check for future event
                if (
                    agendaEndTime <= bookedStartTime ||
                    agendaStartTime >= bookedEndTime
                ) {
                    continue;
                } else {
                    return false;
                }
            }
        }
        if (timeType == 0) agendaInEvents[eventTokenId].push(agendaId);
        return true;
    }
}
