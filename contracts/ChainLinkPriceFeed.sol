// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";

contract ChainLinkPriceFeed is Ownable {

    event PriceFeedAddressAdded(string symbol, address priceFeedAddress);

    mapping(string => address) public priceFeedAddress;

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function addPriceFeedAddress(string memory _symbol, address _priceFeedAddress) public onlyOwner {
        require(_priceFeedAddress != address(0), "Invalid Address");
        priceFeedAddress[_symbol] = _priceFeedAddress;
        
        emit PriceFeedAddressAdded(_symbol, _priceFeedAddress);
    }

    function getPriceFeedAddress(string memory symbol) public view returns(address) {
        return priceFeedAddress[symbol];
    }


}