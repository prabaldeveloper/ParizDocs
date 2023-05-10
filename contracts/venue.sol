// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./interface/IAdminFunctions.sol";
import "./interface/IEvents.sol";
import "./utils/VenueMetadata.sol";
import "./utils/VenueStorage.sol";

///@notice Owner can add venues and event organisers can book it

contract Venue is VenueMetadata, VenueStorage {
    using AddressUpgradeable for address;

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

    event ActiveStatusUpdated(
        uint256 indexed tokenId,
        bool active
    );

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "Venue:Address is not a contract"
        );
        adminContract = _adminContract;

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
        string memory _tokenCID,
        address payable _owner
    ) external onlyOwner {
        require(
            _totalCapacity != 0 && _rentPerBlock != 0 && _owner != address(0),
            "ERR_127:Venue:Invalid inputs"
        );
        uint256 _tokenId = _mintInternal(_owner, _tokenCID);
        isActive[_tokenId] = true;
        getInfo[_tokenId] = Details(
            _name,
            _location,
            _category,
            _tokenId,
            _owner,
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
            _owner
        );
    }

    function updateVenueFees(uint256 venueTokenId, uint256 rentPerBlock) external {
        require(msg.sender == getInfo[venueTokenId].owner, "Venue: Invalid owner");
        getInfo[venueTokenId].rentPerBlock = rentPerBlock;

        emit VenueFeesUpdated(venueTokenId, rentPerBlock);
    }

    function activeStatus(uint256 tokenId, bool _status) external onlyOwner{
        require(_exists(tokenId), "ERR_126:Venue:TokenId does not exist");
        isActive[tokenId] = _status;

        emit ActiveStatusUpdated(tokenId, _status);

    }

    function claimVenueFeesInternal(uint256 venueTokenId) external view returns(address) {
        require(
            _exists(venueTokenId),
            "Venue:Venue tokenId does not exists"
        );

        address venueOwner = getVenueOwner(venueTokenId);
        //check for msg.sender
        require(msg.sender == venueOwner, "Venue:Invalid Caller");
        return  venueOwner;
    }
    
    function refundVenueFeesInternal(uint256 eventTokenId, uint256 balance) external view returns(uint256, address) {
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == true,
            "ERR_109:Events:Event is not cancelled"
        );
        (
            uint256 startTime,
            uint256 endTime,
            address eventOrganiser,
            bool payNow,
            uint256 venueTokenId,

        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(eventTokenId);
        //check for msg.sender
        
        require(msg.sender == eventOrganiser, "ERR_103:Events:Address is not the event organiser address");
        require(payNow == true, "ERR_110:Events:Fees not paid");
         (, , uint256 venueRentalCommissionFees) = IEvents(IAdminFunctions(adminContract).getEventContract()).calculateRent(
            venueTokenId,
            startTime,
            endTime
        );
        require(balance > 0, "ERR_111:Events:Funds already transferred");
        address venueOwner = getVenueOwner(venueTokenId);
        return (venueRentalCommissionFees, venueOwner);

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
        require(_exists(tokenId), "ERR_126:Venue:TokenId does not exist");
        return getInfo[tokenId].rentPerBlock;
    }

    ///@notice Returns rental fees of the venue
    ///@param tokenId Venue tokenId
    function getTotalCapacity(uint256 tokenId)
        public
        view
        returns (uint256 _totalCapacity)
    {
        require(_exists(tokenId), "ERR_126:Venue:TokenId does not exist");
        return getInfo[tokenId].totalCapacity;
    }

    ///@notice Returns the venue owner
    ///@param tokenId Venue tokenId
    function getVenueOwner(uint256 tokenId)
        public
        view
        returns (address payable owner)
    {
        require(_exists(tokenId), "ERR_126:Venue:TokenId does not exist");
        return getInfo[tokenId].owner;
    }
}
