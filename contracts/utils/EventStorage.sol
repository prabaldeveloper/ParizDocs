// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract EventStorage {
    //Details of the event
    struct Details {
        string name;
        string category;
        string description;
        uint256 tokenId;
        uint256 startTime;
        uint256 endTime;
        uint256 venueTokenId;
        bool payNow;
        address payable eventOrganiser;
        uint256 ticketPrice;
    }

    //mapping for getting event details
    mapping(uint256 => Details) public getInfo;

    //mapping for featured events
    mapping(uint256 => bool) public featuredEvents;

    //mapping for favourite events
    mapping(address => mapping(uint256 => bool)) public favouriteEvents;

    //map venue ID to eventId list which are booked in that venue
    //when new event are created, add that event id to this array
    mapping(uint256 => uint256[]) public eventsInVenue;

    //mapping for getting rent status
    mapping(address => mapping(uint256 => bool)) public rentStatus;

    //mappping for storing erc20 balance against eventTokenId
    mapping(uint256 => uint256) public balance;

    mapping(uint256 => uint256) public platformFeesPaid;

    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    //mapping for storing tokenAddress against eventTokenId
    mapping(uint256 => address) public eventTokenAddress;

    mapping(address => mapping(uint256 => bool)) public joinEventStatus;

    // //block time
    uint256 public constant blockTime = 2;

    address public adminContract;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}
