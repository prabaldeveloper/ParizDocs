// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


import "../contracts/utils/VenueMetadata.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../contracts/interface/IConversion.sol";

///@title Add and book venue 
///@author Prabal Srivastav
///@notice Owner can add venues and event organisers can book it

contract Venue is VenueMetadata {

    struct VenueDetails{
        string name;
        string location;        
        uint256 tokenId;
        address venueOwner;
        uint256 totalCapacity;
        uint256 rentalAmount;
        string tokenCID;
    }
    
    mapping (uint256 => VenueDetails) public getVenueInfo;

    mapping(address => mapping(uint256 => bool)) public rent;

    // mapping(uint256 => uint256) public venueStart;

    // mapping(uint256 => uint256) public venueEnd;

    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public erc20TokenAddress;

    // Deviation Percentage
    uint256 public deviationPercentage;

    address conversionContract;


    ///@param tokenId Venue tokenId
    ///@param name Venue name
    ///@param location Venue location
    ///@param totalCapacity Venue totalCapacity
    ///@param rentalAmount Venue Fees
    ///@param tokenCID Venue tokenIPFSPath
    event VenueAdded(uint256 indexed tokenId, string name, string location, uint256 totalCapacity, uint256 rentalAmount, string tokenCID);

    ///@param tokenId Venue tokenId
    ///@param eventOrganiser eventOrganiser address
    event VenueBooked(uint256 indexed tokenId, address eventOrganiser, address tokenAddress);

    event ERC20TokenUpdatedVenue(address indexed tokenAddress, bool status);

    event DeviationPercentage(uint256 percentage);

    
    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");
        
    }

    ///@notice Adds venue
    ///@param _name Venue name
    ///@param _location Venue location
    ///@param _totalCapacity Venue totalCapacity
    ///@param _rentalAmount Venue rent
    ///@param _tokenCID Venue tokenIPFSPath
    function add(string memory _name, string memory _location, uint256 _totalCapacity, uint256 _rentalAmount, string memory _tokenCID) public  onlyOwner {

        require(_totalCapacity !=0 && _rentalAmount !=0, "Venue: Wrong inputs provided");
        uint256 _tokenId =_mintInternal(_tokenCID);
        getVenueInfo[_tokenId] = VenueDetails(
            _name,
            _location,
            _tokenId,
            msg.sender,
            _totalCapacity,
            _rentalAmount,
            _tokenCID
        );

        emit VenueAdded(_tokenId, _name, _location, _totalCapacity, _rentalAmount, _tokenCID);

    }

    function updateConversionContract(address _conversionContract) public onlyOwner {
        conversionContract = _conversionContract;

    }

    function getConversionContract() public view returns(address) {
        return conversionContract;
    }

    ///@notice Saves the status whether rent is paid or not
    ///@param eventOrganiser Event organiser address
    ///@param tokenId Venue tokenId
    ///@param _isRentPaid true or false
    function rentPaid(address eventOrganiser, uint256 tokenId, bool _isRentPaid) internal {
        rent[eventOrganiser][tokenId] = _isRentPaid;

    }

    function isRentPaid(address eventOrganiser, uint256 tokenId) external view returns(bool){
        return rent[eventOrganiser][tokenId];
    }

    function getRentalFees(uint256 tokenId) public view returns(uint256 _rentalFees){
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getVenueInfo[tokenId].rentalAmount;
    }
    
    function getTotalCapacity(uint256 tokenId) public view returns(uint256 _totalCapacity)  {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getVenueInfo[tokenId].totalCapacity;
    }

    /**
    * @notice To check amount is within deviation percentage.
    */

    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price*(deviationPercentage))/(100)) &&
                feeAmount <=
                price + ((price*(deviationPercentage))/(100)),
            "Venue: Amount not within deviation percentage"
        );
    }

    function checkFees(uint256 tokenId, address tokenAddress, uint256 feeAmount) internal {
        require(_exists(tokenId),"Venue: TokenId does not exist");
        require(erc20TokenAddress[tokenAddress] == true, "Venue: PaymentToken Not Supported");
        uint256 price = IConversion(conversionContract).convertFee(tokenAddress, getRentalFees(tokenId));

        if(tokenAddress!= address(0)) {
            checkDeviation(feeAmount, price);
            IERC20(tokenAddress).transferFrom(msg.sender, address(this), feeAmount);
        }

        else {
            checkDeviation(msg.value, price);
            transferFrom(msg.sender, address(this), msg.value);
        }
    }

    ///@notice Book venue
    ///@param tokenId Venue tokenId
    ///@param tokenAddress erc20 tokenAddress

    function bookVenue(uint256 tokenId, address tokenAddress, uint256 feeAmount) internal {
        checkFees(tokenId,tokenAddress, feeAmount);
        rentPaid(msg.sender,tokenId, true);        

        emit VenueBooked(tokenId, msg.sender, tokenAddress);
    }   

    ///@notice Supported tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)

    function updateErc20TokenAddress(address tokenAddress, bool status) public onlyOwner {
        erc20TokenAddress[tokenAddress] = status;

        emit ERC20TokenUpdatedVenue(tokenAddress, status);
        
    }

    /**
     * @notice Allows Admin to update deviation percentage
     */
    function adminUpdateDeviation(uint256 _deviationPercentage)
        public
        onlyOwner
    {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentage(_deviationPercentage);
    }
    
}       

