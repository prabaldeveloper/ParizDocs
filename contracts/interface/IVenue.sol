// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVenue {
    function getTotalCapacity(uint256 tokenId) external view returns(uint256 _totalCapacity);
    function getVenueRentalCommission() external view returns(uint256 _venueRentalCommission);
    function getRentalFeesPerBlock(uint256 tokenId) external view returns(uint256 rentPerBlock);
    function getVenueOwner(uint256 tokenId) external view returns(address payable owner);
    function _exists(uint256 tokenId) external view returns (bool);
}
