// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVenue {
    function claimVenueFeesInternal(uint256 venueTokenId, address eventOrganiser) external view returns(address) ;
    function refundVenueFeesInternal(uint256 eventTokenId,  uint256 balance, address eventOrganiser) external returns(uint256, address);
    function getTotalCapacity(uint256 tokenId) external view returns(uint256 _totalCapacity);
    function getRentalFeesPerBlock(uint256 tokenId) external view returns(uint256 rentPerBlock);
    function getVenueOwner(uint256 tokenId) external view returns(address payable owner);
    function _exists(uint256 tokenId) external view returns (bool);
}
