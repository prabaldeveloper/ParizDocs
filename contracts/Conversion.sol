// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "./access/Ownable.sol";
import "../contracts/interface/IQuickswapFactory.sol";
import "../contracts/interface/IQuickswapPair.sol";
import "../contracts/interface/IQuickswapRouter.sol";
import "../contracts/interface/IAggregatorV3Interface.sol";


contract Conversion is Initializable, Ownable {
    address internal USX;
    address internal Trace;
    address constant USD = 0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC;

    IQuickswapRouter router;
    IQuickswapFactory factory;

    uint256 PRICE_PRECISION;
    uint256 USD_DECIMALS;
    mapping(address => mapping(address => address)) public priceFeed;
    event TokenAdded(address indexed tokenAddress);

    function initialize() public initializer {
        Ownable.ownable_init();
        PRICE_PRECISION = 1E8;
        USD_DECIMALS = 8;
    }

    function adminUpdate(
        address _USX,
        address _Trace,
        IQuickswapRouter _router,
        IQuickswapFactory _factory
    ) public onlyOwner {
        USX = _USX;
        Trace = _Trace;
        router = _router;
        factory = _factory;
    }

    /**
     * @dev Returns the latest price.
     */
    function getChainlinkPrice(IAggregatorV3Interface fetchPrice)
        public
        view
        returns (uint256)
    {
        (, int256 _price, , , ) = fetchPrice.latestRoundData();
        uint256 price = uint256(_price)*(1E10);
        return price;
    }

    /**
     * @notice To convert usd to equivalent amount of token.
     */
    function convertFee(address paymentToken, uint256 fee)
        public
        view
        returns (uint256)
    {
        uint256 decimal = 18;
        if (paymentToken != address(0)) {
            decimal = IERC20Metadata(paymentToken).decimals();
        }
        if (paymentToken == USX) {
            return fee*(10**decimal)/(PRICE_PRECISION);
        }
        if (paymentToken == Trace) {
            return getTraceAmount(fee);
        }

        IAggregatorV3Interface fetchPrice = IAggregatorV3Interface(
            priceFeed[paymentToken][address(0)]
        );
        uint256 price = getChainlinkPrice(fetchPrice);

        price = fee*(1E18)*(10**decimal)/(price)/(
            PRICE_PRECISION
        );
        return price;
    }

    function getTraceAmount(uint256 fee) public view returns (uint256) {
        return fee*(getSwapPrice(USD, Trace))*(100);
    }

    function getSwapPrice(address tokenA, address tokenB)
        public
        view
        returns (uint256)
    {
        (uint256 reserves0, uint256 reserves1, ) = IQuickswapPair(
            factory.getPair(tokenA, tokenB)
        ).getReserves();
        uint256 price = reserves1/(reserves0)/(10000);
        return price;
    }

    function getUSXPrice() public pure returns (uint256) {
        return 100000000;
    }

    function addToken(address token0, address _priceFeed) public onlyOwner {
        priceFeed[token0][address(0)] = _priceFeed;
    }
}