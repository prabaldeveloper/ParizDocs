// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./utils/VenueMetadata.sol";
import "./utils/VenueStorage.sol";

///@notice Owner can add venues and event organisers can book it

contract Venue is VenueMetadata, VenueStorage {

    ///@param tokenId Venue tokenId
    ///@param name Venue name
    ///@param location Venue location
    ///@param category Venue category
    ///@param totalCapacity Venue totalCapacity
    ///@param rentPerBlock Venue Fees
    ///@param tokenCID Venue tokenCID
    ///@param owner venue onwer address
    event VenueAdded(
        uint256 indexed tokenId,
        string name,
        string location,
        string category,
        uint256 totalCapacity,
        uint256 rentPerBlock,
        string tokenCID,
        address owner
    );

    event VenueFeesUpdated(
        uint256 indexed tokenId,
        uint256 rentPerBlock
    );

    ///@param venueRentalCommission venueRentalCommission
    event VenueRentalCommissionUpdated(uint256 venueRentalCommission);

    ///@notice updates venueRentalCommission
    ///@param _venueRentalCommission venueRentalCommission
    function updateVenueRentalCommission(uint256 _venueRentalCommission)
        external
        onlyOwner
    {
        venueRentalCommission = _venueRentalCommission;
        emit VenueRentalCommissionUpdated(_venueRentalCommission);
    }

    ///@notice Adds venue
    ///@param _name Venue name
    ///@param _location Venue location
    ///@param _category Venue category
    ///@param _totalCapacity Venue totalCapacity
    ///@param _rentPerBlock Venue rent per block
    ///@param _tokenCID Venue tokenCID
    function add(
        string memory _name,
        string memory _location,
        string memory _category,
        uint256 _totalCapacity,
        uint256 _rentPerBlock,
        string memory _tokenCID
    ) external onlyOwner {
        require(
            _totalCapacity != 0 && _rentPerBlock != 0,
            "Venue: Invalid inputs"
        );
        uint256 _tokenId = _mintInternal(_tokenCID);
        getInfo[_tokenId] = Details(
            _name,
            _location,
            _category,
            _tokenId,
            payable(msg.sender),
            _totalCapacity,
            _rentPerBlock,
            _tokenCID
        );
        emit VenueAdded(
            _tokenId,
            _name,
            _location,
            _category,
            _totalCapacity,
            _rentPerBlock,
            _tokenCID,
            msg.sender
        );
    }

    function updateVenueFees(uint256 venueTokenId, uint256 rentPerBlock) external {
        require(msg.sender == getInfo[venueTokenId].owner, "Venue: Invalid owner");
        getInfo[venueTokenId].rentPerBlock = rentPerBlock;

        emit VenueFeesUpdated(venueTokenId, rentPerBlock);
    }

    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
    }

    ///@notice Returns rental fees of the venue
    ///@param tokenId Venue tokenId
    function getRentalFeesPerBlock(uint256 tokenId)
        public
        view
        returns (uint256 rentPerBlock)
    {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getInfo[tokenId].rentPerBlock;
    }

    ///@notice Returns rental fees of the venue
    ///@param tokenId Venue tokenId
    function getTotalCapacity(uint256 tokenId)
        public
        view
        returns (uint256 _totalCapacity)
    {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getInfo[tokenId].totalCapacity;
    }

    ///@notice Returns the venueRentalCommission
    function getVenueRentalCommission()
        public
        view
        returns (uint256 _venueRentalCommission)
    {
        return venueRentalCommission;
    }

    ///@notice Returns the venue owner
    ///@param tokenId Venue tokenId
    function getVenueOwner(uint256 tokenId)
        public
        view
        returns (address payable owner)
    {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getInfo[tokenId].owner;
    }
}
