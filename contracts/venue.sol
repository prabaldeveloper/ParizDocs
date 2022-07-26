// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
///@title Add and book venue 
///@author Prabal Srivastav
///@notice Owner can add venues and event organisers can book it

contract Venue {
    
    ///@notice Adds venue
    ///@param name Venue name
    ///@param location Venue location
    ///@param totalCapacity Venue totalCapacity
    ///@param fees Venue Fees
    ///@param tokenIPFSPath Venue tokenIPFSPath
    ///@return tokenId of the venue
    function add(string memory name, string memory location, uint256 totalCapacity, uint256 fees, string memory tokenIPFSPath) public returns(uint256 tokenId){

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
    ///@param venueFees Venue fees 
    function bookVenue(uint256 tokenId, uint256 venueFees) public {
        
    }   

    ///@notice Calculate rent for the venue
    ///@param tokenId Venue tokenId
    ///@param startTime Venue startTime
    ///@param endTime Venue endTime
    ///@return rent Returns the rent of the venue
    function calculateRent(uint256 tokenId, uint256 startTime, uint256 endTime) public returns(uint256 rent) {

    }
    
}       
