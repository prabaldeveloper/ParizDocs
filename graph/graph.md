# Graph for Pariz
##### Graph name – pariz

*Prabal Srivastav*

> Graph for getting the event, venue and userHistory details.





## Methods
Schema Name – events

### getEventDetails

```solidity
function getEventDetails(BigInt skip, BigInt count, String orderBy, String orderDirection)
```

Returns event details


#### Parameters

| Name | Type | Description |
|---|---|---|
| skip | BigInt | Number of event details to be skipped|
| count | BigInt | Number of event details to be displayed|
| orderBy | String | Order the event details|
| orderDirection | String | asc or desc order|


#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | BigInt | TokenId of the event |
| name | String | Name of the event |
| type | String | type of the event |
| description | String | Description of the event |
| startTime | BigInt | StartTime of the event |
| endTime | BigInt | EndTime of the event |
| tokenIPFSPath | String | TokenIPFSPath of the event |
| isPaid | Boolean | IsPaid of the event |
| ticketPrice | BigInt | TicketPrice of the event |
| transactionHash | Bytes | TransactionHash of the event |
| timestamp | BigInt | Timestamp of the event |
| eventOrganiser | Bytes | eventOrganiser address of the event | 

Schema Name – venues
### getVenueDetails

```solidity
function getVenueDetails(BigInt skip, BigInt count, String orderBy, String orderDirection)
```

Returns venue details



#### Parameters

| Name | Type | Description |
|---|---|---|
| skip | BigInt | Number of venue details to be skipped|
| count | BigInt | Number of venue details to be displayed|
| orderBy | String | Order the venue details|
| orderDirection | String | asc or desc order|


#### Returns

| Name | Type | Description |
|---|---|---|
| tokenId | BigInt | TokenId of the venue |
| name | String | Name of the venue |
| location | String | Location of the venue |
| totalCapacity | BigInt | totalCapacity of the venue |
| fees | BigInt | fees of the venue |
| tokenIPFSPath | String | TokenIPFSPath of the venue |
| transactionHash | Bytes | TransactionHash of the venue |
| timestamp | BigInt | Timestamp of the venue |



Schema Name – userHistory
### getUserHistory

```solidity
function getUserHistory(BigInt skip, BigInt count, String orderBy, String orderDirection)
```


#### Parameters

| Name | Type | Description |
|---|---|---|
| skip | BigInt | Number of venue details to be skipped|
| count | BigInt | Number of venue details to be displayed|
| orderBy | String | Order the venue details|
| orderDirection | String | asc or desc order|


#### Returns

| Name | Type | Description |
|---|---|---|
| eventTokenId | BigInt | TokenId of the event |
| eventName | String | Name of the event |
| eventType | String | Type of the event |
| eventDescription | String | Description of the event |
| userAddress | Bytes | user address | 
| joiningTime | BigInt | joiningTime of the event |
| leavingTime | BigInt | leavingTime of the event |