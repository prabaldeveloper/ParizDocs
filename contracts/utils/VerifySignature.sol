// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

abstract contract VerifySignature {
    
    function getMessageHash(
        address ticketHolder,
        uint256 eventTokenId,
        uint256 ticketId
    ) public pure returns (bytes32) {
        if (ticketId == 0)
            return keccak256(abi.encodePacked(ticketHolder, eventTokenId));
        else
            return
                keccak256(
                    abi.encodePacked(ticketHolder, eventTokenId, ticketId)
                );
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
}
