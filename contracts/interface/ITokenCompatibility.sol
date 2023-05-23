// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface ITokenCompatibility {
    function getPriceFeedAddress(
        string memory symbol
    ) external view returns (address);

    function getSwapPair(
        address _tokenAddress
    ) external view returns (address, address);

    function checkCompatibility(
        address _tokenAddress,
        string memory _symbol
    ) external view returns (bool);

    function isERC721(address nftAddress) external view returns (bool);
}