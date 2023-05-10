// SPDX-License-Identifier: UNLICENSED

import "./interface/IAdminFunctions.sol";
import "./interface/IVerifySignature.sol";
import "./interface/IEvents.sol";
import "./access/Ownable.sol";
import "./utils/EventCallStorage.sol";

pragma solidity ^0.8.0;

contract EventCall is Ownable, EventCallStorage {
    using AddressUpgradeable for address;

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    // modifier for checking event organiser address
    modifier isEventOrganiser(uint256 eventTokenId) {
        (, , address eventOrganiser, , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser, "ERR_131:ManageEvent:Invalid Address");
        _;
    }

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "ERR_116:Events:Address is not a contract"
        );
        adminContract = _adminContract;

    }

    ///@notice Called by event organiser to mark the event status as completed
    ///@param eventTokenId event token id
    function completeInternal(uint256 eventTokenId) internal isEventOrganiser(eventTokenId) {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ERR_132:ManageEvent:TokenId does not exist");
        (
            , uint256 endTime,
            , , , 
        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        
        require(
            block.timestamp >= endTime,
            "ManageEvent: Event not ended"
        );
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == false,
            "ERR_138:ManageEvent:Event is cancelled"
        );
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
        eventCompletedStatus[eventTokenId] = true;
    }

    ///@notice To end the event before endTime
    function endInternal(
        uint256 eventTokenId
        ) internal isEventOrganiser(eventTokenId) {
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
        eventEndedStatus[eventTokenId] = true;
    }

     ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEventInternal(uint256 eventTokenId) internal isEventOrganiser(eventTokenId) {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ERR_132:ManageEvent:TokenId does not exist");
        (
            uint256 startTime,
            uint256 endTime,
            ,
            bool payNow,
            ,

        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        require(
            block.timestamp >= startTime && endTime > block.timestamp,
            "ERR_141:ManageEvent:Event not live"
        );
        require(payNow == true, "ERR_142:ManageEvent:Fees not paid");
        eventStartedStatus[eventTokenId] = true;

    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEventInternal(uint256 eventTokenId) external isEventOrganiser(eventTokenId) {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ERR_132:ManageEvent:TokenId does not exist");
        require(IAdminFunctions(adminContract).isEventStarted(eventTokenId) == false, "ERR_143:ManageEvent:Event started");
        require(
            eventCancelledStatus[eventTokenId] == false,
            "ERR_138:ManageEvent:Event is cancelled"
        );
        eventCancelledStatus[eventTokenId] = true;
    }

    function joinInternal(
        bytes memory signature,
        address ticketHolder, 
        uint256 eventTokenId, 
        uint256 ticketId,
        uint256 joinTime
    ) internal view returns(address) {
        require(
            IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).recoverSigner(
                IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).getMessageHash(ticketHolder, eventTokenId, ticketId, joinTime),
                signature
            ) == IAdminFunctions(adminContract).getSignerAddress(),
                "ERR_113:Events:Signature does not match"
        );
        (, uint256 endTime, address eventOrganiser , , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true && endTime > joinTime,
            "ERR_114:Events:Event is not live"
        );
        return eventOrganiser;
    }

    function userExitEventInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 exitTime) internal view returns(address) {
        require(
            IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).recoverSigner(
                IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).getMessageHash(ticketHolder, eventTokenId, ticketId, exitTime),
                signature
            ) == IAdminFunctions(adminContract).getSignerAddress(),
            "ERR_140:ManageEvent:Signature does not match"
        );

        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
        (, , address eventOrganiser , , , ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        
        return eventOrganiser;

    }

    function updateEventInternal(uint256 eventTokenId) internal view returns(uint256) {
         (uint256 startTime, , address eventOrganiser, , uint256 venueTokenId, ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
         //check for msg.sender
         require(
            msg.sender == eventOrganiser,
            "ERR_103:Events:Address is not the event organiser address"
        );
        require(
            startTime > block.timestamp,
            "ERR_104:Events:Event is started"
        );       
        return venueTokenId;
    }

    function payEventInternal(uint256 eventTokenId) internal view returns(uint256, uint256, bool, uint256) {
        (uint256 startTime, uint256 endTime, 
        address eventOrganiser, bool payNow, 
        uint256 venueTokenId, ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        require(
            endTime > block.timestamp,
            "ERR_112:Events:Event ended"
        );
        //check for msg.sender
        require(msg.sender == eventOrganiser, "ERR_108:Events:Invalid Caller");
   
        return (startTime, endTime, payNow, venueTokenId);
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

}