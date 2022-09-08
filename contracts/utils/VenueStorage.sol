// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VenueStorage {
    ///Details of the venue
    struct Details {
        string name;
        string location;
        string category;
        uint256 tokenId;
        address payable owner;
        uint256 totalCapacity;
        uint256 rentPerBlock;
        string tokenCID;
    }

    //mapping for getting venue details
    mapping(uint256 => Details) public getInfo;

    //venueRentalCommission
    uint256 internal venueRentalCommission;

    /**
     * @notice This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[999] private ______gap;
}
