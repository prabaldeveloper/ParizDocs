// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "./interface/IAdminFunctions.sol";
import "./interface/IVerifySignature.sol";
import "./interface/IVenue.sol";
import "./interface/IEvents.sol";
import "./interface/ITokenCompatibility.sol";
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
        (, , address _eventOrganiser, , , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);
        require(
            eventOrganiser == _eventOrganiser,
            "ERR_131:ManageEvent:Invalid Address"
        );
        _;
    }

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "ERR_116:Events:Address is not a contract"
        );
        adminContract = _adminContract;
    }

    function updateTokenCompatibility(
        address _tokenCompatibility
    ) external onlyOwner {
        require(
            _tokenCompatibility.isContract(),
            "ERR_116:Events:Address is not a contract"
        );
        tokenCompatibility = _tokenCompatibility;
    }

    function checkTokenCompatibility(
        address[] memory tokenAddress,
        string[] memory tokenType
    ) public view {
        for (uint i = 0; i < tokenAddress.length; i++) {
            if (
                keccak256(abi.encodePacked((tokenType[i]))) ==
                keccak256(abi.encodePacked(("ERC721")))
            ) {
                require(
                    IAdminFunctions(adminContract).isERC721(tokenAddress[i]) !=
                        true,
                    "Invalid token Type ERC721"
                );
            }
            if (
                keccak256(abi.encodePacked((tokenType[i]))) ==
                keccak256(abi.encodePacked(("ERC20")))
            ) {
                require(
                    ITokenCompatibility(tokenCompatibility).checkCompatibility(
                        tokenAddress[i],
                        IERC20Metadata(tokenAddress[i]).symbol()
                    ) != true,
                    "Invalid token Type ERC20"
                );
            }
        }
    }

    ///@notice Called by event organiser to mark the event status as completed
    ///@param eventTokenId event token id
    function completeInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(
                eventTokenId
            ),
            "ERR_132:ManageEvent:TokenId does not exist"
        );
        (, uint256 endTime, , , , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);

        require(block.timestamp >= endTime, "ManageEvent: Event not ended");
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) ==
                false,
            "ERR_138:ManageEvent:Event is cancelled"
        );
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
    }

    ///@notice To end the event before endTime
    function endInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
    }

    ///@notice Start the event
    ///@param eventTokenId event Token Id
    function startEventInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(
                eventTokenId
            ),
            "ERR_132:ManageEvent:TokenId does not exist"
        );
        (uint256 startTime, uint256 endTime, , bool payNow, , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);
        require(
            block.timestamp >= startTime && endTime > block.timestamp,
            "ERR_141:ManageEvent:Event not live"
        );
        require(payNow == true, "ERR_142:ManageEvent:Fees not paid");
    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEventInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) public view isEventOrganiser(eventTokenId, eventOrganiser) {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(
                eventTokenId
            ),
            "ERR_132:ManageEvent:TokenId does not exist"
        );
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) ==
                false,
            "ERR_143:ManageEvent:Event started"
        );
    }

    function joinInternal(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId,
        uint256 ticketId,
        uint256 joinTime
    ) public view returns (address) {
        require(
            IVerifySignature(
                IAdminFunctions(adminContract).getSignatureContract()
            ).recoverSigner(
                    IVerifySignature(
                        IAdminFunctions(adminContract).getSignatureContract()
                    ).getMessageHash(
                            ticketHolder,
                            eventTokenId,
                            ticketId,
                            joinTime
                        ),
                    signature
                ) == IAdminFunctions(adminContract).getSignerAddress(),
            "ERR_113:Events:Signature does not match"
        );
        (, uint256 endTime, address eventOrganiser, , , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) ==
                true &&
                endTime > joinTime,
            "ERR_114:Events:Event is not live"
        );
        return eventOrganiser;
    }

    function userExitEventInternal(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId,
        uint256 ticketId,
        uint256 exitTime
    ) public view returns (address) {
        require(
            IVerifySignature(
                IAdminFunctions(adminContract).getSignatureContract()
            ).recoverSigner(
                    IVerifySignature(
                        IAdminFunctions(adminContract).getSignatureContract()
                    ).getMessageHash(
                            ticketHolder,
                            eventTokenId,
                            ticketId,
                            exitTime
                        ),
                    signature
                ) == IAdminFunctions(adminContract).getSignerAddress(),
            "ERR_140:ManageEvent:Signature does not match"
        );

        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_139:ManageEvent:Event is not started"
        );
        (, , address eventOrganiser, , , ) = IEvents(
            IAdminFunctions(adminContract).getEventContract()
        ).getEventDetails(eventTokenId);

        return eventOrganiser;
    }

    function updateEventInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) public view returns (uint256) {
        (
            uint256 _startTime,
            ,
            address _eventOrganiser,
            ,
            uint256 _venueTokenId,

        ) = IEvents(IAdminFunctions(adminContract).getEventContract())
                .getEventDetails(eventTokenId);
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

    function calculateRentInternal(
        uint256 venueTokenId,
        uint256 noOfBlocks
    )
        public
        view
        returns (
            uint256 _estimatedCost,
            uint256 _platformFees,
            uint256 _venueRentalCommissionFees
        )
    {
        uint256 rentalFees = IVenue(
            IAdminFunctions(adminContract).getVenueContract()
        ).getRentalFeesPerBlock(venueTokenId) * noOfBlocks;
        uint256 platformFees = (rentalFees *
            IAdminFunctions(adminContract).getPlatformFeePercent()) / 100;
        uint256 venueRentalCommission = IAdminFunctions(adminContract)
            .getVenueRentalCommission();
        uint256 venueRentalCommissionFee = (rentalFees *
            venueRentalCommission) / 100;
        uint256 estimatedCost = rentalFees + platformFees;
        return (estimatedCost, platformFees, venueRentalCommissionFee);
    }

    function isVenueAvailableInternal(
        uint256 eventTokenId,
        uint256 startTime,
        uint256 endTime,
        uint256[] memory bookedEvents
    ) public view returns (bool) {
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < bookedEvents.length; i++) {
            if (
                bookedEvents[i] == eventTokenId ||
                IAdminFunctions(adminContract).isEventCancelled(
                    bookedEvents[i]
                ) ==
                true
            ) continue;
            else {
                (uint256 _startTime, uint256 _endTime, , , , ) = IEvents(
                    IAdminFunctions(adminContract).getEventContract()
                ).getEventDetails(bookedEvents[i]);
                // uint256 bookedStartTime = getInfo[bookedEvents[i]].startTime;
                // uint256 bookedEndTime = getInfo[bookedEvents[i]].endTime;
                uint256 bookedStartTime = _startTime;
                uint256 bookedEndTime = _endTime;
                // skip for passed event
                if (currentTime >= bookedEndTime) continue;
                if (
                    currentTime >= bookedStartTime &&
                    currentTime <= bookedEndTime
                ) {
                    //check for ongoing event
                    if (startTime >= bookedEndTime) {
                        continue;
                    } else {
                        return false;
                    }
                } else {
                    //check for future event
                    if (
                        endTime <= bookedStartTime || startTime >= bookedEndTime
                    ) {
                        continue;
                    } else {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
