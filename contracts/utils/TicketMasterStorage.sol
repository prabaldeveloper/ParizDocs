// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract TicketMasterStorage {
    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    //mapping for getting the tokenAddress using which ticket is bought
    mapping(uint256 => mapping(uint256 => address)) 
        public buyTicketTokenAddress;

    mapping(uint256 => mapping(address => uint256)) public ticketFeesBalance;

    mapping(uint256 => mapping(uint256 => uint256)) public userTicketBalance;

    mapping(uint256 => mapping(uint256 => bool)) public refundTicketFeesStatus;

    mapping(address => mapping(uint256 => bool)) public nftIdPassStatus;

    mapping(address => uint256[]) public nftTicketIds;

    //mapping for storing owner address status
    mapping(address => bool) public adminAddress;

    mapping(address => bool) public erc721Address;

    //admin contract address
    address public adminContract;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}
