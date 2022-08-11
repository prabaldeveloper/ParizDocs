# Conversion









## Methods

### addToken

```solidity
function addToken(address token0, address _priceFeed) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| token0 | address | undefined |
| _priceFeed | address | undefined |

### adminUpdate

```solidity
function adminUpdate(address _USX, address _Trace, contract IQuickswapRouter _router, contract IQuickswapFactory _factory) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _USX | address | undefined |
| _Trace | address | undefined |
| _router | contract IQuickswapRouter | undefined |
| _factory | contract IQuickswapFactory | undefined |

### convertFee

```solidity
function convertFee(address paymentToken, uint256 fee) external view returns (uint256)
```

To convert usd to equivalent amount of token.



#### Parameters

| Name | Type | Description |
|---|---|---|
| paymentToken | address | undefined |
| fee | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getChainlinkPrice

```solidity
function getChainlinkPrice(contract IAggregatorV3Interface fetchPrice) external view returns (uint256)
```



*Returns the latest price.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| fetchPrice | contract IAggregatorV3Interface | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getSwapPrice

```solidity
function getSwapPrice(address tokenA, address tokenB) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenA | address | undefined |
| tokenB | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getTraceAmount

```solidity
function getTraceAmount(uint256 fee) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| fee | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getUSXPrice

```solidity
function getUSXPrice() external pure returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### initialize

```solidity
function initialize() external nonpayable
```






### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### priceFeed

```solidity
function priceFeed(address, address) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |



## Events

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### TokenAdded

```solidity
event TokenAdded(address indexed tokenAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenAddress `indexed` | address | undefined |



