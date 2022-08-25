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
        uint256 indexed tokenId,
        string indexed indexedTokenIPFSPath,
        string tokenIPFSPath
    );

        /**
     * @dev Stores hashes minted by a creator to prevent duplicates.
     */
    mapping(address => mapping(string => bool))
        private creatorToIPFSHashToMinted;

    event BaseURIUpdated(string baseURI);

    event NFTMetadataUpdated(string name, string symbol, string baseURI);
    event TokenCreatorUpdated(
        address indexed fromCreator,
        address indexed toCreator,
        uint256 indexed tokenId
    );

    /**
     * @notice Returns the IPFSPath to the metadata JSON file for a given NFT.
     */
    function getTokenCID(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

    /**
     * @notice Checks if the creator has already minted a given NFT.
     */
    function getHasCreatorMintedIPFSHash(
        address creator,
        string memory tokenIPFSPath
    ) public view returns (bool) {
        return creatorToIPFSHashToMinted[creator][tokenIPFSPath];
    }

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

    function _updateBaseURI(string memory _baseURI) internal {
        _setBaseURI(_baseURI);

        emit BaseURIUpdated(_baseURI);
    }

    /**
     * @dev The IPFS path should be the CID + file.extension, e.g.
     * `QmfPsfGwLhiJrU8t9HpG4wuyjgPo9bk8go4aQqSu9Qg4h7/metadata.json`
     */
    function _setTokenIPFSPath(uint256 tokenId, string memory _tokenIPFSPath)
        internal
    {
        // 46 is the minimum length for an IPFS content hash, it may be longer if paths are used
        require(
            bytes(_tokenIPFSPath).length >= 46,
            "NFT721Metadata: Invalid IPFS path"
        );
        require(
            !creatorToIPFSHashToMinted[msg.sender][_tokenIPFSPath],
            "NFT721Metadata: NFT was already minted"
        );

        creatorToIPFSHashToMinted[msg.sender][_tokenIPFSPath] = true;
        _setTokenURI(tokenId, _tokenIPFSPath);
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
    function _mintInternal(string memory _tokenIPFSPath)
        internal
        returns (uint256 tokenId)
    {
        tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        _updateTokenCreator(tokenId, payable(msg.sender));
        _setTokenIPFSPath(tokenId, _tokenIPFSPath);
        emit Minted(msg.sender, tokenId, _tokenIPFSPath, _tokenIPFSPath);
    }

    uint256[999] private ______gap;
}


