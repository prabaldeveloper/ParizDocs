// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract AdminStorage {
    //mapping for getting supported erc20TokenAddress
    mapping(address => bool) public erc20TokenAddress;

    //mapping for getting supported erc721TokenAddress
    mapping(address => bool) public erc721TokenAddress;

    //mapping for whiteListed address
    mapping(address => bool) public whiteListedAddress;

    mapping(address => uint256) public tokenFreePassStatus;

    // Deviation Percentage
    uint256 internal deviationPercentage;

    //venue contract address
    address internal venueContract;

    //convesion contract address
    address internal conversionContract;

    //ticket master contract address
    address internal ticketMaster;

    //treasury contract
    address payable internal treasuryContract;

    //manageEvent contract
    address internal manageEvent;

    //event Contract
    address internal eventContract;

    //signature Contract
    address internal signatureContract;

    //isPublic true or false
    bool internal isPublic;

    //platformFeePercent
    uint256 internal platformFeePercent;

    //signerAddress
    address public signerAddress;

    //venueRentalCommission
    uint256 internal venueRentalCommission;

    //ticketCommission
    uint256 internal ticketCommissionPercent;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;

}