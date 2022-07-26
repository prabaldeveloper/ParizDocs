# Venue

*Prabal Srivastav*

> Add and book venue 

Owner can add venues and event organisers can book it



## Methods

### add

```solidity
function add(string name, string location, uint256 totalCapacity, uint256 fees, string tokenIPFSPath) external nonpayable returns (uint256 tokenId)
```

Adds venue



#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Venue name |
| location | string | Venue location |
| totalCapacity | uint256 | Venue totalCapacity |
| fees | uint256 | Venue Fees |
| tokenIPFSPath | string | Venue tokenIPFSPath |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | tokenId of the venue |

### bookVenue

```solidity
function bookVenue(uint256 tokenId, uint256 venueFees) external payable
```

Book venue



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Venue tokenId |
| venueFees | uint256 | Venue fees  |

### calculateRent

```solidity
function calculateRent(uint256 tokenId, uint256 startTime, uint256 endTime) external nonpayable returns (uint256 rent)
```

Calculate rent for the venue



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Venue tokenId |
| startTime | uint256 | Venue startTime |
| endTime | uint256 | Venue endTime |

#### Returns

| Name | Type | Description |
|---|---|---|
| rent | uint256 | Returns the rent of the venue |

### isAvailable

```solidity
function isAvailable(uint256 tokenId, uint256 startTime, uint256 endTime) external nonpayable returns (bool _isAvailable)
```

Check for venue availability



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Venue tokenId |
| startTime | uint256 | Venue startTime |
| endTime | uint256 | Venue endTime |

#### Returns

| Name | Type | Description |
|---|---|---|
| _isAvailable | bool | Returns true if available |



## Events

### VenueAdded

```solidity
event VenueAdded(uint256 indexed tokenId, string name, string location, uint256 totalCapacity, string tokenIPFSPath, uint256 fees)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |
| name  | string | undefined |
| location  | string | undefined |
| totalCapacity  | uint256 | undefined |
| tokenIPFSPath  | string | undefined |
| fees  | uint256 | undefined |

### VenueBooked

```solidity
event VenueBooked(uint256 indexed tokenId, address eventOrganiser)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |
| eventOrganiser  | address | undefined |



