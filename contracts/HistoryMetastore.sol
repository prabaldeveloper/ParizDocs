// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract HistoryMetastore is Ownable {

    address public signerAddress;
    
    event DataAdded(
        string userAddress,
        string metastoreId,
        string data
    );
    
    mapping(string => string[]) internal metastoreIdToData;
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
        string memory metastoreId,
        string memory data
    ) public {
        require(msg.sender == signerAddress, "Invalid Caller");
        metastoreIdToData[metastoreId].push(data);
        userData[userAddress].push(data);
        emit DataAdded(userAddress, metastoreId, data);
    }

    function getMetastoreData(string memory metastoreId) public view returns(string[] memory) {
        return metastoreIdToData[metastoreId];
    }

    function getUserData(string memory userAddress) public view returns(string[] memory) {
        return userData[userAddress];
    }
}
