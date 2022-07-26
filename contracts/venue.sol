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
    function add(string memory name, string memory location, uint256 totalCapacity, uint256 fees, string memory tokenIPFSPath) public returns(uint256 tokenId){

    }

    ///@notice Check for venue availability
    ///@param tokenId venue tokenId
    ///@param startTime venue startTime
    ///@param endTime venue endTime
    ///@return _isAvailable returns true if available
    function isAvailable(uint256 tokenId, uint256 startTime, uint256 endTime) public returns(bool _isAvailable) {

    }
    
    ///@notice Book Venue
    ///@param tokenId venue tokenId
    ///@param venueFees venue Fees 
    function bookVenue(uint256 tokenId, uint256 venueFees) public {
        
    }   

    ///@notice Calculate rent for the venue
    ///@param tokenId venue tokenId
    ///@param startTime venue startTime
    ///@param endTime venue endTime
    ///@return rent returns the rent of the venue
    function calculateRent(uint256 tokenId, uint256 startTime, uint256 endTime) public returns(uint256 rent) {

    }
    
}       
