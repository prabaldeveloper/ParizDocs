// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "./access/Ownable.sol";
import "../contracts/interface/IQuickswapFactory.sol";
import "../contracts/interface/IQuickswapPair.sol";
import "../contracts/interface/IQuickswapRouter.sol";
import "../contracts/interface/IAggregatorV3Interface.sol";
import "../contracts/interface/ITokenCompatibility.sol";


contract Conversion is Initializable, Ownable {
    address internal Trace;
    address constant USD = 0xb0040280A0C97F20C92c09513b8C6e6Ff9Aa86DC; //testnet

    address public tokenCompatibility;

    IQuickswapRouter router;
    IQuickswapFactory factory;

    mapping(address => mapping(address => address)) public priceFeed;
    event TokenAdded(address indexed tokenAddress);
    event Erc20Details(
        address indexed tokenAddress,
        string name,
        string symbol,
        uint256 decimal
    );

    event Erc721Details(
        address indexed tokenAddress,
        string name,
        string symbol
    );

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

    function addTokenCompatibilityContract(address _tokenCompatibility) public onlyOwner{
        tokenCompatibility = _tokenCompatibility;
    }

    /**
     * @dev Returns the latest price.
     */
    function getChainlinkPrice(
        IAggregatorV3Interface fetchPrice
    ) public view returns (uint256) {
        (, int256 _price, , , ) = fetchPrice.latestRoundData();
        uint256 price = uint256(_price);
        return price;
    }

    function getBaseTokenInUSD() public view returns (uint256) {
        return getSwapPrice(USD, Trace); //Price in USDC
    }

    function getTargetTokenInUSD(
        address targetToken
    ) public view returns (uint256) {
        if (targetToken == Trace) {
            return getSwapPrice(USD, Trace);
        } else {
            uint256 price = getTokenPrice(targetToken);
            return price;
        }
    }

    function getTokenPrice(
        address targetToken
    ) public view returns (uint256 _price) {
        (address pair, address pairedWith) = ITokenCompatibility(
            tokenCompatibility
        ).getSwapPair(targetToken);

        // Chainlink check master level 
        if (priceFeed[targetToken][address(0)] != address(0)) {
            IAggregatorV3Interface fetchPrice = IAggregatorV3Interface(
                priceFeed[targetToken][address(0)]
            );
            _price = getChainlinkPrice(fetchPrice);
            return _price;
        } else if ( // Chainlink at event level
            ITokenCompatibility(tokenCompatibility).getPriceFeedAddress(
                IERC20Metadata(targetToken).symbol()
            ) != address(0)
        ) {
            IAggregatorV3Interface fetchPrice = IAggregatorV3Interface(
                ITokenCompatibility(tokenCompatibility).getPriceFeedAddress(
                    IERC20Metadata(targetToken).symbol()
                )
            );
            _price = getChainlinkPrice(fetchPrice);
            return _price;
        } else if (pair != address(0)) { //Quickswap
            if (pairedWith == Trace) {
                _price = getSwapFromTrace(targetToken); // Should return price in 8 decimals
            } else {
                _price = getSwapFromUSD(targetToken); // Should return price in 8 decimals
            }
            return _price;
        }
    }
    //Trace - USDC
    /**
     * @notice To convert Trace to equivalent amount of token.
     */
    function convertFee(
        address targetToken,
        uint256 fee
    ) public view returns (uint256) {
        uint256 baseTokenPrice = getBaseTokenInUSD(); // 1TRACE = 2992193.677269201 USDC
        uint256 targetTokenPrice = getTargetTokenInUSD(targetToken); //  1Test8 = 2992193.677269201 USDC
        uint256 decimal = 18;
        if (targetToken != address(0)) {
            decimal = IERC20Metadata(targetToken).decimals();
        }
        uint256 totalFee;
        if (decimal == 18) {
            uint256 baseTokenIn1USD = (baseTokenPrice * 10 ** decimal) / 
                targetTokenPrice;
            totalFee = (fee * baseTokenIn1USD) / 10 ** decimal;
        }
        if (decimal == 6) {
            uint256 baseTokenIn1USD = (baseTokenPrice * 10 ** decimal) /
                targetTokenPrice;
            totalFee = (fee * baseTokenIn1USD) / 10 ** 18;
        }
        if(decimal == 8) {
            uint256 baseTokenIn1USD = (baseTokenPrice * 10 ** decimal) /
                targetTokenPrice;
            totalFee = (fee * baseTokenIn1USD) / 10 ** 18;
        }
        return totalFee;
    }

    // reserve0 is usdc
    //reserve1 is trace
    function getSwapPrice(
        address tokenA,
        address tokenB
    ) public view returns (uint256) {
        (uint256 reserves0, uint256 reserves1, ) = IQuickswapPair(
            factory.getPair(tokenA, tokenB)
        ).getReserves(); 
        uint256 price = (reserves0 * 10 ** 20) / reserves1; //1 Trace = 2992193.677269201 USDC(should be divided by 8)
        return price;
    }

    // TBC
    function getSwapFromTrace(address tokenA) public view returns(uint256) {
        (uint256 reserves0, uint256 reserves1, ) = IQuickswapPair(
            factory.getPair(tokenA, Trace)
        ).getReserves();
        address token0 = IQuickswapPair(
            factory.getPair(tokenA, Trace)
        ).token0();
        // get value of token in Trace - reserves0 or reserves1
        uint256 price;
        uint256 decimals;
        uint256 usdTokenPrice = getSwapPrice(USD, Trace);   // 1TRACE = 2992193.677269201 USDC
        uint256 toUSD = usdTokenPrice;
        if(tokenA!= address(0)) {
            decimals = IERC20Metadata(tokenA).decimals();
        }
        if(token0 == Trace) {
            if(decimals == 18) {
                price = (reserves1 * 10 ** 36) / (reserves0 * 10 ** 18); // 1TRACE = 10 Test8
                // Convert the value to USD
                if(price != 0) {
                    toUSD = (usdTokenPrice * 10 ** 18 / price); //1Test8 = 13 usdc
                }
            }
            else if(decimals == 8 || decimals == 6) {
                price = (reserves1 * 10 ** 18 ) / (reserves0 * 10 ** decimals); // 1 Trace = 10 dai    00.225         
                if(price != 0) {
                    toUSD = (usdTokenPrice/price);
                }
            }
        }
        else {
            if(decimals == 18) {
                price = (reserves0 * 10 ** 36) / (reserves1  * 10 ** 18); 
                // Convert the value to USD
                if(price != 0) {
                    toUSD = (usdTokenPrice * 10 ** 18 / price);
                }
            }
            else if(decimals == 8 || decimals == 6) {
                 price = (reserves0 * 10 ** 18 ) / (reserves1 * 10 ** decimals); // 1 Trace = 10 dai    00.225         
                 if(price != 0) {
                    toUSD = (usdTokenPrice/price);
                }
            }
        }
         // 1 Trace = 2992193.677269201 USDC
        //8decimal
        
        return toUSD;
    }

    function getSwapFromUSD(address tokenA) public view returns(uint256) {
        (uint256 reserves0, uint256 reserves1, ) = IQuickswapPair(
            factory.getPair(tokenA, USD)
        ).getReserves();
        address token0 = IQuickswapPair(
            factory.getPair(tokenA, USD)
        ).token0();
        // get value of token in usd - reserves0 or reserves1
        uint256 price;
        uint256 decimals;
        if(tokenA != address(0)) {
            decimals = IERC20Metadata(tokenA).decimals();
        }
        if(token0 == USD) {
            price = (reserves0 * 10 ** decimals * 10 ** 8) / (reserves1 * 10 ** 6); // 1 dai = 10 USD

        }
        else {
            price = (reserves1 * 10 ** decimals * 10 ** 8) / (reserves0 * 10 ** 6);
        }
        return price;
    }

    function addToken(address token0, address _priceFeed) public onlyOwner {
        priceFeed[token0][address(0)] = _priceFeed;
    }

    function getBaseToken() public view returns (address) {
        return Trace;
    }

    function getERC20Details(address _tokenAddress) public {
        if (_tokenAddress != address(0)) {
            string memory _name = IERC20Metadata(_tokenAddress).name();
            string memory _symbol = IERC20Metadata(_tokenAddress).symbol();
            uint256 _decimal = IERC20Metadata(_tokenAddress).decimals();
            emit Erc20Details(_tokenAddress, _name, _symbol, _decimal);
        } else {
            emit Erc20Details(_tokenAddress, "Matic", "Matic", 18);
        }
    }

    function getERC721Details(address _tokenAddress) public {
        string memory _name = IERC721Metadata(_tokenAddress).name();
        string memory _symbol = IERC721Metadata(_tokenAddress).symbol();
        emit Erc721Details(_tokenAddress, _name, _symbol);
    }
}
