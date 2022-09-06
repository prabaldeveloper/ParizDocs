// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IVenue.sol";
import "./utils/EventMetadata.sol";
import "../contracts/interface/IConversion.sol";
import "./interface/ITicketMaster.sol";

///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract EventsV1 is EventMetadata {
    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

    //Details of the event
    struct Details {
        string name;
        string category;
        string description;
        uint256 tokenId;
        uint256 startTime;
        uint256 endTime;
        uint256 venueTokenId;
        bool payNow;
        address payable eventOrganiser;
        uint256 ticketPrice;
    }

    //mapping for getting event details
    mapping(uint256 => Details) public getInfo;

    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public tokenStatus;

    //mapping for featured events
    mapping(uint256 => bool) public featuredEvents;

    //mapping for favourite events
    mapping(address => mapping(uint256 => bool)) public favouriteEvents;

    //mapping for whiteListed address
    mapping(address => bool) public whiteListedAddress;

    //map venue ID to eventId list which are booked in that venue
    //when new event are created, add that event id to this array
    mapping(uint256 => uint256[]) public eventsInVenue;

    //mapping for getting rent status
    mapping(address => mapping(uint256 => bool)) public rentStatus;

    //mappping for storing erc20 balance against eventTokenId
    mapping(uint256 => uint256) public balance;

    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    //mapping for storing tokenAddress against eventTokenId
    mapping(uint256 => address) public eventTokenAddress;

    //mapping for event start status
    mapping(uint256 => bool) public eventStartedStatus;

    //mapping for event cancel status
    mapping(uint256 => bool) public eventCanceledStatus;

    //block time
    uint256 public constant blockTime = 2;

    // Deviation Percentage
    uint256 private deviationPercentage;

    //venue contract address
    address private venueContract;

    //convesion contract address
    address private conversionContract;

    //ticket master contract address
    address private ticketMaster;

    //treasury contract
    address payable private treasuryContract;

    //isPublic true or false
    bool private isPublic;

    //platformFeePercent
    uint256 private platformFeePercent;

    //ticketCommission
    uint256 private ticketCommissionPercent;

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
        address ticketNFTAddress
    );

    ///@param tokenId Event tokenId
    ///@param description Event description
    event DescriptionUpdated(uint256 indexed tokenId, string description);

    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    event Timeupdated(
        uint256 indexed tokenId,
        uint256 startTime,
        uint256 endTime
    );

    ///@param tokenId Event tokenId
    event Featured(uint256 indexed tokenId, bool isFeatured);

    ///@param user User address
    ///@param tokenId Event tokenId
    ///@param isFavourite is event favourite(true or false)
    event Favourite(address user, uint256 indexed tokenId, bool isFavourite);

    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    event TokenWhitelisted(address indexed tokenAddress, bool status);

    ///@param eventTokenId event tokenId
    ///@param eventOrganiser EventOrganiser address
    event VenueBooked(uint256 indexed eventTokenId, address eventOrganiser);

    ///@param percentage deviationPercentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param whitelistedAddress users address
    ///@param status status of the address
    event WhiteList(address whitelistedAddress, bool status);

    ///@param venueContract venueContract address
    event VenueContractUpdated(address venueContract);

    // ///@param treasuryContract treasuryContract address
    event TreasuryContractUpdated(address treasuryContract);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);

    ///@param ticketMaster ticketMaster contract address
    event TicketMasterContractUpdated(address ticketMaster);

    ///@param isPublic isPublic true or false
    event EventStatusUpdated(bool isPublic);

    ///@param platformFeePercent platformFeePercent
    event PlatformFeeUpdated(uint256 platformFeePercent);

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@param eventTokenId event Token Id
    ///@param payNow pay venue fees now if(didn't pay earlier)
    event EventStarted(uint256 indexed eventTokenId, bool payNow);

    ///@param eventTokenId event Token Id
    event EventCanceled(uint256 indexed eventTokenId);

    //modifier for checking whitelistedUsers
    modifier onlyWhitelistedUsers() {
        require(
            whiteListedAddress[msg.sender] == true || isPublic == true,
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

    receive() external payable {}

    ///@notice Allows Admin to update deviation percentage
    ///@param _deviationPercentage deviationPercentage
    function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentageUpdated(_deviationPercentage);
    }

    ///@notice Add supported Erc-20 tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function whitelistTokenAddress(address tokenAddress, bool status)
        external
        onlyOwner
    {
        tokenStatus[tokenAddress] = status;
        emit TokenWhitelisted(tokenAddress, status);
    }

    ///@notice updates conversionContract address
    ///@param _conversionContract conversionContract address
    function updateConversionContract(address _conversionContract)
        external
        onlyOwner
    {
        require(
            _conversionContract.isContract(),
            "Events: Address is not a contract"
        );
        conversionContract = _conversionContract;
        emit ConversionContractUpdated(_conversionContract);
    }

    ///@notice updates conversionContract address
    ///@param _venueContract venueContract address
    function updateVenueContract(address _venueContract) external onlyOwner {
        require(
            _venueContract.isContract(),
            "Events: Address is not a contract"
        );
        venueContract = _venueContract;
        emit VenueContractUpdated(_venueContract);
    }

    ///@notice updates treasuryContract address
    ///@param _treasuryContract treasuryContract address
    function updateTreasuryContract(address payable _treasuryContract)
        external
        onlyOwner
    {
        require(
            _treasuryContract.isContract(),
            "Events: Address is not a contract"
        );
        treasuryContract = _treasuryContract;
        emit TreasuryContractUpdated(_treasuryContract);
    }

    ///@notice updates ticketMaster address
    ///@param _ticketMaster ticketMaster address
    function updateticketMasterContract(address _ticketMaster)
        external
        onlyOwner
    {
        require(
            _ticketMaster.isContract(),
            "Events: Address is not a contract"
        );
        ticketMaster = _ticketMaster;
        emit TicketMasterContractUpdated(_ticketMaster);
    }

    ///@notice To update the event status(public or private events)
    ///@param _isPublic true or false
    function updateEventStatus(bool _isPublic) external onlyOwner {
        isPublic = _isPublic;
        emit EventStatusUpdated(_isPublic);
    }

    ///@notice updates platformFeePercent
    ///@param _platformFeePercent platformFeePercent
    function updatePlatformFee(uint256 _platformFeePercent) external onlyOwner {
        platformFeePercent = _platformFeePercent;
        emit PlatformFeeUpdated(_platformFeePercent);
    }

    ///@notice updates ticketCommissionPercent
    ///@param _ticketCommissionPercent ticketCommissionPercent
    function updateTicketCommission(uint256 _ticketCommissionPercent)
        external
        onlyOwner
    {
        ticketCommissionPercent = _ticketCommissionPercent;
        emit TicketCommissionUpdated(ticketCommissionPercent);
    }

    ///@notice Update event description
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event description
    ///@param tokenId Event tokenId
    ///@param description Event description
    function updateDescription(uint256 tokenId, string memory description)
        external
    {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(
            msg.sender == getInfo[tokenId].eventOrganiser,
            "Events: Address is not the event organiser address"
        );
        require(
            getInfo[tokenId].startTime > block.timestamp,
            "Events: Event is started"
        );
        getInfo[tokenId].description = description;
        emit DescriptionUpdated(tokenId, description);
    }

    function updateTime(uint256 tokenId, uint256[2] memory time) external {
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
            "Events: Venue is not available"
        );
        if(time[0] == getInfo[tokenId].startTime && time[1] == getInfo[tokenId].endTime)
        if(getInfo[tokenId].payNow == true) {
            uint256 feesPaid = balance[tokenId];
            (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
            venueTokenId,
            time[0],
            time[1]
            );
            address tokenAddress = IConversion(conversionContract).getBaseToken();
            if(feesPaid > estimatedCost - _platformFees) {
                IERC20(tokenAddress).transfer(getInfo[tokenId].eventOrganiser, feesPaid - estimatedCost - _platformFees);
                balance[tokenId] -=  (feesPaid - estimatedCost - _platformFees);

            }
            else {
                IERC20(tokenAddress).transferFrom(
                getInfo[tokenId].eventOrganiser,
                address(this),
                estimatedCost - _platformFees - feesPaid
                );
                balance[tokenId] += estimatedCost - _platformFees - feesPaid;
            }
        }
        
        getInfo[tokenId].startTime = time[0];
        getInfo[tokenId].endTime = time[1];
        emit Timeupdated(tokenId, time[0], time[1]);
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
            IVenue(getVenueContract())._exists(venueTokenId),
            "Events: Venue tokenId does not exists"
        );
        require(
            isVenueAvailable(_tokenId, venueTokenId, time[0], time[1], 0),
            "Events: Venue is not available"
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

        ticketNFTAddress[_tokenId] = ITicketMaster(ticketMaster)
            .deployTicketNFT(
                _tokenId,
                details[0],
                time,
                IVenue(getVenueContract()).getTotalCapacity(venueTokenId)
            );

        emit EventAdded(
            _tokenId,
            tokenCID,
            venueTokenId,
            payNow,
            isEventPaid,
            msg.sender,
            ticketPrice,
            ticketNFTAddress[_tokenId] /////////***************Change/////////////// */
        );
    }

    ///@notice Book venue
    ///@param eventTokenId eventTokenId
    function bookVenue(uint256 eventTokenId) internal {
        rentPaid(msg.sender, eventTokenId, true);
        emit VenueBooked(eventTokenId, msg.sender);
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
        uint256 rentalFees = IVenue(getVenueContract()).getRentalFeesPerBlock(
            venueTokenId
        ) * noOfBlocks;
        uint256 platformFees = (rentalFees * platformFeePercent) / 100;
        uint256 venueRentalCommission = IVenue(getVenueContract())
            .getVenueRentalCommission();
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
    ///@param isFavourite Event featured(true/false)
    function updateFavourite(uint256 tokenId, bool isFavourite) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        favouriteEvents[msg.sender][tokenId] = isFavourite;
        emit Favourite(msg.sender, tokenId, isFavourite);
    }

    ///@notice Called by admin to transfer the rent to venue owner
    ///@param eventTokenId event token id
    function complete(uint256 eventTokenId) external onlyOwner {
        require(_exists(eventTokenId), "Events: TokenId does not exist");
        require(
            block.timestamp >= getInfo[eventTokenId].endTime,
            "Events: Event not ended"
        );
        require(
            isEventCanceled(eventTokenId) == false,
            "Events: Event is canceled"
        );
        uint256 venueTokenId = getInfo[eventTokenId].venueTokenId;
        address tokenAddress = eventTokenAddress[eventTokenId];
        address payable venueOwner = IVenue(getVenueContract()).getVenueOwner(
            venueTokenId
        );
        if (tokenStatus[tokenAddress] == true) {
        (, , uint256 _venueRentalCommissionFees) = calculateRent(
            venueTokenId,
            getInfo[eventTokenId].startTime,
            getInfo[eventTokenId].endTime
        );
        uint256 venueRentalCommissionFees = IConversion(conversionContract)
            .convertFee(tokenAddress, _venueRentalCommissionFees);
        require(
            balance[eventTokenId] > 0,
            "Events: Funds already transferred"
        );
        if (tokenAddress == address(0)) {
            treasuryContract.transfer(venueRentalCommissionFees);
            venueOwner.transfer(
                balance[eventTokenId] - venueRentalCommissionFees
            );
        } else {
            IERC20(tokenAddress).transfer(
                treasuryContract,
                venueRentalCommissionFees
            );
            IERC20(tokenAddress).transfer(
                venueOwner,
                balance[eventTokenId] - venueRentalCommissionFees
            );
        }
        balance[eventTokenId] = 0;
        }
        // else {
        //     if(erc721tokenAddress[tokenAddress] == true) {
        //         require(nftBalance[eventTokenId] > 0, "Events: Nft already transferred");
        //         IERC721Upgradeable(tokenAddress).transferFrom(address(this), venueOwner, nftBalance[eventTokenId]);
        //         nftBalance[eventTokenId] = 0;
        //     }
        // }
    }

    ///@notice Admin can whiteList users
    ///@param _whitelistAddresses users address
    ///@param _status status of the address
    function updateWhitelist(
        address[] memory _whitelistAddresses,
        bool[] memory _status
    ) external onlyOwner {
        for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
            whiteListedAddress[_whitelistAddresses[i]] = _status[i];
            emit WhiteList(_whitelistAddresses[i], _status[i]);
        }
    }

    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
    }

    ///@notice Returns venue contract address
    function getVenueContract() public view returns (address) {
        return venueContract;
    }

    ///@notice Returns conversionContract address
    function getConversionContract() public view returns (address) {
        return conversionContract;
    }

    ///@notice Returns treasuryContract address
    function getTreasuryContract() public view returns (address) {
        return treasuryContract;
    }

    ///@notice Returns ticketMaster address
    function getTicketMasterContract() public view returns (address) {
        return ticketMaster;
    }

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns (uint256) {
        return deviationPercentage;
    }

    ///@notice Returns eventStatus
    function getEventStatus() public view returns (bool) {
        return isPublic;
    }

    ///@notice Returns platformFeePercent
    function getPlatformFeePercent() public view returns (uint256) {
        return platformFeePercent;
    }

    ///@notice Returns deviationPercentage
    function getTicketCommission() public view returns (uint256) {
        return ticketCommissionPercent;
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

    ///@notice To check amount is within deviation percentage
    ///@param feeAmount price of the ticket
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price * (deviationPercentage)) / (100)) &&
                feeAmount <= price + ((price * (deviationPercentage)) / (100)),
            "Events: Amount not within deviation percentage"
        );
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
            if (bookedEvents[i] == eventTokenId) continue;
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
        address tokenAddress = IConversion(conversionContract).getBaseToken();
        require(
            tokenStatus[tokenAddress] == true,
            "Events: PaymentToken Not Supported"
        );
        (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
            venueTokenId,
            startTime,
            endTime
        );
        uint256 platformFees = _platformFees;
        checkDeviation(feeAmount, estimatedCost);
        IERC20(tokenAddress).transferFrom(
            eventOrganiser,
            address(this),
            feeAmount - platformFees
        );
        IERC20(tokenAddress).transferFrom(
            eventOrganiser,
            treasuryContract,
            platformFees
        );
        balance[eventTokenId] = feeAmount - platformFees;
        eventTokenAddress[eventTokenId] = tokenAddress;
        bookVenue(eventTokenId);
    }

    ///@notice Start the event
    ///@param eventTokenId event Token Id
    ///@param venueFeeAmount fee of the venue
    function payEvent(uint256 eventTokenId, uint256 venueFeeAmount)
        external
        payable
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
            block.timestamp >= startTime && endTime > block.timestamp,
            "Events: Event not live"
        );
        require(msg.sender == eventOrganiser, "Events: Invalid Address");

        require(
            eventStartedStatus[eventTokenId] == false,
            "Events: Event already started"
        );
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
        }
        else {
            uint256 feesPaid = balance[eventTokenId];
            (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
            venueTokenId,
            startTime,
            endTime
            );
            address tokenAddress = IConversion(conversionContract).getBaseToken();
            if(feesPaid > estimatedCost - _platformFees) {
                IERC20(tokenAddress).transfer(eventOrganiser, feesPaid - estimatedCost - _platformFees);
                balance[eventTokenId] -=  (feesPaid - estimatedCost - _platformFees);

            }
            else {
                IERC20(tokenAddress).transferFrom(
                eventOrganiser,
                address(this),
                estimatedCost - _platformFees - feesPaid
                );
                balance[eventTokenId] += estimatedCost - _platformFees - feesPaid;
            }
        }
    
        eventStartedStatus[eventTokenId] = true;
        emit EventStarted(eventTokenId, payNow);
    }

    function startEvent(uint256 eventTokenId) external {
        require(_exists(eventTokenId), "Events: TokenId does not exist");
        (
            uint256 startTime,
            uint256 endTime,
            address eventOrganiser,
            bool payNow,
            ,

        ) = getEventDetails(eventTokenId);
        require(
            block.timestamp >= startTime && endTime > block.timestamp,
            "Events: Event not live"
        );
        require(msg.sender == eventOrganiser, "Events: Invalid Address");
        require(payNow == true, "Events: Fees not paid");
        emit EventStarted(eventTokenId, payNow);

    }

    ///@notice Cancel the event
    ///@param eventTokenId event Token Id
    function cancelEvent(uint256 eventTokenId) external {
        require(_exists(eventTokenId), "ManageEvent: TokenId does not exist");
        (
            uint256 startTime,
            uint256 endTime,
            address payable eventOrganiser,
            bool payNow,
            uint256 venueTokenId,

        ) = getEventDetails(eventTokenId);
        require(startTime > block.timestamp, "ManageEvent: Event started");
        require(msg.sender == eventOrganiser, "Events: Invalid Address");
        require(
            eventCanceledStatus[eventTokenId] == false,
            "ManageEvent: Event already canceled"
        );
        //call the complete event
        if (payNow == true) {
            address tokenAddress = eventTokenAddress[eventTokenId];
            (
                uint256 _estimatedCost,
                uint256 _platformFees,
                uint256 _venueRentalCommissionFees
            ) = calculateRent(venueTokenId, startTime, endTime);

            uint256 venueRentalCommissionFees = IConversion(conversionContract)
                .convertFee(tokenAddress, _venueRentalCommissionFees);
            uint256 platformFees = IConversion(conversionContract).convertFee(
                tokenAddress,
                _platformFees
            );
            uint256 estimatedCost = IConversion(conversionContract).convertFee(
                tokenAddress,
                _estimatedCost
            );
            if (tokenAddress == address(0)) {
                treasuryContract.transfer(
                    venueRentalCommissionFees + platformFees
                );
                eventOrganiser.transfer(
                    estimatedCost - venueRentalCommissionFees - platformFees
                );
            } else {
                IERC20(tokenAddress).transfer(
                    treasuryContract,
                    venueRentalCommissionFees + platformFees
                );
                IERC20(tokenAddress).transfer(
                    eventOrganiser,
                    estimatedCost - venueRentalCommissionFees - platformFees
                );
            }
            balance[eventTokenId] = 0;
        }
        //Return amount for venue fees if event ticket is cancelled
        //IEvents(getEventContract()).burn(eventTokenId);
        eventCanceledStatus[eventTokenId] = true;
        emit EventCanceled(eventTokenId);
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

    function isEventStarted(uint256 eventId) public view returns (bool) {
        return eventStartedStatus[eventId];
    }

    function isEventCanceled(uint256 eventId) public view returns (bool) {
        return eventCanceledStatus[eventId];
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
}
