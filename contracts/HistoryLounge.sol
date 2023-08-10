// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract HistoryLounge is Ownable {

    address internal signerAddress;
    
    event DataAdded(
        string userAddress,
        string loungeId,
        string data
    );
    
    mapping(string => string[]) internal metastoreIdToData;
    mapping(string => string[]) internal userData;

    address internal secondSignerAddress;

    mapping (address => bool) internal signerAddressStatus;
    
    function initialize() public initializer {
        Ownable.ownable_init();
    }

   function updateSignerAddress(address _signerAddress, bool status) public onlyOwner {
        require(_signerAddress != address(0), "Invalid address");
        signerAddressStatus[_signerAddress] = status;
    }

    function addData(
        string[] memory userAddress,
        string[] memory loungeId,
        string[] memory data
    ) public {
        require(signerAddressStatus[msg.sender] == true, "Invalid Caller");
        for(uint256 i = 0 ; i < userAddress.length; i++) { 
            emit DataAdded(userAddress[i], loungeId[i], data[i]);
        }
    }

    function getSignerAddressStatus(address _signerAddress) public view returns(bool) {
        return signerAddressStatus[_signerAddress];
        
    }
}