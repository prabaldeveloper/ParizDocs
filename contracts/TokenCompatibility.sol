// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./access/Ownable.sol";
import "../contracts/interface/IQuickswapFactory.sol";
import "../contracts/interface/IQuickswapPair.sol";
import "../contracts/interface/IQuickswapRouter.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165CheckerUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract TokenCompatibility is Ownable {
    using ERC165CheckerUpgradeable for address;

    address constant Trace = 0xD028C2a5156069c7eFaeA40acCA7d9Da6f219A5f; //BaseToken
    address constant USDC = 0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC; //Testnet
    address constant USDT = 0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC; //Testnet

    IQuickswapRouter router;
    IQuickswapFactory factory;

    event PriceFeedAddressAdded(string symbol, address priceFeedAddress);

    mapping(string => address) public priceFeedAddress;

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function adminUpdate(
        IQuickswapRouter _router,
        IQuickswapFactory _factory
    ) public onlyOwner {
        router = _router;
        factory = _factory;
    }

    function addPriceFeedAddress(
        string memory _symbol,
        address _priceFeedAddress
    ) public onlyOwner {
        require(_priceFeedAddress != address(0), "Invalid Address");
        priceFeedAddress[_symbol] = _priceFeedAddress;

        emit PriceFeedAddressAdded(_symbol, _priceFeedAddress);
    }

    function getPriceFeedAddress(
        string memory symbol
    ) public view returns (address) {
        return priceFeedAddress[symbol];
    }

    function getSwapPair(
        address _tokenAddress
    ) public view returns (address, address) {
        if (factory.getPair(_tokenAddress, Trace) != address(0)) {
            return (factory.getPair(_tokenAddress, Trace), Trace);
        } else if (factory.getPair(_tokenAddress, USDC) != address(0)) {
            return (factory.getPair(_tokenAddress, USDC), USDC);
        } else if (factory.getPair(_tokenAddress, USDT) != address(0)) {
            return (factory.getPair(_tokenAddress, USDT), USDT);
        } else {
            return (address(0), address(0));
        }
    }

    function checkCompatibility(
        address _tokenAddress,
        string memory _symbol
    ) public view returns (bool) {
        bool isChainlinkRegistered;
        bool isPoolexists;
        // swap pair
        (address pair, ) = getSwapPair(_tokenAddress);
        // Chainlink
        if (getPriceFeedAddress(_symbol) != address(0))
            isChainlinkRegistered = true;
        else if (pair != address(0)) isPoolexists = true;

        if(isChainlinkRegistered || isPoolexists)
            return true;
    }

    // Check whether contract address is ERC721
    function isERC721(address nftAddress) public view returns (bool) {
        return nftAddress.supportsInterface(type(IERC721).interfaceId);
    }
}
