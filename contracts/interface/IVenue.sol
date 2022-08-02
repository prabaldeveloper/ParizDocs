// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IVenue {
    function bookVenue(uint256 tokenId, uint256 startTime, uint256 endTime) external ;
    function getRentalFees(uint256 tokenId) external view returns(uint256 _rentalFees);
    function getTotalCapacity(uint256 tokenId) external view returns(uint256 _totalCapacity);
    function isAvailable(uint256 tokenId, uint256 startTime, uint256 endTime) external returns(bool _isAvailable);

}