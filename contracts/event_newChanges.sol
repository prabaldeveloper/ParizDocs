// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IVenue.sol";
import "./interface/ITicketMaster.sol";
import "./interface/ITreasury.sol";
import "./interface/ITicket.sol";
import "./interface/IAdminFunctions.sol";
import "./interface/IVerifySignature.sol";
import "./utils/EventAdminRole.sol";

///@notice Users can create event and join events

contract EventsV1 is EventAdminRole {
    
    ///@param tokenId Event tokenId
    ///@param tokenCID Event tokenCID
    ///@param venueTokenId venueTokenId
    ///@param isEventPaid isEventPaid
    ///@param eventOrganiser address of the organiser
    ///@param ticketPrice ticketPrice of event
    event EventAdded(
        uint256 indexed tokenId,
        string tokenCID,
        uint256 venueTokenId,
        bool isVenueFeesPaid,
        bool isEventPaid,
        address eventOrganiser,
        uint256 ticketPrice,
        uint256 venueFeeAmount,
        address ticketNFTAddress
    );

    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    event EventUpdated(
        uint256 indexed tokenId,
        string description,
        uint256 startTime,
        uint256 endTime,
        uint256 venueFeeAmount
    );

    ///@param tokenId Event tokenId
    event Featured(uint256 indexed tokenId, bool isFeatured);

    ///@param user User address
    ///@param tokenId Event tokenId
    ///@param isFavourite is event favourite(true or false)
    event Favourite(address user, uint256 indexed tokenId, bool isFavourite);

    ///@param eventTokenId event Token Id
    ///@param payNow pay venue fees now if(didn't pay earlier)
    event EventPaid(uint256 indexed eventTokenId, bool payNow, uint256 venueFeeAmount);

    ///@param tokenId Event tokenId
    ///@param user User address
    event Joined(
        uint256 indexed tokenId,
        address indexed user,
        uint256 joiningTime,
        uint256 ticketId
    );

    event VenueFeesClaimed(uint256 indexed venueTokenId, uint256[] eventIds, address venueOwner);

    event VenueFeesRefunded(uint256 indexed eventTokenId, address eventOrganiser);

    //modifier for checking whitelistedUsers
    modifier onlyWhitelistedUsers() {
        require(
            IAdminFunctions(adminContract).isUserWhitelisted(msg.sender) == true || IAdminFunctions(adminContract).getEventStatus() == true,
            "Events : User address not whitelisted"
        );
        _;
    }

    //modifier for checking valid time
    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "Invalid time input"
        );
        _;
    }

    function updateEvent(uint256 tokenId, string memory description, uint256[2] memory time) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(
            msg.sender == getInfo[tokenId].eventOrganiser,
            "Events: Address is not the event organiser address"
        );
        require(
            getInfo[tokenId].startTime > block.timestamp,
            "Events: Event is started"
        );       
        uint256 venueTokenId = getInfo[tokenId].venueTokenId;
        require(
            isVenueAvailable(tokenId, venueTokenId, time[0], time[1], 1),
            "ERR_100:Events:Venue is not available"
        );
        if(time[0] != getInfo[tokenId].startTime || time[1] != getInfo[tokenId].endTime) {
            if(getInfo[tokenId].payNow == true) {
                uint256 feesPaid = balance[tokenId] + platformFeesPaid[tokenId];
                (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
                venueTokenId,
                time[0],
                time[1]
                );
                address tokenAddress = IAdminFunctions(adminContract).getBaseToken();
                if(feesPaid > estimatedCost) {
                    ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(getInfo[tokenId].eventOrganiser,tokenAddress, feesPaid - estimatedCost);
                    balance[tokenId] = estimatedCost - _platformFees;
                    platformFeesPaid[tokenId] = _platformFees;
                }
                else {
                    IERC20(tokenAddress).transferFrom(
                    getInfo[tokenId].eventOrganiser,
                    IAdminFunctions(adminContract).getTreasuryContract(),
                    estimatedCost - feesPaid
                    );
                    balance[tokenId] = estimatedCost - _platformFees;
                    platformFeesPaid[tokenId] = _platformFees;
                }
            }
            getInfo[tokenId].startTime = time[0];
            getInfo[tokenId].endTime = time[1];
        }
        getInfo[tokenId].description = description;
        emit EventUpdated(tokenId, description, time[0], time[1], balance[tokenId] + platformFeesPaid[tokenId]);
    }

    ///@notice Creates Event
    ///@dev Event organiser can call
    ///@dev - Check whether venue is available.
    ///@dev - Check whether event is paid or free for users.
    ///@dev - Check whether venue fees is paid or it is mark as pay later.
    ///@dev - Save all the fields in the contract.
    ///@param details[3] => details[0] = Event name, details[1] = Event category, details[2] = Event description
    ///@param time[2] => time[0] = Event startTime, time[1] = Event endTime
    ///@param tokenCID Event tokenCID
    ///@param venueTokenId venueTokenId
    ///@param venueFeeAmount fee of the venue
    ///@param ticketPrice ticketPrice of event
    ///@param isEventPaid isEventPaid(true or false)
    ///@param payNow pay venue fees now or later(true or false)
    function add(
        string[3] memory details,
        uint256[2] memory time,
        string memory tokenCID,
        uint256 venueTokenId,
        uint256 venueFeeAmount,
        uint256 ticketPrice,
        bool isEventPaid,
        bool payNow
    ) external onlyWhitelistedUsers {
        uint256 _tokenId = _mintInternal(tokenCID);
        require(
            IVenue(IAdminFunctions(adminContract).getVenueContract())._exists(venueTokenId),
            "Events: Venue tokenId does not exists"
        );
        require(
            isVenueAvailable(_tokenId, venueTokenId, time[0], time[1], 0),
            "ERR_100:Events:Venue is not available"
        );
        if (payNow == true) {
            checkVenueFees(
                venueTokenId,
                time[0],
                time[1],
                msg.sender,
                _tokenId,
                venueFeeAmount
            );
        }
        if (isEventPaid == false) {
            ticketPrice = 0;
        }
        getInfo[_tokenId] = Details(
            details[0],
            details[1],
            details[2],
            _tokenId,
            time[0],
            time[1],
            venueTokenId,
            payNow,
            payable(msg.sender),
            ticketPrice
        );

        ticketNFTAddress[_tokenId] = ITicketMaster(IAdminFunctions(adminContract).getTicketMasterContract())
            .deployTicketNFT(
                _tokenId,
                details[0],
                time,
                IVenue(IAdminFunctions(adminContract).getVenueContract()).getTotalCapacity(venueTokenId)
            );
        emit EventAdded(
            _tokenId,
            tokenCID,
            venueTokenId,
            payNow,
            isEventPaid,
            msg.sender,
            ticketPrice,
            venueFeeAmount,
            ticketNFTAddress[_tokenId] 
        );
    }

    function calculateRent(
        uint256 venueTokenId,
        uint256 eventStartTime,
        uint256 eventEndTime
    )
        public
        view
        returns (
            uint256 _estimatedCost,
            uint256 _platformFees,
            uint256 _venueRentalCommissionFees
        )
    {
        uint256 noOfBlocks = (eventEndTime - eventStartTime) / blockTime;
        uint256 rentalFees = IVenue(IAdminFunctions(adminContract).getVenueContract()).getRentalFeesPerBlock(
            venueTokenId
        ) * noOfBlocks;
        uint256 platformFees = (rentalFees * IAdminFunctions(adminContract).getPlatformFeePercent()) / 100;
        uint256 venueRentalCommission = IAdminFunctions(adminContract).getVenueRentalCommission();
        uint256 venueRentalCommissionFee = (rentalFees *
            venueRentalCommission) / 100;
        uint256 estimatedCost = rentalFees + platformFees;
        return (estimatedCost, platformFees, venueRentalCommissionFee);
    }

    ///@notice Feature the event
    ///@dev Only admin can call
    ///@dev - Mark the event as featured
    ///@param tokenId Event tokenId
    ///@param isFeatured Event featured(true/false)
    function featured(uint256 tokenId, bool isFeatured) external onlyOwner {
        require(_exists(tokenId), "Events: TokenId does not exist");
        featuredEvents[tokenId] = isFeatured;
        emit Featured(tokenId, isFeatured);
    }

    ///@notice Users can mark their favourite events
    ///@param tokenId Event tokenId
    ///@param isFavourite Event favourite(true/false)
    function updateFavourite(uint256 tokenId, bool isFavourite) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        favouriteEvents[msg.sender][tokenId] = isFavourite;
        emit Favourite(msg.sender, tokenId, isFavourite);
    }

    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
    }


    ///@notice Returns true if rent paid
    ///@param eventOrganiser eventOrganiser address
    ///@param eventTokenId Event tokenId
    function isRentPaid(address eventOrganiser, uint256 eventTokenId)
        public
        view
        returns (bool)
    {
        return rentStatus[eventOrganiser][eventTokenId];
    }

    ///@notice Check for venue availability
    ///@param eventTokenId eventTokenId
    ///@param venueTokenId Venue tokenId
    ///@param startTime Venue startTime
    ///@param endTime Venue endTime
    ///@return _isAvailable Returns true if available
    function isVenueAvailable(
        uint256 eventTokenId,
        uint256 venueTokenId,
        uint256 startTime,
        uint256 endTime,
        uint256 timeType
    ) internal isValidTime(startTime, endTime) returns (bool _isAvailable) {
        uint256[] memory bookedEvents = eventsInVenue[venueTokenId];
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < bookedEvents.length; i++) {
            if (bookedEvents[i] == eventTokenId || IAdminFunctions(adminContract).isEventCancelled(bookedEvents[i]) == true) continue;
            else {
                uint256 bookedStartTime = getInfo[bookedEvents[i]].startTime;
                uint256 bookedEndTime = getInfo[bookedEvents[i]].endTime;
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
        if (timeType == 0) eventsInVenue[venueTokenId].push(eventTokenId);
        return true;
    }

    ///@notice To check whether token is matic or any other token
    ///@param venueTokenId venueTokenId
    ///@param startTime event startTime
    ///@param endTime event endTime
    ///@param eventOrganiser event organiser address
    ///@param eventTokenId event tokenId
    ///@param feeAmount fee of the venue(rentalFee + platformFee)
    function checkVenueFees(
        uint256 venueTokenId,
        uint256 startTime,
        uint256 endTime,
        address eventOrganiser,
        uint256 eventTokenId,
        uint256 feeAmount
    ) internal {
        address tokenAddress = IAdminFunctions(adminContract).getBaseToken();
        require(
            IAdminFunctions(adminContract).isErc20TokenWhitelisted(tokenAddress) == true,
            "Events: PaymentToken Not Supported"
        );
        (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
            venueTokenId,
            startTime,
            endTime
        );
        uint256 platformFees = _platformFees;
        IAdminFunctions(adminContract).checkDeviation(feeAmount, estimatedCost);
        IERC20(tokenAddress).transferFrom(
            eventOrganiser,
            IAdminFunctions(adminContract).getTreasuryContract(),
            feeAmount
        );
        platformFeesPaid[eventTokenId] = platformFees;
        balance[eventTokenId] = feeAmount - platformFees;
        eventTokenAddress[eventTokenId] = tokenAddress;
        rentPaid(msg.sender, eventTokenId, true);
    }

    function claimVenueFees(uint256 venueTokenId) external {
        require(
            IVenue(IAdminFunctions(adminContract).getVenueContract())._exists(venueTokenId),
            "Events: Venue tokenId does not exists"
        );
        uint256[] memory eventIds = eventsInVenue[venueTokenId];
        address tokenAddress = IAdminFunctions(adminContract).getBaseToken();
        address venueOwner = IVenue(IAdminFunctions(adminContract).getVenueContract()).getVenueOwner(venueTokenId);
        require(msg.sender == venueOwner, "Events: Invalid Caller");
        for(uint256 i=0; i< eventIds.length; i++) {
            if(IAdminFunctions(adminContract).isEventCancelled(eventIds[i]) == false && block.timestamp > getInfo[eventIds[i]].endTime) {
                if(balance[eventIds[i]] > 0) {
                    ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(venueOwner,tokenAddress, balance[eventIds[i]]);
                    balance[eventIds[i]] = 0;
                }
            }
        }
        emit VenueFeesClaimed(venueTokenId, eventIds, venueOwner);
    }

    function refundVenueFees(uint256 eventTokenId) external {
        require(_exists(eventTokenId), "Events: TokenId does not exist");
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == true,
            "Events: Event is not canceled"
        );
        require(msg.sender == getInfo[eventTokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getInfo[eventTokenId].payNow == true, "Events: Fees not paid");
        address tokenAddress = IAdminFunctions(adminContract).getBaseToken();
         (, , uint256 venueRentalCommissionFees) = calculateRent(
            getInfo[eventTokenId].venueTokenId,
            getInfo[eventTokenId].startTime,
            getInfo[eventTokenId].endTime
        );
        require(balance[eventTokenId] > 0, "Events: Funds already transferred");
        address venueOwner = IVenue(IAdminFunctions(adminContract).getVenueContract()).getVenueOwner(getInfo[eventTokenId].venueTokenId);
        ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(getInfo[eventTokenId].eventOrganiser,tokenAddress, balance[eventTokenId] - venueRentalCommissionFees);
        ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(venueOwner, tokenAddress, venueRentalCommissionFees);
        balance[eventTokenId] = 0;

        emit VenueFeesRefunded(eventTokenId, getInfo[eventTokenId].eventOrganiser);

    }

    ///@notice Pay the event fees
    ///@param eventTokenId event Token Id
    ///@param venueFeeAmount fee of the venue
    function payEvent(uint256 eventTokenId, uint256 venueFeeAmount)
        external
    {
        require(_exists(eventTokenId), "Events: TokenId does not exist");
        (
            uint256 startTime,
            uint256 endTime,
            address eventOrganiser,
            bool payNow,
            uint256 venueTokenId,

        ) = getEventDetails(eventTokenId);
        require(
            endTime > block.timestamp,
            "Events: Event ended"
        );
        require(msg.sender == eventOrganiser, "Events: Address is not the event organiser address");

        if (payNow == false) {
            checkVenueFees(
                venueTokenId,
                startTime,
                endTime,
                msg.sender,
                eventTokenId,
                venueFeeAmount
            );
            payNow = true;
            getInfo[eventTokenId].payNow = payNow;
            
        }
        else {
            uint256 feesPaid = balance[eventTokenId] + platformFeesPaid[eventTokenId];
            (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
            venueTokenId,
            startTime,
            endTime
            );
            address tokenAddress = IAdminFunctions(adminContract).getBaseToken();
            if(feesPaid > estimatedCost) {
                ITreasury(IAdminFunctions(adminContract).getTreasuryContract()).claimFunds(eventOrganiser,tokenAddress, feesPaid - estimatedCost);
                balance[eventTokenId] = estimatedCost - _platformFees;
                platformFeesPaid[eventTokenId] = _platformFees;

            }
            else {
                IERC20(tokenAddress).transferFrom(
                getInfo[eventTokenId].eventOrganiser,
                IAdminFunctions(adminContract).getTreasuryContract(),
                estimatedCost - feesPaid
                );
                balance[eventTokenId] = estimatedCost - _platformFees;
                platformFeesPaid[eventTokenId] = _platformFees;
            }
        }
        emit EventPaid(eventTokenId, payNow, venueFeeAmount);
    }

    ///@notice Users can join events
    ///@dev Public function
    ///@dev - Check whether event is started or not
    ///@dev - Check whether user has ticket if the event is paid
    ///@dev - Join the event
    ///@param eventTokenId Event tokenId
    function join(
        bytes memory signature,
        address ticketHolder, 
        uint256 eventTokenId, 
        uint256 ticketId
    ) external {
        require(
            IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).recoverSigner(
                IVerifySignature(IAdminFunctions(adminContract).getSignatureContract()).getMessageHash(ticketHolder, eventTokenId, ticketId),
                signature
            ) == IAdminFunctions(adminContract).getSignerAddress(),
                "Events: Signature does not match"
        );
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == false,
            "Events: Event is cancelled"
        );
        require(
            _exists(eventTokenId),
            "Events: TokenId does not exist"
        );
        (uint256 startTime, uint256 endTime, address eventOrganiser , , , ) = getEventDetails(eventTokenId);
        require(
            IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "Events: Event not started"
        );
        require(
            (block.timestamp >= startTime && endTime > block.timestamp) && IAdminFunctions(adminContract).isEventEnded(eventTokenId) == false,
            "Events: Event is not live" 
        );
        if(ticketHolder == eventOrganiser) {
            emit Joined(eventTokenId, ticketHolder, block.timestamp, ticketId);
        }
        else {
            require(
                ticketHolder == ITicket(ticketNFTAddress[eventTokenId]).ownerOf(ticketId),
                "Events: Caller is not the owner"
            );
            joinEventStatus[ticketNFTAddress[eventTokenId]][ticketId] = true;
            emit Joined(eventTokenId, ticketHolder, block.timestamp, ticketId);
        }
    }

    ///@notice Saves the status whether rent is paid or not
    ///@param eventOrganiser Event organiser address
    ///@param eventTokenId Event tokenId
    ///@param _isRentPaid true or false
    function rentPaid(
        address eventOrganiser,
        uint256 eventTokenId,
        bool _isRentPaid
    ) internal {
        rentStatus[eventOrganiser][eventTokenId] = _isRentPaid;
    }

    function getEventDetails(uint256 tokenId)
        public
        view
        returns (
            uint256 startTime,
            uint256 endTime,
            address payable eventOrganiser,
            bool payNow,
            uint256 venueTokenId,
            uint256 ticketPrice
        )
    {
        return (
            getInfo[tokenId].startTime,
            getInfo[tokenId].endTime,
            getInfo[tokenId].eventOrganiser,
            getInfo[tokenId].payNow,
            getInfo[tokenId].venueTokenId,
            getInfo[tokenId].ticketPrice
        );
    }

    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
    public
    view
    returns (bool)
    {
        return joinEventStatus[_ticketNftAddress][_ticketId];
    }
}