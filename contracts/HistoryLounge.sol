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
        string[] memory userAddress,
        string[] memory loungeId,
        string[] memory data
    ) public {
        require(msg.sender == signerAddress, "Invalid Caller");
        for(uint256 i = 0 ; i < userAddress.length; i++) { 
            emit DataAdded(userAddress[i], loungeId[i], data[i]);
        }
    }
}