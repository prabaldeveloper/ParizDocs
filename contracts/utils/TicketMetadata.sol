// SPDX-License-Identifier: MIT OR Apache-2.0

pragma solidity ^0.8.0;

import "../utils/TicketERC721.sol";

/**
 * @notice A mixin to extend the OpenZeppelin metadata implementation.
 */
contract TicketMetadata is TicketERC721 {

    uint256 private nextTokenId;

    mapping(uint256 => address payable) private tokenIdToCreator;

    event Minted(
        address indexed creator,
        uint256 indexed tokenId
    );

    event TokenCreatorUpdated(
        address indexed fromCreator,
        address indexed toCreator,
        uint256 indexed tokenId
    );

    function _updateTokenCreator(uint256 tokenId, address payable creator)
        internal
    {
        emit TokenCreatorUpdated(tokenIdToCreator[tokenId], creator, tokenId);

        tokenIdToCreator[tokenId] = creator;
    }

    /**
     * @notice Returns the creator's address for a given tokenId.
     */
    function tokenCreator(uint256 tokenId)
        public
        view
        returns (address payable)
    {
        return tokenIdToCreator[tokenId];
    }


    /**
     * @notice Gets the tokenId of the next NFT minted.
     */
    function getNextTokenId() public view returns (uint256) {
        return nextTokenId;
    }

    /**
     * @dev Called once after the initial deployment to set the initial tokenId.
     */
    function _initializeNFT721Mint() internal onlyInitializing {
        // Use ID 1 for the first NFT tokenId
        nextTokenId = 1;
        //__ERC721_init();
    }

    /**
     * @notice Allows a creator to mint an NFT.
     */
    function _mintInternal(address userAddress)
        internal
        returns (uint256 tokenId)
    {
        tokenId = nextTokenId++;
        require(tokenId <= totalSupply(), "NFT721Metadata: Supply is reached");
        _mint(userAddress, tokenId);
        _updateTokenCreator(tokenId, payable(userAddress));
        emit Minted(userAddress, tokenId);
    }

    uint256[999] private ______gap;
}


