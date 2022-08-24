// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//import IERC721 file

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IVenue.sol";
import "./utils/EventMetadata.sol";
import "../contracts/interface/IConversion.sol";

///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events is EventMetadata {
    using AddressUpgradeable for address;
   
    //Details of the event
    struct Details {
        uint256 tokenId;
        string name;
        string category;
        string description;
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
    mapping(address => bool) public erc20TokenStatus;

    //mapping for getting supported erc721TokenAddress
    mapping(address => bool) public erc721tokenAddress;

    //mapping for getting status of the free pass tokenAddress
    mapping(address => uint256) public tokenFreePassStatus;

    //mapping for getting status of the tokenId
    mapping(address => mapping(uint256 => bool)) public freeTokenIdStatus;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    //mapping for storing user's address who bought the ticket of an event
    mapping(address=> mapping(uint256 => bool)) public ticketBoughtAddress;

    mapping(uint256 => address) public ticketTokenAddress;

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

    //mapping for storing tokenAddress against eventTokenId
    mapping(uint256 => address) public eventTokenAddress;

    //mappping for storing erc20 balance against eventTokenId
    mapping(uint256 => uint256) public balance;

    //mappping for storing erc721 balance against eventTokenId
    mapping(uint256 => uint256) public nftBalance;
    
    //block time
    uint256 constant blockTime = 2;

    // Deviation Percentage
    uint256 private deviationPercentage;

    //venue contract address
    address private venueContract;

    //convesion contract address
    address private conversionContract;

    //treasury contract
    address payable treasuryContract;

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
        address ticketTought,
        address tokenAddress
    );

    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    // event Timeupdated(
    //     uint256 indexed tokenId,
    //     uint256 startTime,
    //     uint256 endTime
    // );

    ///@param tokenId Event tokenId
    ///@param tokenCID Event tokenCID
    // event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenCID);

    ///@param tokenId Event tokenId
    ///@param description Event description
    // event DescriptionUpdated(uint256 indexed tokenId, string description);

    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address
    ///@param buyer buyer address
    event Bought(uint256 indexed tokenId, address paymentToken, address buyer);

    ///@param tokenId Event tokenId
    ///@param user User address
    event Joined(uint256 indexed tokenId, address indexed user);

    ///@param tokenId Event tokenId
    event Featured(uint256 indexed tokenId, bool isFeatured);

    ///@param user User address
    ///@param tokenId Event tokenId
    ///@param isFavourite is event favourite(true or false)
    event Favourite(address user, uint256 indexed tokenId, bool isFavourite);

    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    event ERC20TokenUpdated(address indexed tokenAddress, bool status);

    ///@param nftAddress erc-20 token Address
    ///@param status status of the address(true or false)
    ///@param freepassStatus free pass status of the nft
    event ERC721TokenUpdated(address indexed nftAddress, bool status, uint256 freepassStatus);

    ///@param percentage deviationPercentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param whitelistedAddress users address
    ///@param status status of the address
    event WhiteList(address whitelistedAddress, bool status);

    ///@param venueContract conversionContract address
    event VenueContractUpdated(address venueContract);

    ///@param treasuryContract treasuryContract address
    event TreasuryContractUpdated(address treasuryContract);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);

    ///@param isPublic isPublic true or false
    event EventStatusUpdated(bool isPublic);

    ///@param platformFeePercent platformFeePercent
    event PlatformFeeUpdated(uint256 platformFeePercent);

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@param eventTokenId event tokenId
    ///@param eventOrganiser EventOrganiser address
    event VenueBooked(uint256 indexed eventTokenId, address eventOrganiser);

    ///@param baseToken baseToken
    ///@param decimal decimal
    event BaseTokenUpdated(address indexed baseToken, uint256 decimal);

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
    function updateErc20TokenAddress(address tokenAddress, bool status)
        external
        onlyOwner
    {
        erc20TokenStatus[tokenAddress] = status;
        emit ERC20TokenUpdated(tokenAddress, status);
    }

    ///@notice Add supported Erc-721 tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param nftAddress Erc-721 token Address
    ///@param status status of the address(true or false)
    ///@param freepassStatus free pass status of the nft
    function updateERC721TokenAddress(address nftAddress, bool status, uint256 freepassStatus)
        external
        onlyOwner
    {
        erc721tokenAddress[nftAddress] = status;
        tokenFreePassStatus[nftAddress] = freepassStatus;
        emit ERC721TokenUpdated(nftAddress, status, freepassStatus);
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
        treasuryContract = _treasuryContract;
        emit TreasuryContractUpdated(_treasuryContract);
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
    function updateTicketCommission(uint256 _ticketCommissionPercent) external onlyOwner {
        ticketCommissionPercent = _ticketCommissionPercent;
        emit TicketCommissionUpdated(ticketCommissionPercent);
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
    ///@param payNow pay venue fees now or later(true or false)
    ///@param tokenAddress erc20 or erc721 tokenAddress
    ///@param tokenType erc20 or erc721 type
    ///@param venueFeeAmount fee of the venue
    ///@param isEventPaid isEventPaid(true or false)
    ///@param ticketToken address of the ticket token
    ///@param ticketPrice ticketPrice of event
    function add(
        string[3] memory details,
        uint256[2] memory time,
        string memory tokenCID,
        uint256 venueTokenId,
        bool payNow,
        address tokenAddress,
        string memory tokenType,
        uint256 venueFeeAmount,
        bool isEventPaid,
        address ticketToken,
        uint256 ticketPrice
    ) external payable onlyWhitelistedUsers {
        uint256 _tokenId = _mintInternal(tokenCID);
        require(IVenue(getVenueContract())._exists(venueTokenId), "Events: Venue tokenId does not exists");
        require(
            isVenueAvailable(_tokenId, venueTokenId, time[0], time[1]),
            "Events: Venue is not available"
         );
        require(erc20TokenStatus[ticketToken] == true || erc721tokenAddress[ticketToken] == true,  "Events: Payment token not supported");
        if (payNow == true) {
            checkVenueFees(
                venueTokenId,
                time[0],
                time[1],
                msg.sender,
                _tokenId,
                tokenAddress,
                tokenType,
                venueFeeAmount
            );        
        }
        if (isEventPaid == false) {
            ticketPrice = 0;
        }
        ticketTokenAddress[_tokenId] = ticketToken;
        getInfo[_tokenId] = Details(
            _tokenId,
            details[0],
            details[1],
            details[2],
            time[0],
            time[1],
            venueTokenId,
            payNow,
            payable(msg.sender),
            ticketPrice
        );
        emit EventAdded(
            _tokenId,
            tokenCID,
            venueTokenId,
            payNow,
            isEventPaid,
            msg.sender,
            ticketPrice,
            ticketToken,
            tokenAddress
        );
    }

    ///@notice Book venue
    ///@param eventTokenId eventTokenId
    function bookVenue(
        uint256 eventTokenId
    ) internal {
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

    ///@notice Update event startTime
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not.
    ///@dev - Update the event startTime .
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    // function updateTime(uint256 tokenId, uint256 startTime, uint256 endTime) external {
    //     require(_exists(tokenId), "Events: TokenId does not exist");
    //     require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
    //     require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
    //     uint256 venueTokenId = getInfo[tokenId].venueTokenId;
    //     require(isVenueAvailable(tokenId, venueTokenId, startTime, endTime) ,"Events: Venue is not available");
    //     getInfo[tokenId].startTime = startTime;
    //     getInfo[tokenId].endTime = endTime;
    //     emit Timeupdated(tokenId, startTime, endTime);
    // }

    ///@notice Update event IPFSPath
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event IPFSPath
    ///@param tokenId Event tokenId
    ///@param tokenCID Event tokenCID
    // function updateTokenCID(uint256 tokenId, string memory tokenCID) external {
    //     require(_exists(tokenId), "Events: TokenId does not exist");
    //     require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
    //     require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
    //     _setTokenIPFSPath(tokenId,tokenCID);
    //     getInfo[tokenId].tokenCID = tokenCID;
    //     emit TokenIPFSPathUpdated(tokenId, tokenCID);
    // }

    ///@notice Update event description
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event description
    ///@param tokenId Event tokenId
    ///@param description Event description
    // function updateDescription(uint256 tokenId, string memory description) external {
    //     require(_exists(tokenId), "Events: TokenId does not exist");
    //     require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
    //     require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
    //     getInfo[tokenId].description = description;
    //     emit DescriptionUpdated(tokenId, description);
    // }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param tokenId Event tokenId
    ///@param tokenAddress Token Address
    ///@param ticketPrice ticket Price
    ///@param tokenType ERC20 or ERC721
    function buyTicket(
        uint256 tokenId,
        address tokenAddress,
        uint256 ticketPrice,
        string memory tokenType
    ) external payable {
        require(_exists(tokenId), "Events: TokenId does not exist");
        uint256 price = getInfo[tokenId].ticketPrice;
        require(price != 0, "Events: Event is free");
        require(
            block.timestamp <= getInfo[tokenId].endTime,
            "Events: Event ended"
        );
        require(ticketTokenAddress[tokenId] == tokenAddress, "Events: Payment token not supported");
        require(
            ticketBoughtAddress[msg.sender][tokenId] == false,
            "Events: User already has bought ticket"
        );
        uint256 venueTokenId = getInfo[tokenId].venueTokenId;
        uint256 totalCapacity = IVenue(getVenueContract()).getTotalCapacity(
            venueTokenId
        );
        require(
            ticketSold[tokenId] < totalCapacity,
            "Event: All tickets are sold"
        );
        checkTicketFees(tokenId, tokenAddress, ticketPrice, tokenType);
        ticketBoughtAddress[msg.sender][tokenId] = true;
        ticketSold[tokenId]++;

        emit Bought(tokenId, tokenAddress, msg.sender);
    }

    ///@notice Users can join events
    ///@dev Public function
    ///@dev - Check whether event is started or not
    ///@dev - Check whether user has ticket if the event is paid
    ///@dev - Join the event
    ///@param tokenId Event tokenId
    function join(uint256 tokenId) external {
        require(
            ticketBoughtAddress[msg.sender][tokenId] == true,
            "Events: User has no ticket"
        );
        require(
            getInfo[tokenId].startTime >= block.timestamp,
            "Events: Event is started"
        );
        emit Joined(tokenId, msg.sender);
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
    function favourite(uint256 tokenId, bool isFavourite) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        favouriteEvents[msg.sender][tokenId] = isFavourite;
        emit Favourite(msg.sender, tokenId, isFavourite);
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

    ///@notice Called by admin to transfer the rent to venue owner 
    ///@param eventTokenId event token id
    function complete(uint256 eventTokenId) external onlyOwner {
        require(getInfo[eventTokenId].endTime > block.timestamp, "Events: Event not ended");
        uint256 venueTokenId = getInfo[eventTokenId].venueTokenId;
        address tokenAddress = eventTokenAddress[eventTokenId];
        address payable venueOwner = IVenue(getVenueContract()).getVenueOwner(venueTokenId);
        if(erc20TokenStatus[tokenAddress] == true) {
            (, , uint _venueRentalCommissionFees) = calculateRent(
                venueTokenId,
                getInfo[eventTokenId].startTime,
                getInfo[eventTokenId].endTime
            );
            uint256 venueRentalCommissionFees = IConversion(conversionContract).convertFee(tokenAddress, _venueRentalCommissionFees);
            require(balance[eventTokenId] - venueRentalCommissionFees> 0, "Events: Funds already transferred");
            if(tokenAddress == address(0)) {
                treasuryContract.transfer(venueRentalCommissionFees);
                venueOwner.transfer(balance[eventTokenId]- venueRentalCommissionFees);        
            }
            else {
                IERC20(tokenAddress).transfer(treasuryContract, venueRentalCommissionFees);
                IERC20(tokenAddress).transfer(venueOwner,balance[eventTokenId]- venueRentalCommissionFees);
            }
            balance[eventTokenId] -= venueRentalCommissionFees;
            balance[eventTokenId] -=  balance[eventTokenId];
        }
        else {
            if(erc721tokenAddress[tokenAddress] == true) {
                require(nftBalance[eventTokenId] > 0, "Events: Nft already transferred");
                IERC721Upgradeable(tokenAddress).transferFrom(address(this), venueOwner, nftBalance[eventTokenId]);
                nftBalance[eventTokenId] = 0;
            }
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

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns (uint256) {
        return deviationPercentage;
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
        uint256 endTime
    ) internal isValidTime(startTime, endTime) returns (bool _isAvailable) {
        uint256[] memory bookedEvents = eventsInVenue[venueTokenId];
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < bookedEvents.length; i++) {
            uint256 bookedStartTime = getInfo[bookedEvents[i]].startTime;
            uint256 bookedEndTime = getInfo[bookedEvents[i]].endTime;
            // skip for passed event
            if (currentTime >= bookedEndTime) continue;
            if (
                currentTime >= bookedStartTime && currentTime <= bookedEndTime
            ) {
                //check for ongoing event
                if (startTime >= bookedEndTime) {
                    continue;
                } else {
                    return false;
                }
            } else {
                //check for future event
                if (endTime <= bookedStartTime || startTime >= bookedEndTime) {
                    continue;
                } else {
                    return false;
                }
            }
        }
        eventsInVenue[venueTokenId].push(eventTokenId);
        return true;
    }

    ///@notice To check whether token is matic or any other token
    ///@param tokenId event tokenId
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount price of the ticket
    ///@param tokenType ERC20 or ERC721
    function checkTicketFees(
        uint256 tokenId,
        address tokenAddress,
        uint256 feeAmount,
        string memory tokenType
    ) internal {
        address payable eventOrganiser = getInfo[tokenId].eventOrganiser;
        if (
            keccak256(abi.encodePacked((tokenType))) ==
            keccak256(abi.encodePacked(("ERC20")))
        ) {
            require(
                erc20TokenStatus[tokenAddress] == true,
                "Events: TokenAddress not supported"
            );
            uint256 price = getInfo[tokenId].ticketPrice;
            if (tokenAddress != address(0)) {
                checkDeviation(feeAmount, price);
                uint256 ticketCommissionFee = (feeAmount * ticketCommissionPercent) / 100;
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    eventOrganiser,
                    feeAmount - ticketCommissionFee
                );
                IERC20(tokenAddress).transferFrom(
                    msg.sender, 
                    treasuryContract, 
                    ticketCommissionFee
                );

            } else {
                checkDeviation(msg.value, price);
                uint256 ticketCommissionFee = (msg.value * ticketCommissionPercent) / 100;
                (bool successOwner, ) = eventOrganiser.call{value: msg.value - ticketCommissionFee}("");
                require(successOwner, "Events: Transfer to venue owner failed");
                (bool successTreasury, ) = treasuryContract.call{value: ticketCommissionFee}("");
                require(successTreasury, "Events: Transfer to treasury contract failed");
            }
        } else {
            require(
                erc721tokenAddress[tokenAddress] == true,
                "Events: TokenAddress not supported"
            );
            if(tokenFreePassStatus[tokenAddress] == 0) {
                require(msg.sender == IERC721Upgradeable(tokenAddress).ownerOf(feeAmount), "Events: Caller is not the owner");
                IERC721Upgradeable(tokenAddress).transferFrom(msg.sender, eventOrganiser , feeAmount);
            }
            else {
                require(freeTokenIdStatus[tokenAddress][feeAmount] == false, "Events: Free token already used");
                freeTokenIdStatus[tokenAddress][feeAmount] = true;
            }
        }
    }

    ///@notice To check whether token is matic or any other token
    ///@param venueTokenId venueTokenId
    ///@param startTime event startTime
    ///@param endTime event endTime
    ///@param eventOrganiser event organiser address
    ///@param eventTokenId event tokenId
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount fee of the venue(rentalFee + platformFee)
    function checkVenueFees(
        uint256 venueTokenId,
        uint256 startTime,
        uint256 endTime,
        address eventOrganiser,
        uint256 eventTokenId,
        address tokenAddress,
        string memory tokenType,
        uint256 feeAmount
    ) internal {
        if (
            keccak256(abi.encodePacked((tokenType))) ==
            keccak256(abi.encodePacked(("ERC20")))
        )  {
            require(
                erc20TokenStatus[tokenAddress] == true,
                "Events: PaymentToken Not Supported"
            );
            (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
                venueTokenId,
                startTime,
                endTime
            );
            uint256 price = IConversion(conversionContract).convertFee(
                tokenAddress,
                estimatedCost
            );
            uint256 platformFees = IConversion(conversionContract).convertFee(
                tokenAddress,
                _platformFees
            );
            if (tokenAddress != address(0)) {
                checkDeviation(feeAmount, price);
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
            } else {
                checkDeviation(msg.value, price);
                (bool successOwner, ) = address(this).call{
                    value: msg.value - platformFees
                }("");
                require(successOwner, "Events: Transfer to venue owner failed");
                (bool successTreasury, ) = treasuryContract.call{
                    value: platformFees
                }("");
                require(
                    successTreasury,
                    "Events: Transfer to treasury contract failed"
                );
                balance[eventTokenId] = msg.value - platformFees;
            }
        }
        else {
             require(
                erc721tokenAddress[tokenAddress] == true,
                "Events: TokenAddress not supported"
            );
             if(tokenFreePassStatus[tokenAddress] == 0) {
                require(msg.sender == IERC721Upgradeable(tokenAddress).ownerOf(feeAmount), "Events: Caller is not the owner");
                IERC721Upgradeable(tokenAddress).transferFrom(msg.sender, address(this) , feeAmount);
                nftBalance[eventTokenId] = feeAmount;
            }
            else {
                require(freeTokenIdStatus[tokenAddress][feeAmount] == false, "Events: Free token already used");
                freeTokenIdStatus[tokenAddress][feeAmount] = true;
            }
        }
        eventTokenAddress[eventTokenId] = tokenAddress;
        bookVenue(eventTokenId);
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
            address eventOrganiser,
            bool payNow,
            uint256 venueTokenId
        )
    {
        return (
            getInfo[tokenId].startTime,
            getInfo[tokenId].endTime,
            getInfo[tokenId].eventOrganiser,
            getInfo[tokenId].payNow,
            getInfo[tokenId].venueTokenId
        );
    }

    // function updateBaseToken(address _baseToken) external onlyOwner {
    //     baseToken = _baseToken;
    //     decimal = IERC20Metadata(_baseToken).decimals();
    //     emit BaseTokenUpdated(baseToken, decimal);
    // }
}
