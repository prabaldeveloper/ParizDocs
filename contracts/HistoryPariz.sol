// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
 
import "./access/Ownable.sol";


contract History is Ownable {

    address public signerAddress;

    event DataAdded(
        address indexed userAddress,
        uint256 indexed tokenId,
        string data
    );

    mapping(uint256 => string[]) internal eventTokenIdToData;
    mapping(address => string[]) internal userData;

    function initialize() public initializer() {
        Ownable.ownable_init();
    }

    function addSigner(address _signerAddress) public onlyOwner {
        require(_signerAddress != address(0), "Invalid address");
        signerAddress = _signerAddress;
    }

    function addData(
        address[] memory userAddress,
        uint256[] memory eventTokenId,
        string[] memory data
    ) public {
        require(msg.sender == signerAddress, "Invalid Caller");
        for(uint256 i = 0 ; i < userAddress.length; i++) {
            eventTokenIdToData[eventTokenId[i]].push(data[i]);
            userData[userAddress[i]].push(data[i]);
            emit DataAdded(userAddress[i], eventTokenId[i], data[i]);
        }
    }

    function getEventData(uint256 eventTokenId) public view returns(string[] memory) {
        return eventTokenIdToData[eventTokenId];
    }

    function getUserData(address userAddress) public view returns(string[] memory) {
        return userData[userAddress];
    }
}