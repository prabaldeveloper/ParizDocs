// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./interface/IVenue.sol";
import "./utils/EventMetadata.sol";

import "../contracts/interface/IConversion.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events  is EventMetadata {

    address private venueContract;

    struct EventDetails{
        uint256 tokenId;
        string name;
        string _type;
        string description;
        uint256 startTime;
        uint256 endTime;
        string tokenIPFSPath;
        uint256 venueTokenId;
        address eventOrganiser;
        bool isEventPaid;
        uint256 ticketPrice;

    }
    //mapping for getting event details
    mapping (uint256 => EventDetails) public getEventDetails;

    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public erc20TokenAddress;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    //mapping for storing user's address who bought the ticket of an event
    mapping(uint256 => mapping(address => bool)) public ticketBoughtAddress;

    mapping(uint256 => bool) public featuredEvents;

     mapping(address => mapping(uint256 => bool)) public favouriteEvents;

     mapping(address => bool) public whiteListedAddress;

    //map venue ID to eventId list which are booked in that venue
    //when new event are created, add that event id to this array
    mapping(uint256 => uint256[]) public eventsInVenue;

    // Deviation Percentage
    uint256 public deviationPercentage;

    address conversionContract;

    ///@param tokenId Event tokenId
    ///@param name Event Name
    ///@param _type Event Type
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenIPFSPath Event tokenIPFSPath
    ///@param venueTokenId venueTokenId
    ///@param isEventPaid isEventPaid
    ///@param eventOrganiser address of the organiser
    ///@param ticketPrice ticketPrice of event
    event EventAdded(uint256 indexed tokenId, string name, string _type, string description, uint256 startTime, uint256 endTime,  string tokenIPFSPath,
    uint256 venueTokenId, bool isEventPaid, address eventOrganiser, uint256 ticketPrice);

    
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    event StartTimeupdated(uint256 indexed tokenId, uint256 startTime);

    ///@param tokenId Event tokenId
    ///@param tokenIPFSPath Event tokenIPFSPath
    event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenIPFSPath);

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

    modifier onlyWhitelistedUsers() {
        require(
            whiteListedAddress[msg.sender] == true,
            "Events : User address not whitelisted"
        );
        _;
    }

    modifier isValidTime(uint256 startTime, uint256 endTime) {
        require(
            startTime < endTime && startTime >= block.timestamp,
            "invalid time input"
        );
        _;
    }

    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
    
    }


    
    ///@notice Creates Event
    ///@dev Event organiser can call
    ///@dev - Check whether venue is available. 
    ///@dev - Check whether event is paid or free for users.
    ///@dev - Check whether venue fees is paid or it is mark as pay later.
    ///@dev - Save all the fields in the contract.
    ///@param name Event name
    ///@param _type Event type
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenIPFSPath Event tokenIPFSPath
    ///@param venueTokenId venueTokenId
    ///@param payNow pay venue fees now or later(true or false)
    ///@param isEventPaid isEventPaid(true or false)
    ///@param ticketPrice ticketPrice of event
    
    function add(string memory name, string memory _type, string memory description, uint256 startTime, uint256 endTime, string memory tokenIPFSPath,
    uint256 venueTokenId, bool payNow, address tokenAddress, uint256 venueFeeAmount, bool isEventPaid, uint256 ticketPrice) onlyWhitelistedUsers public payable {
        uint256 _tokenId = _mintInternal(tokenIPFSPath);
        require(isVenueAvailable(_tokenId, venueTokenId,startTime, endTime), "Events: Venue is not available");
        if(payNow == true) {
            IVenue(getVenueContract()).bookVenue(venueTokenId,tokenAddress,venueFeeAmount);
        }
        
        if(isEventPaid == false) {
            ticketPrice = 0;
        }
        getEventDetails[_tokenId] = EventDetails(
            _tokenId,
            name,
            _type,
            description,
            startTime,
            endTime,
            tokenIPFSPath,
            venueTokenId,
            msg.sender,
            isEventPaid,
            ticketPrice
        );

        emit EventAdded(_tokenId, name, _type,  description,  startTime,  endTime,   tokenIPFSPath,
        venueTokenId, isEventPaid, msg.sender,  ticketPrice);
        
    }

    function updateVenueContract(address _venueContract) public onlyOwner {
        venueContract = _venueContract;

    }

    function getVenueContract() public view returns(address) {
        return venueContract;
    }

    function updateConversionContract(address _conversionContract) public onlyOwner {
        conversionContract = _conversionContract;

    }

    function getConversionContract() public view returns(address) {
        return conversionContract;
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
            uint256 bookedStartTime = getEventDetails[bookedEvents[i]].startTime;
            uint256 bookedEndTime = getEventDetails[bookedEvents[i]].endTime;
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

    ///@notice Update event startTime
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not.
    ///@dev - Update the event startTime .
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime

    function updateStartTime(uint256 tokenId, uint256 startTime) public {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getEventDetails[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getEventDetails[tokenId].startTime > block.timestamp,"Events: Event is started");
        getEventDetails[tokenId].startTime = startTime;

        emit StartTimeupdated(tokenId, startTime);
        
    }
    
    ///@notice Update event IPFSPath
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event IPFSPath 
    ///@param tokenId Event tokenId
    ///@param tokenIPFSPath Event startTime

    function updateTokenIPFSPath(uint256 tokenId, string memory tokenIPFSPath) public {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getEventDetails[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getEventDetails[tokenId].startTime > block.timestamp,"Events: Event is started");
        getEventDetails[tokenId].tokenIPFSPath = tokenIPFSPath;

        emit TokenIPFSPathUpdated(tokenId, tokenIPFSPath);

    }

    ///@notice Update event description
    ///@dev Only event organiser can call
    ///@dev - Check whether event is started or not
    ///@dev - Update the event description
    ///@param tokenId Event tokenId
    ///@param description Event description

    function updateDescription(uint256 tokenId, string memory description) public {
        require(_exists(tokenId), "Events: TokenId does not exist");
        require(msg.sender == getEventDetails[tokenId].eventOrganiser, "Events: Address is not the event organiser address");
        require(getEventDetails[tokenId].startTime > block.timestamp,"Events: Event is started");
        getEventDetails[tokenId].description = description;

        emit DescriptionUpdated(tokenId, description);
        
    }

    /**
    * @notice To check amount is within deviation percentage.
    */

    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price*(deviationPercentage))/(100)) &&
                feeAmount <=
                price + ((price*(deviationPercentage))/(100)),
            "Events: Amount not within deviation percentage"
        );
    }

    
    function checkFees(uint256 tokenId, address tokenAddress, uint256 feeAmount) internal {
        address eventOrganiser = getEventDetails[tokenId].eventOrganiser;
        uint256 price = IConversion(conversionContract).convertFee(tokenAddress, getEventDetails[tokenId].ticketPrice);

        if(tokenAddress!= address(0)) {
            checkDeviation(feeAmount, price);
            IERC20(tokenAddress).transferFrom(msg.sender, eventOrganiser, feeAmount);
        }

        else {
            checkDeviation(msg.value, price);
            transferFrom(msg.sender, eventOrganiser, msg.value);
        }
    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param tokenId Event tokenId
    ///@param tokenAddress Token Address
    ///@param ticketPrice ticket Price

    //Q.  How to accomodate the guests in the venue
    function buyTicket(uint256 tokenId, address tokenAddress, uint256 ticketPrice) public payable {
    
        require(_exists(tokenId), "Events: TokenId does not exist");
        uint256 price = getEventDetails[tokenId].ticketPrice;
        require(price!=0, "Events: Event is free");
        require(erc20TokenAddress[tokenAddress] == true, "Events: PaymentToken Not Supported");
        uint256 eventTokenId = getEventDetails[tokenId].venueTokenId;
        uint256 totalCapacity = IVenue(getVenueContract()).getTotalCapacity(eventTokenId);
        require(ticketSold[tokenId] < totalCapacity, "Event: All tickets are sold");
        checkFees(tokenId, tokenAddress, ticketPrice);
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

    function join(uint256 tokenId) public {
         require(ticketBoughtAddress[tokenId][msg.sender] == true, "Events: No ticket");
         require(getEventDetails[tokenId].startTime >= block.timestamp,"Events: Event is started");

         emit Joined(tokenId, msg.sender); 
        
    }

    ///@notice Supported tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)

    function updateErc20TokenAddress(address tokenAddress, bool status) public onlyOwner {
        erc20TokenAddress[tokenAddress] = status;

        emit ERC20TokenUpdated(tokenAddress, status);
        
    }

    ///@notice Feature the event
    ///@dev Only admin can call
    ///@dev - Mark the event as featured
    ///@param tokenId Event tokenId
    ///@param isFeatured Event featured
    
    function featured(uint256 tokenId, bool isFeatured) public onlyOwner {
        require(_exists(tokenId), "Events: TokenId does not exist");
        featuredEvents[tokenId] = isFeatured;

        emit Featured(tokenId, isFeatured);

    }   

    function favourite(uint256 tokenId, bool isFavourite) public {
        require(_exists(tokenId), "Events: TokenId does not exist");
        favouriteEvents[msg.sender][tokenId] = isFavourite;
        emit Favourite(msg.sender , tokenId, isFavourite);

    }

    /**
     * @notice Allows Admin to update deviation percentage
     */
    function adminUpdateDeviation(uint256 _deviationPercentage)
        public
        onlyOwner
    {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentage(_deviationPercentage);
    }
    
    function updateWhitelist(
        address[] memory _whitelistAddresses,
        bool[] memory _status
    ) public onlyOwner {
        for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
            whiteListedAddress[_whitelistAddresses[i]] = _status[i];
            emit WhiteList(_whitelistAddresses[i], _status[i]);
        }
    }
}       
