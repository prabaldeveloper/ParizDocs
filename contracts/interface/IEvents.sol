// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEvents {
    function _exists(uint256 eventTokenId) external view returns(bool);
    function getEventDetails(uint256 tokenId) external view returns(uint256, uint256, address, bool, uint256, uint256);
    function burn(uint256 tokenId) external;
    function getConversionContract() external view returns (address);
    function getVenueContract() external view returns (address);
    function getDeviationPercentage() external view returns (uint256);
    function getTreasuryContract() external view returns (address);
    
}
