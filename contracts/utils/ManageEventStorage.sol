// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract ManageEventStorage {
    //Details of the agenda
    struct agendaDetails {
        uint256 agendaId;
        uint256 agendaStartTime;
        uint256 agendaEndTime;
        string agendaName;
        string[] guestName;
        string[] guestAddress;
        uint8 initiateStatus;
        bool isAgendaDeleted;
    }

    //mapping for getting agenda details
    mapping(uint256 => agendaDetails[]) public getAgendaInfo;

    //mapping for getting number of agendas
    mapping(uint256 => uint256) public noOfAgendas;

    // //mapping for event start status
    // mapping(uint256 => bool) public eventStartedStatus;

    // //mapping for event cancel status
    // mapping(uint256 => bool) public eventCanceledStatus;

    mapping(uint256 => uint256[]) public agendaInEvents;

    //Event contract address
    address internal eventContract;

    //
    // This empty reserved space is put in place to allow future versions to add new
    // variables without shifting down storage in the inheritance chain.
    // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
    //
    uint256[999] private ______gap;
}