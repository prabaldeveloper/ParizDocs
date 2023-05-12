
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ITicketController {
    function buyTicketInternal(uint256 buyTicketId,
        uint256 ticketTime
     ) external view returns(uint256);

     function checkTicketFeesInternal(
        uint256 feeAmount,
        uint256 actualPrice,
        address tokenAddress,
        uint256 buyTicketId,
        string memory tokenType,
        address userAddress
    ) external returns(uint256);

    function claimTicketFeesInternal(
        uint256 eventTokenId,
        address eventOrganiser
    ) external view returns(address);

    function refundTicketFeesInternal(uint256 eventTokenId) external view;
}