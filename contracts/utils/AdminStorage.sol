// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import "./AdminStorageV1.sol";
contract AdminStorage {
    //mapping for getting supported erc20TokenAddress at master level
    mapping(address => bool) public erc20TokenAddress;

    //mapping for getting supported erc721TokenAddress at event level
    mapping(uint256 => mapping(address => bool)) public erc721TokenAddress;
   
    //mapping for whiteListed address
    mapping(address => bool) public whiteListedAddress;

    //status at event level
    mapping(uint256 => mapping(address => uint256)) public tokenFreePassStatus;

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

    //admin treasury contract
    address payable internal adminTreasuryContract;

    address internal baseTokenAddress;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[997] private ______gap;


    //event Call Contract
    address internal eventCallContract;

    //Ticket Controller Contract
    address internal ticketControllerContract;

    //mapping for getting supported erc721TokenAddress at master level
    mapping(address => bool) public erc721TokenAddressMaster;

    //mapping for getting supported erc20TokenAddress at event level
    mapping(uint256 => mapping(address => bool)) public erc20TokenAddressEvent;

    //status at master level
    mapping(address => uint256) public tokenFreePassStatusMaster;




}