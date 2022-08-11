// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../contracts/utils/VenueMetadata.sol";
import "../contracts/interface/IConversion.sol";

///@title Add and book venue 
///@author Prabal Srivastav
///@notice Owner can add venues and event organisers can book it

contract Venue is VenueMetadata {

    ///Details of the venue
    struct Details{
        string name;
        string location;   
        string category;     
        uint256 tokenId;
        address payable owner;
        uint256 totalCapacity;
        uint256 rentalAmount;
        string tokenCID;
    }
    
    //mapping for getting venue details
    mapping (uint256 => Details) public getInfo;

    //mapping for getting rent status
    mapping(address => mapping(uint256 => bool)) public rentStatus;

    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public erc20TokenStatus;

    // Deviation Percentage
    uint256 private deviationPercentage;

    //conversion contract
    address private conversionContract;

    ///@param tokenId Venue tokenId
    ///@param name Venue name
    ///@param location Venue location
    ///@param category Venue category
    ///@param totalCapacity Venue totalCapacity
    ///@param rentalAmount Venue Fees
    ///@param tokenCID Venue tokenCID
    ///@param owner venue onwer address
    event VenueAdded(uint256 indexed tokenId, string name, string location, string category, uint256 totalCapacity, uint256 rentalAmount, string tokenCID, address owner);

    ///@param tokenId Venue tokenId
    ///@param eventOrganiser EventOrganiser address
    event VenueBooked(uint256 indexed tokenId, address eventOrganiser);

    ///@param tokenAddress tokenAddress of the token
    ///@param status status of the token
    event ERC20TokenUpdated(address indexed tokenAddress, bool status);

    ///@param percentage percentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);
    
    receive() external payable    
    {  }

    ///@notice Allows Admin to update deviation percentage
    ///@param _deviationPercentage deviationPercentage
    function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentageUpdated(_deviationPercentage);
    }
    
    ///@notice Supported tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function updateErc20TokenAddress(address tokenAddress, bool status) external onlyOwner {
        erc20TokenStatus[tokenAddress] = status;
        emit ERC20TokenUpdated(tokenAddress, status);
        
    }

    ///@notice updates conversionContract address
    ///@param _conversionContract conversionContract address
    function updateConversionContract(address _conversionContract) external onlyOwner {
        conversionContract = _conversionContract;
        emit ConversionContractUpdated(_conversionContract);
    }

    ///@notice Book venue
    ///@param tokenId Venue tokenId
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount fee of the venue
    function bookVenue(address eventOrganiser, uint256 tokenId, address tokenAddress, uint256 feeAmount) external payable {
        checkPaymentToken(eventOrganiser,tokenId,tokenAddress, feeAmount);
        rentPaid(eventOrganiser,tokenId, true);        
        emit VenueBooked(tokenId, eventOrganiser);
    } 

    ///@notice Adds venue
    ///@param _name Venue name
    ///@param _location Venue location
    ///@param _category Venue category
    ///@param _totalCapacity Venue totalCapacity
    ///@param _rentalAmount Venue rent
    ///@param _tokenCID Venue tokenCID
    function add(string memory _name, string memory _location, string memory _category, uint256 _totalCapacity, uint256 _rentalAmount, string memory _tokenCID) external onlyOwner {

        require(_totalCapacity !=0 && _rentalAmount !=0, "Venue: Invalid inputs");
        uint256 _tokenId =_mintInternal(_tokenCID);
        getInfo[_tokenId] = Details(
            _name,
            _location,
            _category,
            _tokenId,
            payable(msg.sender),
            _totalCapacity,
            _rentalAmount,
            _tokenCID
        );

        emit VenueAdded(_tokenId, _name, _location, _category, _totalCapacity, _rentalAmount, _tokenCID, msg.sender);

    }

    function initialize() public initializer {
        Ownable.ownable_init();
        _initializeNFT721Mint();
        _updateBaseURI("https://ipfs.io/ipfs/");  
    }

    ///@notice Returns conversionContract address
    function getConversionContract() public view returns(address) {
        return conversionContract;
    }

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns(uint256) {
        return deviationPercentage;
    }

    ///@notice Returns rental fees of the venue
    ///@param tokenId Venue tokenId
    function getRentalFees(uint256 tokenId) public view returns(uint256 _rentalFees){
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getInfo[tokenId].rentalAmount;
    }

    ///@notice Returns true if rent paid
    ///@param eventOrganiser eventOrganiser address
    ///@param tokenId Venue tokenId
    function isRentPaid(address eventOrganiser, uint256 tokenId) public view returns(bool){
        return rentStatus[eventOrganiser][tokenId];
    }

    ///@notice Returns rental fees of the venue
    ///@param tokenId Venue tokenId
    function getTotalCapacity(uint256 tokenId) public view returns(uint256 _totalCapacity)  {
        require(_exists(tokenId), "Venue: TokenId does not exist");
        return getInfo[tokenId].totalCapacity;
    }

    ///@notice To check amount is within deviation percentage
    ///@param feeAmount fee of the venue
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price*(deviationPercentage))/(100)) &&
                feeAmount <=
                price + ((price*(deviationPercentage))/(100)),
            "Venue: Amount not within deviation percentage"
        );
    }
    
    ///@notice Saves the status whether rent is paid or not
    ///@param eventOrganiser Event organiser address
    ///@param tokenId Venue tokenId
    ///@param _isRentPaid true or false
    function rentPaid(address eventOrganiser, uint256 tokenId, bool _isRentPaid) internal {
        rentStatus[eventOrganiser][tokenId] = _isRentPaid;

    }
    
    ///@notice To check whether token is matic or any other token
    ///@param tokenId Venue tokenId
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount fee of the venue
    function checkPaymentToken(address eventOrganiser, uint256 tokenId, address tokenAddress, uint256 feeAmount) internal {
        require(_exists(tokenId),"Venue: TokenId does not exist");
        require(erc20TokenStatus[tokenAddress] == true, "Venue: PaymentToken Not Supported");
        uint256 price = IConversion(conversionContract).convertFee(tokenAddress, getRentalFees(tokenId));
        address payable venueOwner = getInfo[tokenId].owner;
        if(tokenAddress!= address(0)) {
            checkDeviation(feeAmount, price);
            IERC20(tokenAddress).transferFrom(eventOrganiser, venueOwner, feeAmount);
        }
        else {
            checkDeviation(msg.value, price);
            (bool success, ) = venueOwner.call{value: msg.value}("");
            require(success, "Venue: Transfer failed.");
            
        }
    }       
}       

