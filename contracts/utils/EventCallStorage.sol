// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract EventCallStorage {
    
    address public adminContract;

    address public tokenCompatibility;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}
