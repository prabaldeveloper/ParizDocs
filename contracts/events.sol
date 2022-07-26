// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
///@title Create and join events
///@author Prabal Srivastav
///@notice Users can create event and join events

contract Events {
    event EventAdded(uint256 indexed tokenId, string name, string _type, string description, uint256 startTime, uint256 endTime,  string tokenIPFSPath,
    uint256 venueTokenId, uint256 venueFees, bool isPaid, address eventOrganiser);

    event StartTimeupdated(uint256 indexed tokenId, uint256 startTime);

    event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenIPFSPath);

    event DescriptionUpdated(uint256 indexed tokenId, string description);

    event Bought(uint256 indexed tokenId, address paymentToken, uint256 ticketPrice);

    event Joined(uint256 indexed tokenId, address indexed user);

    ///@notice Creates Event
    ///@param name Event Name
    ///@param _type Event Type
    ///@param description Event description
    ///@param startTime Event startTime
    ///@param endTime Event endTime
    ///@param tokenIPFSPath Event tokenIPFSPath
    ///@param venueTokenId venueTokenId
    ///@param venueFees venueFees
    ///@param isPaid isEventPaid
    ///@return tokenId Returns tokenId of the event
    function add(string memory name, string memory _type, string memory description, uint256 startTime, uint256 endTime, string memory tokenIPFSPath,
    uint256 venueTokenId, uint256 venueFees, bool isPaid) public returns(uint256 tokenId){

    }

    ///@notice Update event startDate
    ///@param tokenId Event tokenId
    ///@param startTime Event startTime
    function updateStartTime(uint256 tokenId, uint256 startTime) public {

    }
    
    ///@notice Update event IPFSPath
    ///@param tokenId Event tokenId
    ///@param tokenIPFSPath Event startTime
    function updateTokenIPFSPath (uint256 tokenId, string memory tokenIPFSPath) public {
        
    }

    ///@notice Update event description
    ///@param tokenId Event tokenId
    ///@param description Event description
    function updateDescription (uint256 tokenId, string memory description) public {
        
    }

    ///@notice Users can buy tickets
    ///@param tokenId Event tokenId
    ///@param paymentToken Token Address
    ///@param ticketPrice Ticket Price
    function buyTicket (uint256 tokenId, address paymentToken, uint256 ticketPrice) public payable {
        
    }

    ///@notice Users can join events
    ///@param tokenId Event tokenId
    function join(uint256 tokenId) public {
        
    }

    
    
}       
