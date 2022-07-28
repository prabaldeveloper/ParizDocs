// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events {

    ///@param tokenId Event tokenId
    ///@param name Event Name
    ///@param _type Event Type
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenIPFSPath Event tokenIPFSPath
    ///@param venueTokenId venueTokenId
    ///@param venueFees venueFees
    ///@param isPaid isEventPaid
    ///@param eventOrganiser address of the organiser
    ///@param ticketPrice ticketPrice of event
    event EventAdded(uint256 indexed tokenId, string name, string _type, string description, uint256 startTime, uint256 endTime,  string tokenIPFSPath,
    uint256 venueTokenId, uint256 venueFees, bool isPaid, address eventOrganiser, uint256 ticketPrice);

    event StartTimeupdated(uint256 indexed tokenId, uint256 startTime);

    ///@param tokenId Event tokenId
    ///@param tokenIPFSPath Event tokenIPFSPath
    event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenIPFSPath);

    ///@param tokenId Event tokenId
    ///@param description Event description
    event DescriptionUpdated(uint256 indexed tokenId, string description);

    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address
    ///@param ticketPrice Ticket Price
    ///@param buyer buyer address 
    event Bought(uint256 indexed tokenId, address paymentToken, uint256 ticketPrice, address buyer);

    ///@param tokenId Event tokenId
    ///@param user User address
    event Joined(uint256 indexed tokenId, address indexed user);

    ///@notice Creates Event
    ///@dev Event organiser can call
    ///@param name Event name
    ///@param _type Event type
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenIPFSPath Event tokenIPFSPath
    ///@param venueTokenId venueTokenId
    ///@param venueFees venueFees
    ///@param payLater pay venue fees now or later(true or false)
    ///@param isEventPaid isEventPaid(true or false)
    ///@param ticketPrice ticketPrice of event
    ///@return tokenId Returns tokenId of the event

    function add(string memory name, string memory _type, string memory description, uint256 startTime, uint256 endTime, string memory tokenIPFSPath,
    uint256 venueTokenId, uint256 venueFees, bool payLater, bool isEventPaid, uint256 ticketPrice) public returns(uint256 tokenId){
        
        /**
        - Check whether venue is available.
        - Check whether event is paid or free for users.
        - Check whether venue fees is paid or it is mark as pay later.
        - Save all the fields in the contract.
        */          

    }

    ///@notice Update event startDate
    ///@dev Only event organiser can call
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    function updateStartTime(uint256 tokenId, uint256 startTime) public {
        
        /**
        - Check whether event is started or not.
        - Update the event startTime .
        */

    }
    
    ///@notice Update event IPFSPath
    ///@dev Only event organiser can call
    ///@param tokenId Event tokenId
    ///@param tokenIPFSPath Event startTime
    function updateTokenIPFSPath (uint256 tokenId, string memory tokenIPFSPath) public {

        /**
        - Check whether event is started or not
        - Update the event IPFSPath 
        */

    }

    ///@notice Update event description
    ///@dev Only event organiser can call
    ///@param tokenId Event tokenId
    ///@param description Event description
    function updateDescription (uint256 tokenId, string memory description) public {
        
        /**
        - Check whether event is started or not
        - Update the event description
        */

    }

    ///@notice Users can buy tickets
    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address
    ///@param ticketPrice Ticket Price
    function buyTicket (uint256 tokenId, address paymentToken, uint256 ticketPrice) public payable {
        
        /**
        - Check whether event is paid or free
        - Check whether user paid the price.
        - Map event tokenId with user address
        */
    }

    ///@notice Users can join events
    ///@param tokenId Event tokenId
    function join(uint256 tokenId) public {

        /**
        - Check whether event is started or not
        - Check whether user has ticket if event is paid
        - Join the event
        */
        
        
    }

    ///@notice Supported tokens for the payment
    ///@dev Only admin can call
    ///@param paymentToken erc-20 token Address
    ///@param status status of the address(true or false)
    function updateErc20TokenAddress(address paymentToken, bool status) public {
        
        /**
        - Update the status of paymentToken
        */

    }

    ///@notice Feature the event
    ///@dev Only admin can call
    ///@param tokenId Event tokenId
    function featured(uint256 tokenId) public {

        /**
        - Mark the event as featured
        */

    }
    
    
}       
