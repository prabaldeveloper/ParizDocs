# Events

*Prabal Srivastav*

> Create and join events

Users can create event and join events



## Methods

### add

```solidity
function add(string name, string _type, string description, uint256 startTime, uint256 endTime, string tokenIPFSPath, uint256 venueTokenId, uint256 venueFees, bool isPaid) external nonpayable returns (uint256 tokenId)
```

Creates Event



#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | Event Name |
| _type | string | Event Type |
| description | string | Event description |
| startTime | uint256 | Event startTime |
| endTime | uint256 | Event endTime |
| tokenIPFSPath | string | Event tokenIPFSPath |
| venueTokenId | uint256 | venueTokenId |
| venueFees | uint256 | venueFees |
| isPaid | bool | isEventPaid |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### buyTicket

```solidity
function buyTicket(uint256 tokenId, address paymentToken, uint256 ticketPrice) external nonpayable
```

Users can buy tickets



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| paymentToken | address | Token Address |
| ticketPrice | uint256 | Ticket Price |

### join

```solidity
function join(uint256 tokenId) external nonpayable
```

Users can join events



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |

### updateDescription

```solidity
function updateDescription(uint256 tokenId, string description) external nonpayable
```

Update event description



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| description | string | Event description |

### updateStartTime

```solidity
function updateStartTime(uint256 tokenId, uint256 startTime) external nonpayable
```

Update event startDate



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| startTime | uint256 | Event startTime |

### updateTokenIPFSPath

```solidity
function updateTokenIPFSPath(uint256 tokenId, string tokenIPFSPath) external nonpayable
```

Update event IPFSPath



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Event tokenId |
| tokenIPFSPath | string | Event startTime |




