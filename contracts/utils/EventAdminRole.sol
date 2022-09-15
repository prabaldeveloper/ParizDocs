// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./EventStorage.sol";
import "./EventMetadata.sol";
import "./VerifySignature.sol";


contract EventAdminRole is EventStorage, EventMetadata, VerifySignature {

    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

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
    event Erc20TokenUpdated(address indexed tokenAddress, bool status);

    ///@param tokenAddress erc-721 token address
    ///@param status status of the address(true or false)
    event Erc721TokenUpdated(address indexed tokenAddress, bool status);
    ///@param percentage deviationPercentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param whitelistedAddress users address
    ///@param status status of the address
    event WhiteList(address whitelistedAddress, bool status);

    ///@param signerAddress signer Address
    event signerAddressUpdated(address signerAddress);

    ///@notice Allows Admin to update deviation percentage
    ///@param _deviationPercentage deviationPercentage
    function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
        deviationPercentage = _deviationPercentage;
        emit DeviationPercentageUpdated(_deviationPercentage);
    }

    ///@notice Add supported Erc-20 tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    function whitelistErc20TokenAddress(address tokenAddress, bool status)
        external
        onlyOwner
    {
         erc20TokenAddress[tokenAddress] = status;
        emit Erc20TokenUpdated(tokenAddress, status);
    
    }

    ///@notice Add supported Erc-721 tokens for the payment
    ///@dev Only admin can call
    ///@dev -  Update the status of paymentToken
    ///@param tokenAddress erc-721 token Address
    ///@param status status of the address(true or false)
    function whitelistErc721TokenAddress(address tokenAddress, bool status) external onlyOwner {
        erc721TokenAddress[tokenAddress] = status;
        emit Erc721TokenUpdated(tokenAddress, status);
    }

    ///@notice updates conversionContract address
    ///@param _conversionContract conversionContract address
    function updateConversionContract(address _conversionContract)
        external
        onlyOwner
    {
        require(
            _conversionContract.isContract(),
            "Events: Address is not a contract"
        );
        conversionContract = _conversionContract;
        emit ConversionContractUpdated(_conversionContract);
    }

    ///@notice updates conversionContract address
    ///@param _venueContract venueContract address
    function updateVenueContract(address _venueContract) external onlyOwner {
        require(
            _venueContract.isContract(),
            "Events: Address is not a contract"
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
            "Events: Address is not a contract"
        );
        treasuryContract = _treasuryContract;
        emit TreasuryContractUpdated(_treasuryContract);
    }

    ///@notice updates ticketMaster address
    ///@param _ticketMaster ticketMaster address
    function updateticketMasterContract(address _ticketMaster)
        external
        onlyOwner
    {
        require(
            _ticketMaster.isContract(),
            "Events: Address is not a contract"
        );
        ticketMaster = _ticketMaster;
        emit TicketMasterContractUpdated(_ticketMaster);
    }

    function updateManageEventContract(address _manageEvent) external onlyOwner {
        require(
            _manageEvent.isContract(),
            "Events: Address is not a contract"
        );
        manageEvent = _manageEvent;

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

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns (uint256) {
        return deviationPercentage;
    }

    ///@notice Returns platformFeePercent
    function getPlatformFeePercent() public view returns (uint256) {
        return platformFeePercent;
    }

    ///@notice Returns eventStatus
    function getEventStatus() public view returns (bool) {
        return isPublic;
    }

     ///@notice Returns whitelisted status of erc721TokenAddress
    function isErc721TokenWhitelisted(address tokenAddress) public view returns (bool) {
        return erc721TokenAddress[tokenAddress];
    }

    ///@notice Returns whitelisted status of erc20TokenAddress
    function isErc20TokenWhitelisted(address tokenAddress) public view returns (bool) {
        return erc20TokenAddress[tokenAddress];
    }

    function getSignerAddress() public view returns (address) {
        return signerAddress;
    }

    uint256[49] private ______gap;
}
