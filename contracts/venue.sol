// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "../contracts/utils/VenueMetadata.sol";

///@title Add and book venue 
///@author Prabal Srivastav
///@notice Owner can add venues and event organisers can book it

contract Venue is VenueMetadata {

    struct VenueDetails{
        string name;
        string location;        
        uint256 tokenId;
        address venueOwner;
        uint256 totalCapacity;
        uint256 rentalAmount;
        string tokenCID;

    }

    

    mapping (uint256 => VenueDetails) public getVenueInfo;

    mapping (uint256 => uint256[]) public venueBookTime;

    ///@param tokenId Venue tokenId
    ///@param name Venue name
    ///@param location Venue location
    ///@param totalCapacity Venue totalCapacity
    ///@param rentalAmount Venue Fees
    ///@param tokenCID Venue tokenIPFSPath
    event VenueAdded(uint256 indexed tokenId, string name, string location, uint256 totalCapacity, uint256 rentalAmount, string tokenCID);

    ///@param tokenId Venue tokenId
    ///@param eventOrganiser eventOrganiser address
    event VenueBooked(uint256 indexed tokenId, address eventOrganiser);

    
    ///@notice Adds venue
    ///@param _name Venue name
    ///@param _location Venue location
    ///@param _totalCapacity Venue totalCapacity
    ///@param _rentalAmount Venue rent
    ///@param _tokenCID Venue tokenIPFSPath
    ///@return tokenId tokenId of the venue
    function add(string memory _name, string memory _location, uint256 _totalCapacity, uint256 _rentalAmount, string memory _tokenCID) public returns(uint256 tokenId){

        require(_totalCapacity !=0 && _rentalAmount !=0, "Venue: Wrong inputs provided");
        uint256 _tokenId =_mintInternal(_tokenCID);
        getVenueInfo[_tokenId] = VenueDetails(
            _name,
            _location,
            _tokenId,
            msg.sender,
            _totalCapacity,
            _rentalAmount,
            _tokenCID
        );

        emit VenueAdded(_tokenId, _name, _location, _totalCapacity, _rentalAmount, _tokenCID);

    }

    ///@notice Check for venue availability
    ///@param tokenId Venue tokenId
    ///@param startTime Venue startTime
    ///@param endTime Venue endTime
    ///@return _isAvailable Returns true if available
    function isAvailable(uint256 tokenId, uint256 startTime, uint256 endTime) public returns(bool _isAvailable) {

    }
    
    ///@notice Book venue
    ///@param tokenId Venue tokenId
    ///@param startTime Venue startTime 
    ///@param endTime Venue endTime 
    function bookVenue(uint256 tokenId, uint256 startTime, uint256 endTime) internal {
        require(msg.value == getVenueInfo[tokenId].rentalAmount, "Venue: Rental Amount is less");
        transferFrom(msg.sender, address(this), msg.value);
        venueBookTime[tokenId].push(startTime);
        venueBookTime[tokenId].push(endTime);

        emit VenueBooked(tokenId,msg.sender);
        

    }   
    
}       
