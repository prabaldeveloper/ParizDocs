// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./utils/AdminStorage.sol";
import "./access/Ownable.sol";
import "./interface/IManageEvent.sol";
import "./interface/IEvents.sol";
import "./interface/IConversion.sol";

contract AdminFunctions is Ownable, AdminStorage {

    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

    bytes4 public constant IID_IERC721 = type(IERC721).interfaceId;

    ///@param venueContract venueContract address
    event VenueContractUpdated(address venueContract);

    ///@param treasuryContract treasuryContract address
    event TreasuryContractUpdated(address treasuryContract);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);

    ///@param ticketMaster ticketMaster contract address
    event TicketMasterContractUpdated(address ticketMaster);

    ///@param isPublic isPublic true or false
    event EventStatusUpdated(bool isPublic);

    ///@param platformFeePercent platformFeePercent
    event PlatformFeeUpdated(uint256 platformFeePercent);

    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    event Erc20TokenUpdated(uint256 indexed eventTokenId, address indexed tokenAddress, bool status, string name, string symbol, uint256 decimal);

    event Erc721TokenUpdated(uint256 indexed eventTokenId,address indexed tokenAddress, bool status, uint256 freePassStatus,
    string name, string symbol, uint256 decimal);

    ///@param percentage deviationPercentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param whitelistedAddress users address
    ///@param status status of the address
    event WhiteList(address whitelistedAddress, bool status);

    ///@param signerAddress signer Address
    event signerAddressUpdated(address signerAddress);

    ///@param venueRentalCommission venueRentalCommission
    event VenueRentalCommissionUpdated(uint256 venueRentalCommission);

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@param baseTokenAddress base TokenAddress 
    event BaseTokenUpdated(address indexed baseTokenAddress, string name, string symbol, uint256 decimal);

    function initialize() public initializer {
         Ownable.ownable_init();
    }
    
    ///@notice Allows Admin to update deviation percentage
    ///@param _deviationPercentage deviationPercentage
    function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentageUpdated(_deviationPercentage);
    }

    ///@notice Add supported Erc-20 tokens for the payment at master level
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function whitelistErc20TokenAddress(address tokenAddress, bool status)
        external
        onlyOwner
    {
         erc20TokenAddress[tokenAddress] = status;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC20");
         emit Erc20TokenUpdated(0, tokenAddress, status, name, symbol, decimal);
    
    }

    ///@notice Add supported Erc-721 tokens for the payment at master level
    function whitelistErc721TokenAddress(address tokenAddress, bool status, uint256 freePassStatus) external onlyOwner{
        erc721TokenAddressMaster[tokenAddress] = status;
        tokenFreePassStatusMaster[tokenAddress] = freePassStatus;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC721");
        emit Erc721TokenUpdated(0, tokenAddress, status, freePassStatus, name, symbol, decimal);

    }

    ///@notice Add supported Erc-20 tokens for the payment at master level
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function whitelistErc20TokenAddressEvent(uint256 eventTokenId, address tokenAddress, bool status)
        external onlyOwner
    {
         require(IEvents(eventContract)._exists(eventTokenId), "AdminFunctions:TokenId does not exist");
         require(erc20TokenAddress[tokenAddress] == false, "AdminFunctions:Token is already whitelisted");
        //  (, , address eventOrganiser,
        //  , , ) =  IEvents(eventContract).getEventDetails(eventTokenId);
         //require(msg.sender == eventOrganiser, "AdminFunctions:Invalid Caller"); 
         erc20TokenAddressEvent[eventTokenId][tokenAddress] = status;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC20");
         emit Erc20TokenUpdated(eventTokenId, tokenAddress, status, name, symbol, decimal);
    }

    ///@notice Add supported Erc-721 tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param eventTokenId event tokenId
    ///@param tokenAddress erc-721 token Address
    ///@param status status of the address(true or false)
    ///@param freePassStatus 1 for free pass else 0
    
    function whitelistErc721TokenAddressEvent(uint256 eventTokenId, address tokenAddress, bool status, uint256 freePassStatus) external onlyOwner {
        require(IEvents(eventContract)._exists(eventTokenId), "AdminFunctions:TokenId does not exist");
        require(erc721TokenAddressMaster[tokenAddress] == false, "AdminFunctions:Token is already whitelisted");
        // (, , address eventOrganiser,
        // , , ) =  IEvents(eventContract).getEventDetails(eventTokenId);
        // require(msg.sender == eventOrganiser, "AdminFunctions:Invalid Caller");
        erc721TokenAddress[eventTokenId][tokenAddress] = status;
        tokenFreePassStatus[eventTokenId][tokenAddress] = freePassStatus;
         (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(tokenAddress, "ERC721");
        emit Erc721TokenUpdated(eventTokenId, tokenAddress, status, freePassStatus, name, symbol, decimal);(eventTokenId, tokenAddress, status, freePassStatus, name, symbol, decimal);

    }
    
    ///@notice updates conversionContract address
    ///@param _conversionContract conversionContract address
    function updateConversionContract(address _conversionContract)
        external
        onlyOwner
    {
        require(
            _conversionContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        conversionContract = _conversionContract;
        emit ConversionContractUpdated(_conversionContract);
    }

    ///@notice updates conversionContract address
    ///@param _venueContract venueContract address
    function updateVenueContract(address _venueContract) external onlyOwner {
        require(
            _venueContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        venueContract = _venueContract;
        emit VenueContractUpdated(_venueContract);
    }

    ///@notice updates treasuryContract address
    ///@param _treasuryContract treasuryContract address
    function updateTreasuryContract(address payable _treasuryContract)
        external
        onlyOwner
    {
        require(
            _treasuryContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        treasuryContract = _treasuryContract;
        emit TreasuryContractUpdated(_treasuryContract);
    }

    ///@notice updates ticketMaster address
    ///@param _ticketMaster ticketMaster address
    function updateTicketMasterContract(address _ticketMaster)
        external
        onlyOwner
    {
        require(
            _ticketMaster.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        ticketMaster = _ticketMaster;
        emit TicketMasterContractUpdated(_ticketMaster);
    }

    function updateManageEventContract(address _manageEvent) external onlyOwner {
        require(
            _manageEvent.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        manageEvent = _manageEvent;
    }

    ///@notice updates eventContract address
    ///@param _eventContract eventContract address
    function updateEventContract(address _eventContract) external onlyOwner {
        require(
            _eventContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        eventContract = _eventContract;
    }
    
    ///@notice updates eventCallContract address
    ///@param _eventCallContract eventContract address
    function updateEventCallContract(address _eventCallContract) external onlyOwner {
        require(
            _eventCallContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        eventCallContract = _eventCallContract;
    }

    ///@notice updates eventCallContract address
    ///@param _ticketControllerContract eventContract address
    function updateTicketControllerContract(address _ticketControllerContract) external onlyOwner {
        require(
            _ticketControllerContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        ticketControllerContract = _ticketControllerContract;
    }

    ///@notice updates eventContract address
    ///@param _signatureContract eventContract address
    function updateSignatureContract(address _signatureContract) external onlyOwner {
        require(
            _signatureContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        signatureContract = _signatureContract;
    }

    ///@notice To update the event status(public or private events)
    ///@param _isPublic true or false
    function updateEventStatus(bool _isPublic) external onlyOwner {
        isPublic = _isPublic;
        emit EventStatusUpdated(_isPublic);
    }

    ///@notice updates platformFeePercent
    ///@param _platformFeePercent platformFeePercent
    function updatePlatformFee(uint256 _platformFeePercent) external onlyOwner {
        platformFeePercent = _platformFeePercent;
        emit PlatformFeeUpdated(_platformFeePercent);
    }

    ///@notice updates signer Address
    ///@param _signerAddress eventContract address
    function updateSignerAddress(address _signerAddress) external onlyOwner {
        signerAddress = _signerAddress;
        emit signerAddressUpdated(_signerAddress);
    }

    ///@notice Admin can whiteList users
    ///@param _whitelistAddresses users address
    ///@param _status status of the address
    function updateWhitelist(
        address[] memory _whitelistAddresses,
        bool[] memory _status
    ) external onlyOwner {
        for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
            whiteListedAddress[_whitelistAddresses[i]] = _status[i];
            emit WhiteList(_whitelistAddresses[i], _status[i]);
        }
    }
    
    ///@notice updates venueRentalCommission
    ///@param _venueRentalCommission venueRentalCommission
    function updateVenueRentalCommission(uint256 _venueRentalCommission)
        external
        onlyOwner
    {
        venueRentalCommission = _venueRentalCommission;
        emit VenueRentalCommissionUpdated(_venueRentalCommission);
    }

    ///@notice updates ticketCommissionPercent
    ///@param _ticketCommissionPercent ticketCommissionPercent
    function updateTicketCommission(uint256 _ticketCommissionPercent)
        external
        onlyOwner
    {
        ticketCommissionPercent = _ticketCommissionPercent;
        emit TicketCommissionUpdated(ticketCommissionPercent);
    }

    ///@notice To check amount is within deviation percentage
    ///@param feeAmount price of the ticket
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        require(
            feeAmount >= price - ((price * (deviationPercentage)) / (100)) &&
                feeAmount <= price + ((price * (deviationPercentage)) / (100)),
            "ERR_129:AdminFunctions:Amount not within deviation percentage"
        );
    }

    ///@notice Returns venue contract address
    function getVenueContract() public view returns (address) {
        return venueContract;
    }

    ///@notice Returns conversionContract address
    function getConversionContract() public view returns (address) {
        return conversionContract;
    }

    ///@notice Returns treasuryContract address
    function getTreasuryContract() public view returns (address) {
        return treasuryContract;
    }

    ///@notice Returns ticketMaster address
    function getTicketMasterContract() public view returns (address) {
        return ticketMaster;
    }

    function getManageEventContract() public view returns (address) {
        return manageEvent;
    }
    
    function getEventContract() public view returns (address) {
        return eventContract;
    }

    function getTicketControllerContract() public view returns (address) {
        return ticketControllerContract;
    }

    function getEventCallContract() public view returns (address) {
        return eventCallContract;
    }

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns (uint256) {
        return deviationPercentage;
    }

    ///@notice Returns platformFeePercent
    function getPlatformFeePercent() public view returns (uint256) {
        return platformFeePercent;
    }

    ///@notice Returns the venueRentalCommission
    function getVenueRentalCommission()
        public
        view
        returns (uint256 _venueRentalCommission)
    {
        return venueRentalCommission;
    }

    function getTicketCommissionPercent() public view returns (uint256) {
        return ticketCommissionPercent;
    }

    ///@notice Returns eventStatus
    function getEventStatus() public view returns (bool) {
        return isPublic;
    }

    ///@notice Returns whitelisted status of erc20TokenAddress at master level
    function isErc20TokenWhitelisted(address tokenAddress) public view returns (bool) {
        return erc20TokenAddress[tokenAddress];
    }

    ///@notice Returns whitelisted status of erc721TokenAddress at master level
    function isErc721TokenWhitelisted(address tokenAddress) public view returns (bool) {
        return erc721TokenAddressMaster[tokenAddress];
    }

    ///@notice Returns freepass status of erc721TokenAddress at master level
    function isErc721TokenFreePass(address tokenAddress) public view returns (uint256) {
        return tokenFreePassStatusMaster[tokenAddress];
    }

    function isErc20TokenWhitelistedEvent(uint256 eventTokenId, address tokenAddress) public view returns(bool) {
        return erc20TokenAddressEvent[eventTokenId][tokenAddress];

    }
    ///@notice Returns whitelisted status of erc721TokenAddress at event level
    function isErc721TokenWhitelistedEvent(uint256 eventTokenId, address tokenAddress) public view returns (bool) {
        return erc721TokenAddress[eventTokenId][tokenAddress];
    }

    ///@notice Returns freepass status of erc721TokenAddress at event level
    function isErc721TokenFreePassEvent(uint256 eventTokenId, address tokenAddress) public view returns (uint256) {
        return tokenFreePassStatus[eventTokenId][tokenAddress];
    }

    function isUserWhitelisted(address userAddress) public view returns (bool) {
        return whiteListedAddress[userAddress];
    }

    function getSignerAddress() public view returns (address) {
        return signerAddress;
    }

    function getSignatureContract() public view returns (address) {
        return signatureContract;
    }

    function isEventEnded(uint256 eventId) public view returns (bool) {
        return IManageEvent(manageEvent).isEventEnded(eventId);
    }

    function isEventStarted(uint256 eventId) public view returns (bool) {
        return IManageEvent(manageEvent).isEventStarted(eventId);
    }

    function isEventCancelled(uint256 eventId) public view returns (bool) {
        return IManageEvent(manageEvent).isEventCancelled(eventId);
    }

   function getBaseToken() public view returns(address) {
        return baseTokenAddress;
    }

    function convertFee(address paymentToken, uint256 mintFee) public view returns (uint256) {
        return IConversion(conversionContract).convertFee(paymentToken, mintFee);
    }
    
    function updateAdminTreasuryContract(address payable _adminTreasuryContract) external onlyOwner {
        require(
            _adminTreasuryContract.isContract(),
            "ERR_128:AdminFunctions:Address is not a contract"
        );
        adminTreasuryContract = _adminTreasuryContract;
    }

    ///@notice Returns admintreasuryContract address
    function getAdminTreasuryContract() public view returns (address) {
        return adminTreasuryContract;
    }

    function getTokenDetails(address _tokenAddress, string memory tokenType) public view returns(string memory , string memory, uint256) {
       if(keccak256(abi.encodePacked((tokenType))) == keccak256(abi.encodePacked(("ERC721")))) {
            string memory _name =  IERC721MetadataUpgradeable(_tokenAddress).name();
            string memory _symbol = IERC721MetadataUpgradeable(_tokenAddress).symbol();
            return (_name, _symbol, 0);
        }
        else { 
            if(_tokenAddress!= address(0)) {
                string memory _name = IERC20Metadata(_tokenAddress).name();
                string memory _symbol = IERC20Metadata(_tokenAddress).symbol();
                uint256 _decimal = IERC20Metadata(_tokenAddress).decimals();
                return ( _name, _symbol, _decimal);
            }
            else {
                return ("Matic", "Matic", 18);
            }
        }
    }

    function updateBaseToken(address _baseTokenAddress) external onlyOwner {
        baseTokenAddress = _baseTokenAddress;
        (string memory name, 
         string memory symbol, 
         uint256 decimal) = getTokenDetails(_baseTokenAddress, "ERC20");

        emit BaseTokenUpdated(baseTokenAddress, name, symbol, decimal);
    }

    // Check whether contract address is ERC721
    function isERC721(address nftAddress) public view returns (bool) {
        return IERC721(nftAddress).supportsInterface(IID_IERC721);
    }

    uint256[49] private ______gap;


}