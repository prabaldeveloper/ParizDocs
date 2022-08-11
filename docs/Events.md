# Events

*Prabal Srivastav*

> Create and join events

Users can create event and join events



## Methods

### add

```solidity
function add(string name, string category, string description, uint256 startTime, uint256 endTime, string tokenCID, uint256 venueTokenId, bool payNow, address tokenAddress, uint256 venueFeeAmount, bool isEventPaid, uint256 ticketPrice) external payable
```

Creates Event

*Event organiser can call- Check whether venue is available. - Check whether event is paid or free for users.- Check whether venue fees is paid or it is mark as pay later.- Save all the fields in the contract.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Event name |
| category | string | Event category |
| description | string | Event description |
| startTime | uint256 | Event startTime |
| endTime | uint256 | Event endTime |
| tokenCID | string | Event tokenCID |
| venueTokenId | uint256 | venueTokenId |
| payNow | bool | pay venue fees now or later(true or false) |
| tokenAddress | address | undefined |
| venueFeeAmount | uint256 | undefined |
| isEventPaid | bool | isEventPaid(true or false) |
| ticketPrice | uint256 | ticketPrice of event |

### approve

```solidity
function approve(address to, uint256 tokenId) external nonpayable
```



*See {IERC721-approve}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| to | address | undefined |
| tokenId | uint256 | undefined |

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```



*See {IERC721-balanceOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### baseURI

```solidity
function baseURI() external view returns (string)
```



*Returns the base URI set via {_setBaseURI}. This will be automatically added as a prefix in {tokenURI} to each token&#39;s URI, or to the token ID if no specific URI is set for that token ID.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### buyTicket

```solidity
function buyTicket(uint256 tokenId, address tokenAddress, uint256 ticketPrice) external payable
```

Users can buy tickets

*Public function- Check whether event is paid or free- Check whether user paid the price.- Map event tokenId with user address*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| tokenAddress | address | Token Address |
| ticketPrice | uint256 | ticket Price |

### checkDeviation

```solidity
function checkDeviation(uint256 feeAmount, uint256 price) external view
```

To check amount is within deviation percentage



#### Parameters

| Name | Type | Description |
|---|---|---|
| feeAmount | uint256 | price of the ticket |
| price | uint256 | price from the conversion contract |

### erc20TokenStatus

```solidity
function erc20TokenStatus(address) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### eventsInVenue

```solidity
function eventsInVenue(uint256, uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### favourite

```solidity
function favourite(uint256 tokenId, bool isFavourite) external nonpayable
```

Users can mark their favourite events



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| isFavourite | bool | Event featured(true/false) |

### favouriteEvents

```solidity
function favouriteEvents(address, uint256) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |
| _1 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### featured

```solidity
function featured(uint256 tokenId, bool isFeatured) external nonpayable
```

Feature the event

*Only admin can call- Mark the event as featured*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| isFeatured | bool | Event featured(true/false) |

### featuredEvents

```solidity
function featuredEvents(uint256) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### getApproved

```solidity
function getApproved(uint256 tokenId) external view returns (address)
```



*See {IERC721-getApproved}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getConversionContract

```solidity
function getConversionContract() external view returns (address)
```

Returns conversionContract address




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getDeviationPercentage

```solidity
function getDeviationPercentage() external view returns (uint256)
```

Returns deviationPercentage




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getHasCreatorMintedIPFSHash

```solidity
function getHasCreatorMintedIPFSHash(address creator, string tokenIPFSPath) external view returns (bool)
```

Checks if the creator has already minted a given NFT.



#### Parameters

| Name | Type | Description |
|---|---|---|
| creator | address | undefined |
| tokenIPFSPath | string | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### getInfo

```solidity
function getInfo(uint256) external view returns (uint256 tokenId, string name, string _type, string description, uint256 startTime, uint256 endTime, string tokenCID, uint256 venueTokenId, address payable eventOrganiser, bool isEventPaid, uint256 ticketPrice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| name | string | undefined |
| _type | string | undefined |
| description | string | undefined |
| startTime | uint256 | undefined |
| endTime | uint256 | undefined |
| tokenCID | string | undefined |
| venueTokenId | uint256 | undefined |
| eventOrganiser | address payable | undefined |
| isEventPaid | bool | undefined |
| ticketPrice | uint256 | undefined |

### getNextTokenId

```solidity
function getNextTokenId() external view returns (uint256)
```

Gets the tokenId of the next NFT minted.




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getTokenCID

```solidity
function getTokenCID(uint256 tokenId) external view returns (string)
```

Returns the IPFSPath to the metadata JSON file for a given NFT.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### getVenueContract

```solidity
function getVenueContract() external view returns (address)
```

Returns venue contract address




#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### initialize

```solidity
function initialize() external nonpayable
```






### isApprovedForAll

```solidity
function isApprovedForAll(address owner, address operator) external view returns (bool)
```



*See {IERC721-isApprovedForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| owner | address | undefined |
| operator | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### join

```solidity
function join(uint256 tokenId) external nonpayable
```

Users can join events

*Public function- Check whether event is started or not- Check whether user has ticket if the event is paid- Join the event*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |

### name

```solidity
function name() external view returns (string)
```



*See {IERC721Metadata-name}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### ownerOf

```solidity
function ownerOf(uint256 tokenId) external view returns (address)
```



*See {IERC721-ownerOf}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) external nonpayable
```



*See {IERC721-safeTransferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) external nonpayable
```



*See {IERC721-safeTransferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |
| data | bytes | undefined |

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) external nonpayable
```



*See {IERC721-setApprovalForAll}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| operator | address | undefined |
| approved | bool | undefined |

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```



*See {IERC165-supportsInterface}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| interfaceId | bytes4 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### symbol

```solidity
function symbol() external view returns (string)
```



*See {IERC721Metadata-symbol}.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### ticketBoughtAddress

```solidity
function ticketBoughtAddress(uint256, address) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |
| _1 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### ticketSold

```solidity
function ticketSold(uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### tokenCreator

```solidity
function tokenCreator(uint256 tokenId) external view returns (address payable)
```

Returns the creator&#39;s address for a given tokenId.



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address payable | undefined |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) external view returns (string)
```



*See {IERC721Metadata-tokenURI}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | string | undefined |

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) external nonpayable
```



*See {IERC721-transferFrom}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| from | address | undefined |
| to | address | undefined |
| tokenId | uint256 | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### updateConversionContract

```solidity
function updateConversionContract(address _conversionContract) external nonpayable
```

updates conversionContract address



#### Parameters

| Name | Type | Description |
|---|---|---|
| _conversionContract | address | conversionContract address |

### updateDescription

```solidity
function updateDescription(uint256 tokenId, string description) external nonpayable
```

Update event description

*Only event organiser can call- Check whether event is started or not- Update the event description*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| description | string | Event description |

### updateDeviation

```solidity
function updateDeviation(uint256 _deviationPercentage) external nonpayable
```

Allows Admin to update deviation percentage



#### Parameters

| Name | Type | Description |
|---|---|---|
| _deviationPercentage | uint256 | deviationPercentage |

### updateErc20TokenAddress

```solidity
function updateErc20TokenAddress(address tokenAddress, bool status) external nonpayable
```

Supported tokens for the payment

*Only admin can call-  Update the status of paymentToken*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenAddress | address | erc-20 token Address |
| status | bool | status of the address(true or false) |

### updateStartTime

```solidity
function updateStartTime(uint256 tokenId, uint256 startTime) external nonpayable
```

Update event startTime

*Only event organiser can call- Check whether event is started or not.- Update the event startTime .*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| startTime | uint256 | Event startTime |

### updateTokenCID

```solidity
function updateTokenCID(uint256 tokenId, string tokenCID) external nonpayable
```

Update event IPFSPath

*Only event organiser can call- Check whether event is started or not- Update the event IPFSPath *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| tokenCID | string | Event tokenCID |

### updateVenueContract

```solidity
function updateVenueContract(address _venueContract) external nonpayable
```

updates conversionContract address



#### Parameters

| Name | Type | Description |
|---|---|---|
| _venueContract | address | venueContract address |

### updateWhitelist

```solidity
function updateWhitelist(address[] _whitelistAddresses, bool[] _status) external nonpayable
```

Admin can whiteList users



#### Parameters

| Name | Type | Description |
|---|---|---|
| _whitelistAddresses | address[] | users address |
| _status | bool[] | status of the address |

### whiteListedAddress

```solidity
function whiteListedAddress(address) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |



## Events

### Approval

```solidity
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| approved `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### ApprovalForAll

```solidity
event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| owner `indexed` | address | undefined |
| operator `indexed` | address | undefined |
| approved  | bool | undefined |

### BaseURIUpdated

```solidity
event BaseURIUpdated(string baseURI)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| baseURI  | string | undefined |

### Bought

```solidity
event Bought(uint256 indexed tokenId, address paymentToken, address buyer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| paymentToken  | address | Token Address |
| buyer  | address | buyer address  |

### ConversionContractUpdated

```solidity
event ConversionContractUpdated(address conversionContract)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| conversionContract  | address | conversionContract address |

### DescriptionUpdated

```solidity
event DescriptionUpdated(uint256 indexed tokenId, string description)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| description  | string | Event description |

### DeviationPercentage

```solidity
event DeviationPercentage(uint256 percentage)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| percentage  | uint256 | undefined |

### ERC20TokenUpdated

```solidity
event ERC20TokenUpdated(address indexed tokenAddress, bool status)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenAddress `indexed` | address | undefined |
| status  | bool | undefined |

### EventAdded

```solidity
event EventAdded(uint256 indexed tokenId, string name, string category, string description, uint256 startTime, uint256 endTime, string tokenCID, uint256 venueTokenId, bool isVenueFeesPaid, bool isEventPaid, address eventOrganiser, uint256 ticketPrice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| name  | string | Event name |
| category  | string | Event category |
| description  | string | Event description |
| startTime  | uint256 | Event startTime |
| endTime  | uint256 | Event endTime |
| tokenCID  | string | Event tokenCID |
| venueTokenId  | uint256 | venueTokenId |
| isVenueFeesPaid  | bool | undefined |
| isEventPaid  | bool | isEventPaid |
| eventOrganiser  | address | address of the organiser |
| ticketPrice  | uint256 | ticketPrice of event |

### Favourite

```solidity
event Favourite(address user, uint256 indexed tokenId, bool isFavourite)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| user  | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| isFavourite  | bool | undefined |

### Featured

```solidity
event Featured(uint256 indexed tokenId, bool isFeatured)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| isFeatured  | bool | undefined |

### Initialized

```solidity
event Initialized(uint8 version)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| version  | uint8 | undefined |

### Joined

```solidity
event Joined(uint256 indexed tokenId, address indexed user)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| user `indexed` | address | User address |

### Minted

```solidity
event Minted(address indexed creator, uint256 indexed tokenId, string indexed indexedTokenIPFSPath, string tokenIPFSPath)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| creator `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |
| indexedTokenIPFSPath `indexed` | string | undefined |
| tokenIPFSPath  | string | undefined |

### NFTMetadataUpdated

```solidity
event NFTMetadataUpdated(string name, string symbol, string baseURI)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| name  | string | undefined |
| symbol  | string | undefined |
| baseURI  | string | undefined |

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### StartTimeupdated

```solidity
event StartTimeupdated(uint256 indexed tokenId, uint256 startTime)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| startTime  | uint256 | Event startTime |

### TokenCreatorUpdated

```solidity
event TokenCreatorUpdated(address indexed fromCreator, address indexed toCreator, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| fromCreator `indexed` | address | undefined |
| toCreator `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### TokenIPFSPathUpdated

```solidity
event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenCID)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| tokenCID  | string | Event tokenCID |

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| from `indexed` | address | undefined |
| to `indexed` | address | undefined |
| tokenId `indexed` | uint256 | undefined |

### VenueContractUpdated

```solidity
event VenueContractUpdated(address venueContract)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| venueContract  | address | conversionContract address |

### WhiteList

```solidity
event WhiteList(address whiteListedAddress, bool _status)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| whiteListedAddress  | address | undefined |
| _status  | bool | undefined |



