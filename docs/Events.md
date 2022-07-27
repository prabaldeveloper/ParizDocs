# Events

*Prabal Srivastav*

> Create and join events

Users can create event and join events



## Methods

### add

```solidity
function add(string name, string _type, string description, uint256 startTime, uint256 endTime, string tokenIPFSPath, uint256 venueTokenId, uint256 venueFees, bool isPaid, uint256 ticketPrice) external nonpayable returns (uint256 tokenId)
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
| ticketPrice | uint256 | ticketPrice of event |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | Returns tokenId of the event |

### buyTicket

```solidity
function buyTicket(uint256 tokenId, address paymentToken, uint256 ticketPrice) external payable
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

### updateErc20TokenAddress

```solidity
function updateErc20TokenAddress(address paymentToken, bool status) external nonpayable
```

Supported tokens for the payment



#### Parameters

| Name | Type | Description |
|---|---|---|
| paymentToken | address | erc-20 token Address |
| status | bool | status of the address(true or false) |

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



## Events

### Bought

```solidity
event Bought(uint256 indexed tokenId, address paymentToken, uint256 ticketPrice, address buyer)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| paymentToken  | address | Token Address |
| ticketPrice  | uint256 | Ticket Price |
| buyer  | address | buyer address  |

### DescriptionUpdated

```solidity
event DescriptionUpdated(uint256 indexed tokenId, string description)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| description  | string | Event description |

### EventAdded

```solidity
event EventAdded(uint256 indexed tokenId, string name, string _type, string description, uint256 startTime, uint256 endTime, string tokenIPFSPath, uint256 venueTokenId, uint256 venueFees, bool isPaid, address eventOrganiser, uint256 ticketPrice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| name  | string | Event Name |
| _type  | string | Event Type |
| description  | string | Event description |
| startTime  | uint256 | Event startTime |
| endTime  | uint256 | Event endTime |
| tokenIPFSPath  | string | Event tokenIPFSPath |
| venueTokenId  | uint256 | venueTokenId |
| venueFees  | uint256 | venueFees |
| isPaid  | bool | isEventPaid |
| eventOrganiser  | address | address of the organiser |
| ticketPrice  | uint256 | ticketPrice of event |

### Joined

```solidity
event Joined(uint256 indexed tokenId, address indexed user)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| user `indexed` | address | User address |

### StartTimeupdated

```solidity
event StartTimeupdated(uint256 indexed tokenId, uint256 startTime)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |
| startTime  | uint256 | undefined |

### TokenIPFSPathUpdated

```solidity
event TokenIPFSPathUpdated(uint256 indexed tokenId, string tokenIPFSPath)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |
| tokenIPFSPath  | string | Event tokenIPFSPath |



