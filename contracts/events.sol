// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "../contracts/utils/EventMetadata.sol";
import "../contracts/interface/Ivenue.sol";

///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events  is EventMetadata{

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
    mapping(address => mapping(uint256 => bool)) public ticketBoughtAddress;

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
    event Featured(uint256 indexed tokenId);

    event ERC20TokenUpdated(address indexed tokenAddress, bool status);

    

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
    uint256 venueTokenId, bool payNow, bool isEventPaid, uint256 ticketPrice) public payable {
        require(IVenue(getVenueContract()).isAvailable(venueTokenId,startTime, endTime), "Venue: Venue is not available");
        if(payNow == true) {
            IVenue(getVenueContract()).bookVenue(venueTokenId, startTime, endTime);
        }
        
        uint256 _tokenId = _mintInternal(tokenIPFSPath);
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

    function updateTokenIPFSPath (uint256 tokenId, string memory tokenIPFSPath) public {
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

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address

    function buyTicket(uint256 tokenId, address paymentToken) public payable {
        //Only matic is supported as of now
    
        require(_exists(tokenId), "Events: TokenId does not exist");
        uint256 ticketPrice = getEventDetails[tokenId].ticketPrice;
        require(ticketPrice!=0, "Events: Event is free");
        uint256 eventTokenId = getEventDetails[tokenId].venueTokenId;
        uint256 totalCapacity = IVenue(getVenueContract()).getTotalCapacity(eventTokenId);
        
        address eventOrganiser = getEventDetails[tokenId].eventOrganiser;
        require(ticketSold[tokenId] < totalCapacity, "Event: All tickets are sold");
        require(msg.value == ticketPrice, "Event: Ticket amount is less");
        transferFrom(msg.sender, eventOrganiser , msg.value);
        ticketBoughtAddress[msg.sender][tokenId] = true;
        ticketSold[tokenId]++;

        emit Bought(tokenId, paymentToken, msg.sender);

    
    }

    ///@notice Users can join events
    ///@dev Public function
    ///@dev - Check whether event is started or not
    ///@dev - Check whether user has ticket if the event is paid
    ///@dev - Join the event
    ///@param tokenId Event tokenId

    function join(uint256 tokenId) public {

        
        
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
    
    function featured(uint256 tokenId) public {

    }
    
}       
