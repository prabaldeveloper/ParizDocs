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
    address internal Trace;
    address constant USD = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;

    IQuickswapRouter router;
    IQuickswapFactory factory;

    mapping(address => mapping(address => address)) public priceFeed;
    event TokenAdded(address indexed tokenAddress);
    event Erc20Details(address indexed tokenAddress, string name, string symbol,uint256 decimal);

    event Erc721Details(address indexed tokenAddress, string name, string symbol);

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function adminUpdate(
        address _Trace,
        IQuickswapRouter _router,
        IQuickswapFactory _factory
    ) public onlyOwner {
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
        uint256 price = uint256(_price);
        return price;
    }

    function getBaseTokenInUSD() public view returns (uint256) {
        return getSwapPrice(USD, Trace); //Price in USDC
    }

    function getTargetTokenInUSD(address targetToken)
        public
        view
        returns (uint256)
    {
        if (targetToken == Trace) {
            return getSwapPrice(USD, Trace);
        } else {
            IAggregatorV3Interface fetchPrice = IAggregatorV3Interface(
                priceFeed[targetToken][address(0)]
            );
            uint256 price = getChainlinkPrice(fetchPrice);
            return price;
        }
    }

    /**s
     * @notice To convert Trace to equivalent amount of token.
     */
    function convertFee(address targetToken, uint256 fee)
        public
        view
        returns (uint256)
    {
        uint256 baseTokenPrice = getBaseTokenInUSD();
        uint256 targetTokenPrice = getTargetTokenInUSD(targetToken);
        uint256 decimal = 18;
        if (targetToken != address(0)) {
            decimal = IERC20Metadata(targetToken).decimals();
        }
        uint256 totalFee;
        if (decimal == 18) {
            uint256 baseTokenIn1USD = (baseTokenPrice * 10**decimal) /
                targetTokenPrice;
            totalFee = (fee * baseTokenIn1USD) / 10**decimal;
        }
        if (decimal == 6) {
            uint256 baseTokenIn1USD = (baseTokenPrice * 10**decimal) /
                targetTokenPrice;
            totalFee = (fee * baseTokenIn1USD) / 10**18;
        }
        return totalFee;
    }

    function getSwapPrice(address tokenA, address tokenB)
        public
        view
        returns (uint256)
    {
        (uint256 reserves0, uint256 reserves1, ) = IQuickswapPair(
            factory.getPair(tokenA, tokenB)
        ).getReserves(); // pair => 0xead0a2ec9fea76a3644531469c0674e0400d862a
        // uint256 price = 2318000;
        // reserves0 = 462832518;
        // reserves1 = 15468000000000000000000;
        uint256 price = (reserves0 * 10**20) / reserves1;
        return price;
    }

    function addToken(address token0, address _priceFeed) public onlyOwner {
        priceFeed[token0][address(0)] = _priceFeed;
    }
    
    function getBaseToken() public view returns(address) {
        return Trace;
    }

      function getERC20Details(address _tokenAddress) public {
        if(_tokenAddress!= address(0)) {
            string memory _name = IERC20Metadata(_tokenAddress).name();
            string memory _symbol = IERC20Metadata(_tokenAddress).symbol();
            uint256 _decimal = IERC20Metadata(_tokenAddress).decimals();
            emit Erc20Details(_tokenAddress, _name, _symbol, _decimal);
        }
        else {
            emit Erc20Details(_tokenAddress, "Matic", "Matic", 18 );
        }
    }

    function getERC721Details(address _tokenAddress) public {
        string memory _name =  IERC721Metadata(_tokenAddress).name();
        string memory _symbol = IERC721Metadata(_tokenAddress).symbol();
        emit Erc721Details(_tokenAddress, _name, _symbol);
    }
}
