// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract History {
    
    event DataAdded(uint256 indexed tokenId, string data);
    mapping(uint256 => string) public tokenIdToData;

    function addData(uint256 eventTokenId, string memory data) public {
        tokenIdToData[eventTokenId] = data;
        emit DataAdded(eventTokenId, data);
    }
}