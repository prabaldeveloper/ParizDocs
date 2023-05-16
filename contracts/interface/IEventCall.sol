
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IEventCall {
    function completeInternal(uint256 eventTokenId,address eventOrganiser) external;
    function startEventInternal(uint256 eventTokenId, address eventOrganiser) external;
    function endInternal(uint256 eventTokenId, address eventOrganiser) external;
    function cancelEventInternal(uint256 eventTokenId, address eventOrganiser) external;
    function joinInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 joinTime) external view returns(address);
    function userExitEventInternal(bytes memory signature, address ticketHolder, uint256 eventTokenId, uint256 ticketId, uint256 exitTime) external view returns(address);
    function updateEventInternal(uint256 eventTokenId, address eventOrganiser) external view returns(uint256) ;
    function calculateRentInternal(uint256 venueTokenId, uint256 noOfBlocks) external view returns (uint256 _estimatedCost, uint256 _platformFees, uint256 _venueRentalCommissionFees);
    function isVeneAvailableInternal(uint256 eventTokenId, uint256 startTime, uint256 endTime, uint256[] memory bookedEvents) external view 
    returns(bool);
    

}