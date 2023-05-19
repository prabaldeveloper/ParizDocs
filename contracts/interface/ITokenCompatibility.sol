// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface ITokenCompatibility {
    function getPriceFeedAddress(
        string memory symbol
    ) external view returns (address);

    function getSwapPair(
        address _tokenAddress
    ) external view returns (address, address);
}