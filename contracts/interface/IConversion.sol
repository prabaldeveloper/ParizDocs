// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/**
 * @dev Interface of the Price conversion contract
 */

interface IConversion {
    function convertFee(address paymentToken, uint256 mintFee)
        external
        view
        returns (uint256);

    function getBaseToken() external view returns(address);

}