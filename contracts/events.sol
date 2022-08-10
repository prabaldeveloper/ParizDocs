// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IVenue.sol";
import "./utils/EventMetadata.sol";
import "../contracts/interface/IConversion.sol";


///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events  is EventMetadata {

    //Details of the event
    struct Details{
        uint256 tokenId;
        string name;
        string _type;
        string description;
        uint256 startTime;
        uint256 endTime;
        string tokenCID;
        uint256 venueTokenId;
        address payable eventOrganiser;
        bool isEventPaid;
        uint256 ticketPrice;
    }

    //mapping for getting event details
    mapping (uint256 => Details) public getInfo;

    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public erc20TokenStatus;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    //mapping for storing user's address who bought the ticket of an event
    mapping(uint256 => mapping(address => bool)) public ticketBoughtAddress;

    //mapping for featured events
    mapping(uint256 => bool) public featuredEvents;

    //mapping for favourite events
    mapping(address => mapping(uint256 => bool)) public favouriteEvents;

    //mapping for whiteListed address
    mapping(address => bool) public whiteListedAddress;

    //map venue ID to eventId list which are booked in that venue
    //when new event are created, add that event id to this array
    mapping(uint256 => uint256[]) public eventsInVenue;

    // Deviation Percentage
    uint256 private deviationPercentage;

    //venue contract address
    address private venueContract;
    
    //convesion contract address
    address private conversionContract;

    ///@param tokenId Event tokenId
    ///@param name Event name
    ///@param category Event category
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenCID Event tokenCID
    ///@param venueTokenId venueTokenId
    ///@param isEventPaid isEventPaid
    ///@param eventOrganiser address of the organiser
    ///@param ticketPrice ticketPrice of event
    event EventAdded(uint256 indexed tokenId, string name, string category, string description, uint256 startTime, uint256 endTime,  string tokenCID,
    uint256 venueTokenId, bool isVenueFeesPaid, bool isEventPaid, address eventOrganiser, uint256 ticketPrice);

    
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    event StartTimeupdated(uint256 indexed tokenId, uint256 startTime);

    ///@param tokenId Event tokenId
    ///@param tokenCID Event tokenCID
    event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenCID);

    ///@param tokenId Event tokenId
    ///@param description Event description
    event DescriptionUpdated(uint256 indexed tokenId, string description);

    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address
    ///@param buyer buyer address 
    event Bought(uint256 indexed tokenId, address paymentToken, address buyer);

    ///@param tokenId Event tokenId
    ///@param user User address
    event Joined(uint256 indexed tokenId, address indexed user);

    ///@param tokenId Event tokenId
    event Featured(uint256 indexed tokenId, bool isFeatured);

    event Favourite(address user, uint256 indexed tokenId, bool isFavourite);

    event ERC20TokenUpdated(address indexed tokenAddress, bool status);

    event DeviationPercentage(uint256 percentage);

    event WhiteList(address whiteListedAddress, bool _status);

    ///@param venueContract conversionContract address
    event VenueContractUpdated(address venueContract);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);

    //modifier for checking whitelistedUsers
    modifier onlyWhitelistedUsers() {
        require(
            whiteListedAddress[msg.sender] == true,
            "Events : User address not whitelisted"
        );
        _;
    }

    //modifier for checking valid time
    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "invalid time input"
        );
        _;
    }

    ///@notice Allows Admin to update deviation percentage
    ///@param _deviationPercentage deviationPercentage
    function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentage(_deviationPercentage);
    }

    ///@notice Supported tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function updateErc20TokenAddress(address tokenAddress, bool status) external onlyOwner {
        erc20TokenStatus[tokenAddress] = status;
        emit ERC20TokenUpdated(tokenAddress, status);
        
    }

    ///@notice updates conversionContract address
    ///@param _conversionContract conversionContract address
    function updateConversionContract(address _conversionContract) external onlyOwner {
        conversionContract = _conversionContract;
        emit ConversionContractUpdated(_conversionContract);
    }

    ///@notice updates conversionContract address
    ///@param _venueContract venueContract address
    function updateVenueContract(address _venueContract) external onlyOwner {
        venueContract = _venueContract;
        emit VenueContractUpdated(_venueContract);

    }
    
    ///@notice Creates Event
    ///@dev Event organiser can call
    ///@dev - Check whether venue is available. 
    ///@dev - Check whether event is paid or free for users.
    ///@dev - Check whether venue fees is paid or it is mark as pay later.
    ///@dev - Save all the fields in the contract.
    ///@param name Event name
    ///@param category Event category
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenCID Event tokenCID
    ///@param venueTokenId venueTokenId
    ///@param payNow pay venue fees now or later(true or false)
    ///@param isEventPaid isEventPaid(true or false)
    ///@param ticketPrice ticketPrice of event
    function add(string memory name, string memory category, string memory description, uint256 startTime, uint256 endTime, string memory tokenCID,
    uint256 venueTokenId, bool payNow, address tokenAddress, uint256 venueFeeAmount, bool isEventPaid, uint256 ticketPrice) onlyWhitelistedUsers external payable {
        uint256 _tokenId = _mintInternal(tokenCID);
        require(isVenueAvailable(_tokenId, venueTokenId,startTime, endTime), "Events: Venue is not available");
        if(payNow == true) {
            if(tokenAddress!= address(0)) 
                IVenue(getVenueContract()).bookVenue(msg.sender, venueTokenId, tokenAddress,venueFeeAmount);
            
            else {
            //     (bool success, ) = payable(getVenueContract()).call{
            //     value: msg.value,
            //     gas: 200000
            // }(abi.encodeWithSignature("bookVenue(address,uint256,address,uint256)",msg.sender, venueTokenId, tokenAddress, venueFeeAmount));
             //_callee.setXandSendEther{value: msg.value}(_x);
             IVenue(getVenueContract()).bookVenue{value: msg.value}(msg.sender, venueTokenId, tokenAddress, venueFeeAmount);
            }
        }
        
        if(isEventPaid == false) {
            ticketPrice = 0;
        }
        getInfo[_tokenId] = Details(
            _tokenId,
            name,
            category,
            description,
            startTime,
            endTime,
            tokenCID,
            venueTokenId,
            payable(msg.sender),
            isEventPaid,
            ticketPrice
        );

        emit EventAdded(_tokenId, name, category, description, startTime, endTime, tokenCID,
        venueTokenId, payNow, isEventPaid, msg.sender, ticketPrice);
        
    }

    ///@notice Update event startTime
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not.
    ///@dev - Update the event startTime .
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    function updateStartTime(uint256 tokenId, uint256 startTime) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
        getInfo[tokenId].startTime = startTime;
        emit StartTimeupdated(tokenId, startTime);    
    }
    
    ///@notice Update event IPFSPath
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event IPFSPath 
    ///@param tokenId Event tokenId
    ///@param tokenCID Event tokenCID
    function updateTokenCID(uint256 tokenId, string memory tokenCID) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
        _setTokenIPFSPath(tokenId,tokenCID);
        getInfo[tokenId].tokenCID = tokenCID;
        emit TokenIPFSPathUpdated(tokenId, tokenCID);
    }

    ///@notice Update event description
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event description
    ///@param tokenId Event tokenId
    ///@param description Event description
    function updateDescription(uint256 tokenId, string memory description) external {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getInfo[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getInfo[tokenId].startTime > block.timestamp,"Events: Event is started");
        getInfo[tokenId].description = description;
        emit DescriptionUpdated(tokenId, description); 
    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param tokenId Event tokenId
    ///@param tokenAddress Token Address
    ///@param ticketPrice ticket Price
    function buyTicket(uint256 tokenId, address tokenAddress, uint256 ticketPrice) external payable {
        require(_exists(tokenId), "Events: TokenId does not exist");
        uint256 price = getInfo[tokenId].ticketPrice;
        require(price!=0, "Events: Event is free");
        require(erc20TokenStatus[tokenAddress] == true, "Events: PaymentToken Not Supported");
        uint256 venueTokenId = getInfo[tokenId].venueTokenId;
        uint256 totalCapacity = IVenue(getVenueContract()).getTotalCapacity(venueTokenId);
        require(ticketSold[tokenId] < totalCapacity, "Event: All tickets are sold");
        checkPaymentToken(tokenId, tokenAddress, ticketPrice);
        ticketBoughtAddress[tokenId][msg.sender] = true;
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
         require(ticketBoughtAddress[tokenId][msg.sender] == true, "Events: No ticket");
         require(getInfo[tokenId].startTime >= block.timestamp,"Events: Event is started");

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
        emit Favourite(msg.sender , tokenId, isFavourite);
    }

    ///@notice Admin can whiteList users
    ///@param _whitelistAddresses users address
    ///@param _status status of the address
    function updateWhitelist(address[] memory _whitelistAddresses,
        bool[] memory _status) external onlyOwner {
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
    function getVenueContract() public view returns(address) {
        return venueContract;
    }

    ///@notice Returns conversionContract address
    function getConversionContract() public view returns(address) {
        return conversionContract;
    }

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns(uint256) {
        return deviationPercentage;
    }

    ///@notice To check amount is within deviation percentage
    ///@param feeAmount price of the ticket
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price*(deviationPercentage))/(100)) &&
                feeAmount <=
                price + ((price*(deviationPercentage))/(100)),
            "Events: Amount not within deviation percentage"
        );
    }

    ///@notice Check for venue availability
    ///@param eventTokenId eventTokenId
    ///@param venueTokenId Venue tokenId
    ///@param startTime Venue startTime
    ///@param endTime Venue endTime
    ///@return _isAvailable Returns true if available
    function isVenueAvailable(uint256 eventTokenId, uint256 venueTokenId, uint256 startTime, uint256 endTime) internal isValidTime(startTime, endTime) returns(bool _isAvailable) {
        uint256[] memory bookedEvents = eventsInVenue[venueTokenId];
        uint256 currentTime = block.timestamp;
        for(uint256 i = 0; i < bookedEvents.length; i++) {
            uint256 bookedStartTime = getInfo[bookedEvents[i]].startTime;
            uint256 bookedEndTime = getInfo[bookedEvents[i]].endTime;
            // skip for passed event
            if (currentTime >= bookedEndTime)
                continue;
            if (currentTime >= bookedStartTime && currentTime <= bookedEndTime) {  //check for ongoing event
                if (startTime >= bookedEndTime) {
                continue;
                } else {
                return false;
                }
            } else {  //check for future event
                if (endTime <= bookedStartTime || startTime >= bookedEndTime ) {
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
    function checkPaymentToken(uint256 tokenId, address tokenAddress, uint256 feeAmount) internal {
        address payable eventOrganiser = getInfo[tokenId].eventOrganiser;
        uint256 price = IConversion(conversionContract).convertFee(tokenAddress, getInfo[tokenId].ticketPrice);

        if(tokenAddress!= address(0)) {
            checkDeviation(feeAmount, price);
            IERC20(tokenAddress).transferFrom(msg.sender, eventOrganiser, feeAmount);
        }

        else {
            checkDeviation(msg.value, price);
            transferFrom(msg.sender, eventOrganiser, msg.value);
        }
    }
    
}       
