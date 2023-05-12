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
    modifier isEventOrganiser(uint256 eventTokenId, address eventOrganiser) {
        (, , address _eventOrganiser, , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        require(eventOrganiser == _eventOrganiser, "ERR_131:ManageEvent:Invalid Address");
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
    function completeInternal(uint256 eventTokenId, address eventOrganiser) public view isEventOrganiser(eventTokenId, eventOrganiser) {
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
    }

    ///@notice To end the event before endTime
    function endInternal(
        uint256 eventTokenId, address eventOrganiser
        ) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
    }

     ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEventInternal(uint256 eventTokenId, address eventOrganiser) public view isEventOrganiser(eventTokenId, eventOrganiser) {
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

    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEventInternal(uint256 eventTokenId, address eventOrganiser) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId), "ERR_132:ManageEvent:TokenId does not exist");
        require(IAdminFunctions(adminContract).isEventStarted(eventTokenId) == false, "ERR_143:ManageEvent:Event started");
    }

    function joinInternal(
        bytes memory signature,
        address ticketHolder, 
        uint256 eventTokenId, 
        uint256 ticketId,
        uint256 joinTime
    ) public view returns(address) {
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

    function userExitEventInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 exitTime) public view returns(address) {
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

    function updateEventInternal(uint256 eventTokenId, address eventOrganiser) public view returns(uint256) {
        (uint256 _startTime, , address _eventOrganiser, , uint256 _venueTokenId, ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        require(
            eventOrganiser == _eventOrganiser,
            "ERR_103:Events:Address is not the event organiser address"
        );
        require(
            _startTime > block.timestamp,
            "ERR_104:Events:Event is started"
        );       
        return _venueTokenId;
    }
}