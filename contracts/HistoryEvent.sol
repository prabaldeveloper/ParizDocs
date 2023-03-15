// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
 
import "./access/Ownable.sol";

abstract contract VerifySignature1 {
    function getMessageHash(
        address userAddress,
        uint256 eventTokenId,
        string memory data
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(userAddress, eventTokenId, data)
            );
    }

    function recoverSigner(bytes32 hash, bytes memory signature)
        public
        pure
        returns (address)
    {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            ),
            v,
            r,
            s
        );
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }
}

contract History is Ownable, VerifySignature1 {

    address public signerAddress;

    event DataAdded(
        address indexed userAddress,
        uint256 indexed tokenId,
        string data
    );

    mapping(uint256 => string[]) internal eventTokenIdToData;
    mapping(address => string[]) internal userData;

    function initialize() public initializer() {
        Ownable.ownable_init();
    }

    function addSigner(address _signerAddress) public onlyOwner {
        require(_signerAddress != address(0), "Invalid address");
        signerAddress = _signerAddress;
    }

    function addData(
        bytes[] memory signature,
        address[] memory userAddress,
        uint256[] memory eventTokenId,
        string[] memory data
    ) public {
        for(uint256 i = 0 ; i < signature.length; i++) {
            require(VerifySignature1.recoverSigner(
                VerifySignature1.getMessageHash(userAddress[i], eventTokenId[i], data[i]), signature[i]) == signerAddress,
                "Signature does not match"
            );

            eventTokenIdToData[eventTokenId[i]].push(data[i]);
            userData[userAddress[i]].push(data[i]);
            emit DataAdded(userAddress[i], eventTokenId[i], data[i]);
        }
    }

    function getEventData(uint256 eventTokenId) public view returns(string[] memory) {
        return eventTokenIdToData[eventTokenId];
    }

    function getUserData(address userAddress) public view returns(string[] memory) {
        return userData[userAddress];
    }
}
