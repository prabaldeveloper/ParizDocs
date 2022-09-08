// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./EventStorage.sol";
import "./EventMetadata.sol";

contract EventAdminRole is EventStorage, EventMetadata {

    using AddressUpgradeable for address;
    using AddressUpgradeable for address payable;

    ///@param venueContract venueContract address
    event VenueContractUpdated(address venueContract);

    // ///@param treasuryContract treasuryContract address
    event TreasuryContractUpdated(address treasuryContract);

    ///@param conversionContract conversionContract address
    event ConversionContractUpdated(address conversionContract);

    ///@param ticketMaster ticketMaster contract address
    event TicketMasterContractUpdated(address ticketMaster);

    ///@param isPublic isPublic true or false
    event EventStatusUpdated(bool isPublic);

    ///@param platformFeePercent platformFeePercent
    event PlatformFeeUpdated(uint256 platformFeePercent);

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@param tokenAddress erc-20 token Address
    ///@param status status of the address(true or false)
    event TokenWhitelisted(address indexed tokenAddress, bool status);

    ///@param percentage deviationPercentage
    event DeviationPercentageUpdated(uint256 percentage);

    ///@param whitelistedAddress users address
    ///@param status status of the address
    event WhiteList(address whitelistedAddress, bool status);

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
    function whitelistTokenAddress(address tokenAddress, bool status)
        external
        onlyOwner
    {
        tokenStatus[tokenAddress] = status;
        emit TokenWhitelisted(tokenAddress, status);
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

    ///@notice updates ticketCommissionPercent
    ///@param _ticketCommissionPercent ticketCommissionPercent
    function updateTicketCommission(uint256 _ticketCommissionPercent)
        external
        onlyOwner
    {
        ticketCommissionPercent = _ticketCommissionPercent;
        emit TicketCommissionUpdated(ticketCommissionPercent);
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

    ///@notice Returns deviationPercentage
    function getDeviationPercentage() public view returns (uint256) {
        return deviationPercentage;
    }

    ///@notice Returns platformFeePercent
    function getPlatformFeePercent() public view returns (uint256) {
        return platformFeePercent;
    }

    ///@notice Returns deviationPercentage
    function getTicketCommission() public view returns (uint256) {
        return ticketCommissionPercent;
    }

    ///@notice Returns eventStatus
    function getEventStatus() public view returns (bool) {
        return isPublic;
    }

    uint256[49] private ______gap;
}