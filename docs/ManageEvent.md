# ManageEvent

*Prabal Srivastav*

> Manage the events

Event owner can start event or can cancel event



## Methods

### addGuests

```solidity
function addGuests(uint256 eventTokenId, string guestName, address guestAddress) external nonpayable
```

Add the event guests



#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId | uint256 | event Token Id |
| guestName | string | guest Name  |
| guestAddress | address | guest Address |

### cancelEvent

```solidity
function cancelEvent(uint256 eventTokenId) external nonpayable
```

Cancel the event



#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId | uint256 | event Token Id |

### startEvent

```solidity
function startEvent(uint256 eventTokenId) external nonpayable
```

Start the event



#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId | uint256 | event Token Id |



## Events

### CancelEvent

```solidity
event CancelEvent(uint256 indexed eventTokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId `indexed` | uint256 | event Token Id |

### EventStarted

```solidity
event EventStarted(uint256 indexed eventTokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId `indexed` | uint256 | event Token Id |

### GuestAdded

```solidity
event GuestAdded(uint256 indexed eventTokenId, string guestName, address guestAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| eventTokenId `indexed` | uint256 | event Token Id |
| guestName  | string | guest Name  |
| guestAddress  | address | guest Address |



