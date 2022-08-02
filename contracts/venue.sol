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

    mapping(address => mapping(uint256 => bool)) public rent;

    mapping(uint256 => uint256) public venueStart;

    mapping(uint256 => uint256) public venueEnd;


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

    
    function initialize() public initializer {
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
        
    }

    ///@notice Adds venue
    ///@param _name Venue name
    ///@param _location Venue location
    ///@param _totalCapacity Venue totalCapacity
    ///@param _rentalAmount Venue rent
    ///@param _tokenCID Venue tokenIPFSPath
    function add(string memory _name, string memory _location, uint256 _totalCapacity, uint256 _rentalAmount, string memory _tokenCID) public  onlyOwner {

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

    function isAvailable(uint256 tokenId, uint256 startTime, uint256 endTime) internal returns(bool _isAvailable) {
        //Under Discussion
        
        if(venueStart[tokenId] == 0 && venueEnd[tokenId] == 0) {
            venueStart[tokenId] = startTime;
            venueEnd[tokenId] = endTime;
            return true;
        }

        else if(startTime > venueStart[tokenId] && startTime < venueEnd[tokenId]) {
            return false;
        }

        else if(endTime > venueStart[tokenId] && endTime < venueEnd[tokenId])
            return false;
        
        else {
            venueStart[tokenId] = startTime;
            venueEnd[tokenId] = endTime;
            return true;
        }
     
    }

    ///@notice Saves the status whether rent is paid or not
    ///@param eventOrganiser Event organiser address
    ///@param tokenId Venue tokenId
    ///@param _isRentPaid true or false
    function rentPaid(address eventOrganiser, uint256 tokenId, bool _isRentPaid) internal {
        rent[eventOrganiser][tokenId] = _isRentPaid;

    }

    function isRentPaid(address eventOrganiser, uint256 tokenId) external view returns(bool){
        return rent[eventOrganiser][tokenId];
    }

    function getRentalFees(uint256 tokenId) public view returns(uint256 _rentalFees){
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getVenueInfo[tokenId].rentalAmount;
    }
    
    function getTotalCapacity(uint256 tokenId) public view returns(uint256 _totalCapacity)  {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getVenueInfo[tokenId].totalCapacity;
    }

    ///@notice Book venue
    ///@param tokenId Venue tokenId
    function bookVenue(uint256 tokenId) internal {
        require(_exists(tokenId),"Venue: TokenId does not exist");
        
        require(msg.value == getVenueInfo[tokenId].rentalAmount, "Venue: Rental Amount is less");
        transferFrom(msg.sender, address(this), msg.value);
        rentPaid(msg.sender,tokenId, true);        

        emit VenueBooked(tokenId,msg.sender);
        

    }   
    
}       
