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
| tokenId | uint256 | of the venue |

### bookVenue

```solidity
function bookVenue(uint256 tokenId, uint256 venueFees) external nonpayable
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




