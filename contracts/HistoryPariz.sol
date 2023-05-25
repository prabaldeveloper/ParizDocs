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
        address userAddress,
        uint256 eventTokenId,
        string memory data
    ) public {
        require(msg.sender == signerAddress, "Invalid Caller");
        eventTokenIdToData[eventTokenId].push(data);
        userData[userAddress].push(data);
        emit DataAdded(userAddress, eventTokenId, data);
    }

    function getEventData(uint256 eventTokenId) public view returns(string[] memory) {
        return eventTokenIdToData[eventTokenId];
    }

    function getUserData(address userAddress) public view returns(string[] memory) {
        return userData[userAddress];
    }
}