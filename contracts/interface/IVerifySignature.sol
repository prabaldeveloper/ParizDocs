// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVerifySignature {
    function getMessageHash(
        address ticketHolder,
        uint256 eventTokenId,
        uint256 ticketId
    ) external pure returns (bytes32);

    function recoverSigner(bytes32 hash, bytes memory signature)
        external
        pure
        returns (address);
}
