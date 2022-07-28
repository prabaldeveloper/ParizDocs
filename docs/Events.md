# Events

*Prabal Srivastav*

> Create and join events

Users can create event and join events



## Methods

### add

```solidity
function add(string name, string _type, string description, uint256 startTime, uint256 endTime, string tokenIPFSPath, uint256 venueTokenId, uint256 venueFees, bool payLater, bool isEventPaid, uint256 ticketPrice) external nonpayable returns (uint256 tokenId)
```

- Check whether venue is available. - Check whether event is paid or free for users. - Check whether venue fees is paid or it is mark as pay later. - Save all the fields in the contract.



#### Parameters

| Name | Type | Description |
|---|---|---|
| name | string | undefined |
| _type | string | undefined |
| description | string | undefined |
| startTime | uint256 | undefined |
| endTime | uint256 | undefined |
| tokenIPFSPath | string | undefined |
| venueTokenId | uint256 | undefined |
| venueFees | uint256 | undefined |
| payLater | bool | undefined |
| isEventPaid | bool | undefined |
| ticketPrice | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### buyTicket

```solidity
function buyTicket(uint256 tokenId, address paymentToken, uint256 ticketPrice) external payable
```

- Check whether event is paid or free - Check whether user paid the price. - Map event tokenId with user address



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| paymentToken | address | undefined |
| ticketPrice | uint256 | undefined |

### featured

```solidity
function featured(uint256 tokenId) external nonpayable
```

- Mark the event as featured



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### join

```solidity
function join(uint256 tokenId) external nonpayable
```

- Check whether event is started or not - Check whether user has ticket if event is paid - Join the event



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### updateDescription

```solidity
function updateDescription(uint256 tokenId, string description) external nonpayable
```

- Check whether event is started or not - Update the event description



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| description | string | undefined |

### updateErc20TokenAddress

```solidity
function updateErc20TokenAddress(address paymentToken, bool status) external nonpayable
```

- Update the status of paymentToken



#### Parameters

| Name | Type | Description |
|---|---|---|
| paymentToken | address | undefined |
| status | bool | undefined |

### updateStartTime

```solidity
function updateStartTime(uint256 tokenId, uint256 startTime) external nonpayable
```

- Check whether event is started or not. - Update the event startTime .



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| startTime | uint256 | undefined |

### updateTokenIPFSPath

```solidity
function updateTokenIPFSPath(uint256 tokenId, string tokenIPFSPath) external nonpayable
```

- Check whether event is started or not - Update the event IPFSPath 



#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| tokenIPFSPath | string | undefined |



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

### Featured

```solidity
event Featured(uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | Event tokenId |

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



