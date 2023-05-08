// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract HistoryLounge is Ownable {

    address public signerAddress;
    
    event DataAdded(
        string userAddress,
        string loungeId,
        string data
    );
    
    mapping(string => string[]) internal loungeIdToData;
    mapping(string => string[]) internal userData;
    
    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function addSigner(address _signerAddress) public onlyOwner {

        require(_signerAddress != address(0), "Invalid address");
        signerAddress = _signerAddress;
    }

    function addData(
        string memory userAddress,
        string memory loungeId,
        string memory data
    ) public {
        require(msg.sender == signerAddress, "Invalid Caller");
        loungeIdToData[loungeId].push(data);
        userData[userAddress].push(data);
        emit DataAdded(userAddress, loungeId, data);
    }

    function getLoungeData(string memory loungeId) public view returns(string[] memory) {
        return loungeIdToData[loungeId];
    }

    function getUserData(string memory userAddress) public view returns(string[] memory) {
        return userData[userAddress];
    }
}
