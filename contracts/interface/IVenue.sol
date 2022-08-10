// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVenue {
    function bookVenue(address eventOrganiser, uint256 tokenId, address tokenAddress, uint256 feeAmount) external;
    function getRentalFees(uint256 tokenId) external view returns(uint256 _rentalFees);
    function getTotalCapacity(uint256 tokenId) external view returns(uint256 _totalCapacity);

}
