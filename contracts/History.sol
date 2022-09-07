// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract History {
    event DataAdded(
        address indexed userAddress,
        uint256 indexed tokenId,
        string data
    );
    mapping(uint256 => string) public tokenIdToData;
    mapping(address => string) public userData;

    function addData(
        address userAddress,
        uint256 eventTokenId,
        string memory data
    ) public {
        tokenIdToData[eventTokenId] = data;
        userData[userAddress] = data;
        emit DataAdded(userAddress, eventTokenId, data);
    }
}
