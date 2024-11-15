// SPDX-License-Identifier: UNLICENSED

// pragma solidity ^0.8.0;

interface IEvents {
    function _exists(uint256 eventTokenId) external view returns(bool);
    function getEventDetails(uint256 tokenId) external view returns(uint256, uint256, address payable, bool, uint256, uint256);
    function burn(uint256 tokenId) external;
    function getConversionContract() external view returns (address);
    function getDeviationPercentage() external view returns (uint256);
    function getTreasuryContract() external view returns (address);
    function isEventCancelled(uint256 eventId) external view returns(bool);
    function isEventStarted(uint256 eventId) external view returns(bool);
    function isEventEnded(uint256 eventId) external view returns(bool);
    function isErc20TokenWhitelisted(address tokenAddress) external view returns (bool);
    function isErc721TokenWhitelisted(address tokenAddress) external view returns (bool);
    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId) external view returns (bool);
}

// pragma solidity ^0.8.0;

// import "./EventStorage.sol";
// import "./EventMetadata.sol";

// contract EventAdminRole is EventStorage, EventMetadata {

//     using AddressUpgradeable for address;
//     using AddressUpgradeable for address payable;

//     ///@param venueContract venueContract address
//     event VenueContractUpdated(address venueContract);

//     // ///@param treasuryContract treasuryContract address
//     event TreasuryContractUpdated(address treasuryContract);

//     ///@param conversionContract conversionContract address
//     event ConversionContractUpdated(address conversionContract);

//     ///@param ticketMaster ticketMaster contract address
//     event TicketMasterContractUpdated(address ticketMaster);

//     ///@param isPublic isPublic true or false
//     event EventStatusUpdated(bool isPublic);

//     ///@param platformFeePercent platformFeePercent
//     event PlatformFeeUpdated(uint256 platformFeePercent);

//     ///@param tokenAddress erc-20 token Address
//     ///@param status status of the address(true or false)
//     event Erc20TokenUpdated(address indexed tokenAddress, bool status);

//     ///@param tokenAddress erc-721 token address
//     ///@param status status of the address(true or false)
//     event Erc721TokenUpdated(address indexed tokenAddress, bool status);

//     ///@param percentage deviationPercentage
//     event DeviationPercentageUpdated(uint256 percentage);

//     ///@param whitelistedAddress users address
//     ///@param status status of the address
//     event WhiteList(address whitelistedAddress, bool status);

//     ///@notice Allows Admin to update deviation percentage
//     ///@param _deviationPercentage deviationPercentage
//     function updateDeviation(uint256 _deviationPercentage) external onlyOwner {
//         deviationPercentage = _deviationPercentage;
//         emit DeviationPercentageUpdated(_deviationPercentage);
//     }

//     ///@notice Add supported Erc-20 tokens for the payment
//     ///@dev Only admin can call
//     ///@dev -  Update the status of paymentToken
//     ///@param tokenAddress erc-20 token Address
//     ///@param status status of the address(true or false)
//     function whitelistErc20TokenAddress(address tokenAddress, bool status)
//         external
//         onlyOwner
//     {
//         erc20TokenAddress[tokenAddress] = status;
//         emit Erc20TokenUpdated(tokenAddress, status);
//     }

//     ///@notice Add supported Erc-721 tokens for the payment
//     ///@dev Only admin can call
//     ///@dev -  Update the status of paymentToken
//     ///@param tokenAddress erc-721 token Address
//     ///@param status status of the address(true or false)
//     function whitelistErc721TokenAddress(address tokenAddress, bool status) external onlyOwner {
//         erc721TokenAddress[tokenAddress] = status;
//         emit Erc721TokenUpdated(tokenAddress, status);
//     }

//     ///@notice updates conversionContract address
//     ///@param _conversionContract conversionContract address
//     function updateConversionContract(address _conversionContract)
//         external
//         onlyOwner
//     {
//         require(
//             _conversionContract.isContract(),
//             "Events: Address is not a contract"
//         );
//         conversionContract = _conversionContract;
//         emit ConversionContractUpdated(_conversionContract);
//     }

//     ///@notice updates conversionContract address
//     ///@param _venueContract venueContract address
//     function updateVenueContract(address _venueContract) external onlyOwner {
//         require(
//             _venueContract.isContract(),
//             "Events: Address is not a contract"
//         );
//         venueContract = _venueContract;
//         emit VenueContractUpdated(_venueContract);
//     }

//     ///@notice updates treasuryContract address
//     ///@param _treasuryContract treasuryContract address
//     function updateTreasuryContract(address payable _treasuryContract)
//         external
//         onlyOwner
//     {
//         require(
//             _treasuryContract.isContract(),
//             "Events: Address is not a contract"
//         );
//         treasuryContract = _treasuryContract;
//         emit TreasuryContractUpdated(_treasuryContract);
//     }

//     ///@notice updates ticketMaster address
//     ///@param _ticketMaster ticketMaster address
//     function updateticketMasterContract(address _ticketMaster)
//         external
//         onlyOwner
//     {
//         require(
//             _ticketMaster.isContract(),
//             "Events: Address is not a contract"
//         );
//         ticketMaster = _ticketMaster;
//         emit TicketMasterContractUpdated(_ticketMaster);
//     }

//     ///@notice To update the event status(public or private events)
//     ///@param _isPublic true or false
//     function updateEventStatus(bool _isPublic) external onlyOwner {
//         isPublic = _isPublic;
//         emit EventStatusUpdated(_isPublic);
//     }

//     ///@notice updates platformFeePercent
//     ///@param _platformFeePercent platformFeePercent
//     function updatePlatformFee(uint256 _platformFeePercent) external onlyOwner {
//         platformFeePercent = _platformFeePercent;
//         emit PlatformFeeUpdated(_platformFeePercent);
//     }

//     ///@notice Admin can whiteList users
//     ///@param _whitelistAddresses users address
//     ///@param _status status of the address
//     function updateWhitelist(
//         address[] memory _whitelistAddresses,
//         bool[] memory _status
//     ) external onlyOwner {
//         for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
//             whiteListedAddress[_whitelistAddresses[i]] = _status[i];
//             emit WhiteList(_whitelistAddresses[i], _status[i]);
//         }
//     }

//     ///@notice Returns venue contract address
//     function getVenueContract() public view returns (address) {
//         return venueContract;
//     }

//     ///@notice Returns conversionContract address
//     function getConversionContract() public view returns (address) {
//         return conversionContract;
//     }

//     ///@notice Returns treasuryContract address
//     function getTreasuryContract() public view returns (address) {
//         return treasuryContract;
//     }

//     ///@notice Returns ticketMaster address
//     function getTicketMasterContract() public view returns (address) {
//         return ticketMaster;
//     }

//     ///@notice Returns deviationPercentage
//     function getDeviationPercentage() public view returns (uint256) {
//         return deviationPercentage;
//     }

//     ///@notice Returns platformFeePercent
//     function getPlatformFeePercent() public view returns (uint256) {
//         return platformFeePercent;
//     }

//     ///@notice Returns eventStatus
//     function getEventStatus() public view returns (bool) {
//         return isPublic;
//     }

//     ///@notice Returns whitelisted status of erc721TokenAddress
//     function isErc721TokenWhitelisted(address tokenAddress) public view returns (bool) {
//         return erc721TokenAddress[tokenAddress];
//     }

//     ///@notice Returns whitelisted status of erc20TokenAddress
//     function isErc20TokenWhitelisted(address tokenAddress) public view returns (bool) {
//         return erc20TokenAddress[tokenAddress];
//     }

//     uint256[49] private ______gap;
// }

// pragma solidity ^0.8.0;

// contract EventStorage {
//     //Details of the event
//     struct Details {
//         string name;
//         string category;
//         string description;
//         uint256 tokenId;
//         uint256 startTime;
//         uint256 endTime;
//         uint256 venueTokenId;
//         bool payNow;
//         address payable eventOrganiser;
//         uint256 ticketPrice;
//     }

//     //mapping for getting event details
//     mapping(uint256 => Details) public getInfo;

//     //mapping for getting supported erc20TokenAddress
//     mapping(address => bool) public erc20TokenAddress;

//     //mapping for getting supported erc721TokenAddress
//     mapping(address => bool) public erc721TokenAddress;

//     //mapping for featured events
//     mapping(uint256 => bool) public featuredEvents;

//     //mapping for favourite events
//     mapping(address => mapping(uint256 => bool)) public favouriteEvents;

//     //mapping for whiteListed address
//     mapping(address => bool) public whiteListedAddress;

//     //map venue ID to eventId list which are booked in that venue
//     //when new event are created, add that event id to this array
//     mapping(uint256 => uint256[]) public eventsInVenue;

//     mapping(address => mapping(uint256 => bool)) public exitEventStatus;

//     //mapping for getting rent status
//     mapping(address => mapping(uint256 => bool)) public rentStatus;

//     //mappping for storing erc20 balance against eventTokenId
//     mapping(uint256 => uint256) public balance;

//     // mapping for ticket NFT contract
//     mapping(uint256 => address) public ticketNFTAddress;

//     //mapping for storing tokenAddress against eventTokenId
//     mapping(uint256 => address) public eventTokenAddress;

//     //mapping for event start status
//     mapping(uint256 => bool) public eventStartedStatus;

//     //mapping for event cancel status
//     mapping(uint256 => bool) public eventCancelledStatus;

//     //mapping for event completed status
//     mapping(uint256 => bool) public eventCompletedStatus;

//     mapping(uint256 => bool) public eventEndedStatus;

//     mapping(address => mapping(uint256 => bool)) public joinEventStatus;

//     //block time
//     uint256 public constant blockTime = 2;

//     // Deviation Percentage
//     uint256 internal deviationPercentage;

//     //venue contract address
//     address internal venueContract;

//     //convesion contract address
//     address internal conversionContract;

//     //ticket master contract address
//     address internal ticketMaster;

//     //treasury contract
//     address payable internal treasuryContract;

//     //isPublic true or false
//     bool internal isPublic;

//     //platformFeePercent
//     uint256 internal platformFeePercent;

//     //
//     // This empty reserved space is put in place to allow future versions to add new
//     // variables without shifting down storage in the inheritance chain.
//     // See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
//     //
//     uint256[999] private ______gap;
// }


// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "./interface/IVenue.sol";
// import "./interface/IConversion.sol";
// import "./interface/ITicketMaster.sol";
// import "./interface/ITreasury.sol";
// import "./interface/ITicket.sol";
// import "./utils/EventAdminRole.sol";

// ///@title Create and join events
// ///@author Prabal Srivastav
// ///@notice Users can create event and join events

// contract EventsV1 is EventAdminRole {
    
//     ///@param tokenId Event tokenId
//     ///@param tokenCID Event tokenCID
//     ///@param venueTokenId venueTokenId
//     ///@param isEventPaid isEventPaid
//     ///@param eventOrganiser address of the organiser
//     ///@param ticketPrice ticketPrice of event
//     event EventAdded(
//         uint256 indexed tokenId,
//         string tokenCID,
//         uint256 venueTokenId,
//         bool isVenueFeesPaid,
//         bool isEventPaid,
//         address eventOrganiser,
//         uint256 ticketPrice,
//         uint256 venueFeeAmount,
//         address ticketNFTAddress
//     );

//     ///@param tokenId Event tokenId
//     ///@param startTime Event startTime
//     ///@param endTime Event endTime
//     event EventUpdated(
//         uint256 indexed tokenId,
//         string description,
//         uint256 startTime,
//         uint256 endTime,
//         uint256 venueFeeAmount
//     );

//     ///@param tokenId Event tokenId
//     event Featured(uint256 indexed tokenId, bool isFeatured);

//     ///@param user User address
//     ///@param tokenId Event tokenId
//     ///@param isFavourite is event favourite(true or false)
//     event Favourite(address user, uint256 indexed tokenId, bool isFavourite);

//     ///@param eventTokenId event tokenId
//     ///@param eventOrganiser EventOrganiser address
//     event VenueBooked(uint256 indexed eventTokenId, address eventOrganiser);

//     ///@param eventTokenId event Token Id
//     ///@param payNow pay venue fees now if(didn't pay earlier)
//     event EventPaid(uint256 indexed eventTokenId, bool payNow, uint256 venueFeeAmount);

//     ///@param eventTokenId event Token Id
//     event EventStarted(uint eventTokenId);

//     ///@param eventTokenId event Token Id
//     event EventCancelled(uint256 indexed eventTokenId);

//     event Exited(
//         uint256 indexed tokenId,
//         address indexed user,
//         uint256 leavingTime
//     );

//     // ///@param tokenId Event tokenId
//     // ///@param user User address
//     event Joined(
//         uint256 indexed tokenId,
//         address indexed user,
//         uint256 joiningTime,
//         uint256 ticketId
//     );

//     ///@param eventTokenId event Token Id
//     event EventCompleted(uint256 indexed eventTokenId);

//     event VenueFeesClaimed(uint256 indexed venueTokenId, uint256[] eventIds, address venueOwner);

//     event VenueFeesRefunded(uint256 indexed eventTokenId, address eventOrganiser);

//     event EventEnded(uint256 indexed eventTokenId);

//     //modifier for checking whitelistedUsers
//     modifier onlyWhitelistedUsers() {
//         require(
//             whiteListedAddress[msg.sender] == true || isPublic == true,
//             "Events : User address not whitelisted"
//         );
//         _;
//     }

//     //modifier for checking valid time
//     modifier isValidTime(uint256 startTime, uint256 endTime) {
//         require(
//             startTime < endTime && startTime >= block.timestamp,
//             "Invalid time input"
//         );
//         _;
//     }

//     function updateEvent(uint256 tokenId, string memory description, uint256[2] memory time) external {
//         require(_exists(tokenId), "Events: TokenId does not exist");
//         require(
//             msg.sender == getInfo[tokenId].eventOrganiser,
//             "Events: Address is not the event organiser address"
//         );
//         require(
//             getInfo[tokenId].startTime > block.timestamp,
//             "Events: Event is started"
//         );
//         uint256 venueTokenId = getInfo[tokenId].venueTokenId;
//         require(
//             isVenueAvailable(tokenId, venueTokenId, time[0], time[1], 1),
//             "Events: Venue is not available"
//         );
//         if(time[0] != getInfo[tokenId].startTime || time[1] != getInfo[tokenId].endTime) {
//             if(getInfo[tokenId].payNow == true) {
//                 uint256 feesPaid = balance[tokenId];
//                 (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
//                 venueTokenId,
//                 time[0],
//                 time[1]
//                 );
//                 address tokenAddress = IConversion(conversionContract).getBaseToken();
//                 if(feesPaid > estimatedCost - _platformFees) {
//                     ITreasury(treasuryContract).claimFunds(getInfo[tokenId].eventOrganiser,tokenAddress, feesPaid - estimatedCost - _platformFees);
//                     balance[tokenId] -=  (feesPaid - estimatedCost - _platformFees);

//                 }
//                 else {
//                     IERC20(tokenAddress).transferFrom(
//                     getInfo[tokenId].eventOrganiser,
//                     treasuryContract,
//                     estimatedCost - _platformFees - feesPaid
//                     );
//                     balance[tokenId] += estimatedCost - _platformFees - feesPaid;
//                 }
//             }
//             getInfo[tokenId].startTime = time[0];
//             getInfo[tokenId].endTime = time[1];
//         }
//         getInfo[tokenId].description = description;
//         emit EventUpdated(tokenId, description, time[0], time[1], balance[tokenId]);
//     }

//     ///@notice Creates Event
//     ///@dev Event organiser can call
//     ///@dev - Check whether venue is available.
//     ///@dev - Check whether event is paid or free for users.
//     ///@dev - Check whether venue fees is paid or it is mark as pay later.
//     ///@dev - Save all the fields in the contract.
//     ///@param details[3] => details[0] = Event name, details[1] = Event category, details[2] = Event description
//     ///@param time[2] => time[0] = Event startTime, time[1] = Event endTime
//     ///@param tokenCID Event tokenCID
//     ///@param venueTokenId venueTokenId
//     ///@param venueFeeAmount fee of the venue
//     ///@param ticketPrice ticketPrice of event
//     ///@param isEventPaid isEventPaid(true or false)
//     ///@param payNow pay venue fees now or later(true or false)
//     function add(
//         string[3] memory details,
//         uint256[2] memory time,
//         string memory tokenCID,
//         uint256 venueTokenId,
//         uint256 venueFeeAmount,
//         uint256 ticketPrice,
//         bool isEventPaid,
//         bool payNow
//     ) external onlyWhitelistedUsers {
//         uint256 _tokenId = _mintInternal(tokenCID);
//         require(
//             IVenue(getVenueContract())._exists(venueTokenId),
//             "Events: Venue tokenId does not exists"
//         );
//         require(
//             isVenueAvailable(_tokenId, venueTokenId, time[0], time[1], 0),
//             "Events: Venue is not available"
//         );
//         if (payNow == true) {
//             checkVenueFees(
//                 venueTokenId,
//                 time[0],
//                 time[1],
//                 msg.sender,
//                 _tokenId,
//                 venueFeeAmount
//             );
//         }
//         if (isEventPaid == false) {
//             ticketPrice = 0;
//         }
//         getInfo[_tokenId] = Details(
//             details[0],
//             details[1],
//             details[2],
//             _tokenId,
//             time[0],
//             time[1],
//             venueTokenId,
//             payNow,
//             payable(msg.sender),
//             ticketPrice
//         );

//         ticketNFTAddress[_tokenId] = ITicketMaster(ticketMaster)
//             .deployTicketNFT(
//                 _tokenId,
//                 details[0],
//                 time,
//                 IVenue(getVenueContract()).getTotalCapacity(venueTokenId)
//             );
//         emit EventAdded(
//             _tokenId,
//             tokenCID,
//             venueTokenId,
//             payNow,
//             isEventPaid,
//             msg.sender,
//             ticketPrice,
//             venueFeeAmount,
//             ticketNFTAddress[_tokenId] 
//         );
//     }

//     ///@notice Book venue
//     ///@param eventTokenId eventTokenId
//     function bookVenue(uint256 eventTokenId) internal {
//         rentPaid(msg.sender, eventTokenId, true);
//         emit VenueBooked(eventTokenId, msg.sender);
//     }

//     function calculateRent(
//         uint256 venueTokenId,
//         uint256 eventStartTime,
//         uint256 eventEndTime
//     )
//         public
//         view
//         returns (
//             uint256 _estimatedCost,
//             uint256 _platformFees,
//             uint256 _venueRentalCommissionFees
//         )
//     {
//         uint256 noOfBlocks = (eventEndTime - eventStartTime) / blockTime;
//         uint256 rentalFees = IVenue(getVenueContract()).getRentalFeesPerBlock(
//             venueTokenId
//         ) * noOfBlocks;
//         uint256 platformFees = (rentalFees * platformFeePercent) / 100;
//         uint256 venueRentalCommission = IVenue(getVenueContract())
//             .getVenueRentalCommission();
//         uint256 venueRentalCommissionFee = (rentalFees *
//             venueRentalCommission) / 100;
//         uint256 estimatedCost = rentalFees + platformFees;
//         return (estimatedCost, platformFees, venueRentalCommissionFee);
//     }

//     ///@notice Feature the event
//     ///@dev Only admin can call
//     ///@dev - Mark the event as featured
//     ///@param tokenId Event tokenId
//     ///@param isFeatured Event featured(true/false)
//     function featured(uint256 tokenId, bool isFeatured) external onlyOwner {
//         require(_exists(tokenId), "Events: TokenId does not exist");
//         featuredEvents[tokenId] = isFeatured;
//         emit Featured(tokenId, isFeatured);
//     }

//     ///@notice Users can mark their favourite events
//     ///@param tokenId Event tokenId
//     ///@param isFavourite Event featured(true/false)
//     function updateFavourite(uint256 tokenId, bool isFavourite) external {
//         require(_exists(tokenId), "Events: TokenId does not exist");
//         favouriteEvents[msg.sender][tokenId] = isFavourite;
//         emit Favourite(msg.sender, tokenId, isFavourite);
//     }

//     ///@notice Called by event organiser to mark the event status as completed
//     ///@param eventTokenId event token id
//     function complete(uint256 eventTokenId) external {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         require(
//             block.timestamp >= getInfo[eventTokenId].endTime,
//             "Events: Event not ended"
//         );
//         require(
//             isEventCancelled(eventTokenId) == false,
//             "Events: Event is cancelled"
//         );
//         require(
//             isEventStarted(eventTokenId) == true,
//             "Events: Event is not started"
//         );
//         require(msg.sender == getInfo[eventTokenId].eventOrganiser, "Events: Invalid Caller");
//         eventCompletedStatus[eventTokenId] = true;
//         emit EventCompleted(eventTokenId);
//     }

//     function end(uint256 eventTokenId) external {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         require(
//             isEventCancelled(eventTokenId) == false,
//             "Events: Event is cancelled"
//         );
//         require(
//             isEventStarted(eventTokenId) == true,
//             "Events: Event is not started"
//         );
//         require(msg.sender == getInfo[eventTokenId].eventOrganiser, "Events: Invalid Caller");
//         eventEndedStatus[eventTokenId] = true;
//         emit EventEnded(eventTokenId);
//     }


//     function initialize() public initializer {
//         Ownable.ownable_init();
//         _initializeNFT721Mint();
//         _updateBaseURI("https://ipfs.io/ipfs/");
//     }


//     ///@notice Returns true if rent paid
//     ///@param eventOrganiser eventOrganiser address
//     ///@param eventTokenId Event tokenId
//     function isRentPaid(address eventOrganiser, uint256 eventTokenId)
//         public
//         view
//         returns (bool)
//     {
//         return rentStatus[eventOrganiser][eventTokenId];
//     }

//     ///@notice To check amount is within deviation percentage
//     ///@param feeAmount price of the ticket
//     ///@param price price from the conversion contract
//     function checkDeviation(uint256 feeAmount, uint256 price) public view {
//         require(
//             feeAmount >= price - ((price * (deviationPercentage)) / (100)) &&
//                 feeAmount <= price + ((price * (deviationPercentage)) / (100)),
//             "Events: Amount not within deviation percentage"
//         );
//     }

//     ///@notice Check for venue availability
//     ///@param eventTokenId eventTokenId
//     ///@param venueTokenId Venue tokenId
//     ///@param startTime Venue startTime
//     ///@param endTime Venue endTime
//     ///@return _isAvailable Returns true if available
//     function isVenueAvailable(
//         uint256 eventTokenId,
//         uint256 venueTokenId,
//         uint256 startTime,
//         uint256 endTime,
//         uint256 timeType
//     ) internal isValidTime(startTime, endTime) returns (bool _isAvailable) {
//         uint256[] memory bookedEvents = eventsInVenue[venueTokenId];
//         uint256 currentTime = block.timestamp;
//         for (uint256 i = 0; i < bookedEvents.length; i++) {
//             if (bookedEvents[i] == eventTokenId || isEventCancelled(bookedEvents[i]) == true) continue;
//             else {
//                 uint256 bookedStartTime = getInfo[bookedEvents[i]].startTime;
//                 uint256 bookedEndTime = getInfo[bookedEvents[i]].endTime;
//                 // skip for passed event
//                 if (currentTime >= bookedEndTime) continue;
//                 if (
//                     currentTime >= bookedStartTime &&
//                     currentTime <= bookedEndTime
//                 ) {
//                     //check for ongoing event
//                     if (startTime >= bookedEndTime) {
//                         continue;
//                     } else {
//                         return false;
//                     }
//                 } else {
//                     //check for future event
//                     if (
//                         endTime <= bookedStartTime || startTime >= bookedEndTime
//                     ) {
//                         continue;
//                     } else {
//                         return false;
//                     }
//                 }
//             }
//         }
//         if (timeType == 0) eventsInVenue[venueTokenId].push(eventTokenId);
//         return true;
//     }

//     ///@notice To check whether token is matic or any other token
//     ///@param venueTokenId venueTokenId
//     ///@param startTime event startTime
//     ///@param endTime event endTime
//     ///@param eventOrganiser event organiser address
//     ///@param eventTokenId event tokenId
//     ///@param feeAmount fee of the venue(rentalFee + platformFee)
//     function checkVenueFees(
//         uint256 venueTokenId,
//         uint256 startTime,
//         uint256 endTime,
//         address eventOrganiser,
//         uint256 eventTokenId,
//         uint256 feeAmount
//     ) internal {
//         address tokenAddress = IConversion(conversionContract).getBaseToken();
//         require(
//             erc20TokenAddress[tokenAddress] == true,
//             "Events: PaymentToken Not Supported"
//         );
//         (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
//             venueTokenId,
//             startTime,
//             endTime
//         );
//         uint256 platformFees = _platformFees;
//         checkDeviation(feeAmount, estimatedCost);
//         IERC20(tokenAddress).transferFrom(
//             eventOrganiser,
//             treasuryContract,
//             feeAmount
//         );
//         balance[eventTokenId] = feeAmount - platformFees;
//         eventTokenAddress[eventTokenId] = tokenAddress;
//         bookVenue(eventTokenId);
//     }

//     function claimVenueFees(uint256 venueTokenId) external {
//         require(
//             IVenue(getVenueContract())._exists(venueTokenId),
//             "Events: Venue tokenId does not exists"
//         );
//         uint256[] memory eventIds = eventsInVenue[venueTokenId];
//         address tokenAddress = IConversion(conversionContract).getBaseToken();
//         address venueOwner = IVenue(getVenueContract()).getVenueOwner(venueTokenId);
//         require(msg.sender == venueOwner, "Events: Invalid Caller");
//         for(uint256 i=0; i< eventIds.length; i++) {
//             if(isEventCancelled(eventIds[i]) == false && block.timestamp > getInfo[eventIds[i]].endTime) {
//                 if(balance[eventIds[i]] > 0) {
//                     ITreasury(treasuryContract).claimFunds(venueOwner,tokenAddress, balance[eventIds[i]]);
//                     balance[eventIds[i]] = 0;
//                 }
//             }
//         }
//         emit VenueFeesClaimed(venueTokenId, eventIds, venueOwner);
//     }

//     function refundVenueFees(uint256 eventTokenId) external {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         require(
//             isEventCancelled(eventTokenId) == true,
//             "Events: Event is not cancelled"
//         );
//         require(msg.sender == getInfo[eventTokenId].eventOrganiser, "Events: Invalid Address");
//         require(getInfo[eventTokenId].payNow == true, "Events: Fees not paid");
//         address tokenAddress = IConversion(conversionContract).getBaseToken();
//          (, , uint256 venueRentalCommissionFees) = calculateRent(
//             getInfo[eventTokenId].venueTokenId,
//             getInfo[eventTokenId].startTime,
//             getInfo[eventTokenId].endTime
//         );
//         require(balance[eventTokenId] > 0, "Events: Funds already transferred");
//         address venueOwner = IVenue(getVenueContract()).getVenueOwner(getInfo[eventTokenId].venueTokenId);
//         ITreasury(treasuryContract).claimFunds(getInfo[eventTokenId].eventOrganiser,tokenAddress, balance[eventTokenId] - venueRentalCommissionFees);
//         ITreasury(treasuryContract).claimFunds(venueOwner, tokenAddress, venueRentalCommissionFees);
//         balance[eventTokenId] = 0;

//         emit VenueFeesRefunded(eventTokenId, getInfo[eventTokenId].eventOrganiser);

//     }


//     ///@notice Start the event
//     ///@param eventTokenId event Token Id
//     ///@param venueFeeAmount fee of the venue
//     function payEvent(uint256 eventTokenId, uint256 venueFeeAmount)
//         external
//     {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         (
//             uint256 startTime,
//             uint256 endTime,
//             address eventOrganiser,
//             bool payNow,
//             uint256 venueTokenId,

//         ) = getEventDetails(eventTokenId);
//         require(
//             endTime > block.timestamp,
//             "Events: Event ended"
//         );
//         require(msg.sender == eventOrganiser, "Events: Invalid Address");

//         require(
//             eventStartedStatus[eventTokenId] == false,
//             "Events: Event already started"
//         );
//         if (payNow == false) {
//             checkVenueFees(
//                 venueTokenId,
//                 startTime,
//                 endTime,
//                 msg.sender,
//                 eventTokenId,
//                 venueFeeAmount
//             );
//             payNow = true;
//             getInfo[eventTokenId].payNow = payNow;
            
//         }
//         else {
//             uint256 feesPaid = balance[eventTokenId];
//             (uint256 estimatedCost, uint256 _platformFees, ) = calculateRent(
//             venueTokenId,
//             startTime,
//             endTime
//             );
//             address tokenAddress = IConversion(conversionContract).getBaseToken();
//             if(feesPaid > estimatedCost - _platformFees) {
//                 ITreasury(treasuryContract).claimFunds(eventOrganiser,tokenAddress, feesPaid - estimatedCost - _platformFees);
//                 //IERC20(tokenAddress).transfer(eventOrganiser, feesPaid - estimatedCost - _platformFees);
//                 balance[eventTokenId] -=  (feesPaid - estimatedCost - _platformFees);

//             }
//             else {
//                 IERC20(tokenAddress).transferFrom(
//                 eventOrganiser,
//                 treasuryContract,
//                 estimatedCost - _platformFees - feesPaid
//                 );
//                 balance[eventTokenId] += estimatedCost - _platformFees - feesPaid;
//             }
//         }
//         emit EventPaid(eventTokenId, payNow, venueFeeAmount);
//     }

//     function startEvent(uint256 eventTokenId) external {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         (
//             uint256 startTime,
//             uint256 endTime,
//             address eventOrganiser,
//             bool payNow,
//             ,

//         ) = getEventDetails(eventTokenId);
//         require(
//             block.timestamp >= startTime && endTime > block.timestamp,
//             "Events: Event not live"
//         );
//         require(msg.sender == eventOrganiser, "Events: Invalid Address");
//         require(payNow == true, "Events: Fees not paid");
//         eventStartedStatus[eventTokenId] = true;
//         emit EventStarted(eventTokenId);

//     }

//     ///@notice Cancel the event
//     ///@param eventTokenId event Token Id
//     function cancelEvent(uint256 eventTokenId) external {
//         require(_exists(eventTokenId), "Events: TokenId does not exist");
//         (
//             ,
//             ,
//             address payable eventOrganiser,
//             ,
//             ,

//         ) = getEventDetails(eventTokenId);
//         require(isEventStarted(eventTokenId) == false, "Events: Event started");
//         require(msg.sender == eventOrganiser, "Events: Invalid Address");
//         require(
//             eventCancelledStatus[eventTokenId] == false,
//             "Events: Event already cancelled"
//         );
        
//         eventCancelledStatus[eventTokenId] = true;
//         emit EventCancelled(eventTokenId);
//     }

//     function exit(uint256 eventTokenId) external {
//         require(
//             _exists(eventTokenId),
//             "Events: TokenId does not exist"
//         );
//         require(
//          isEventStarted(eventTokenId) == true,
//             "Events: Event not started"
//         );
//         exitEventStatus[msg.sender][eventTokenId] = true;
//         emit Exited(eventTokenId, msg.sender, block.timestamp);

//     }

    
//     ///@notice Users can join events
//     ///@dev Public function
//     ///@dev - Check whether event is started or not
//     ///@dev - Check whether user has ticket if the event is paid
//     ///@dev - Join the event
//     ///@param eventTokenId Event tokenId
//     function join(uint256 eventTokenId, uint256 ticketId) external {
//         require(
//             isEventCancelled(eventTokenId) == false,
//             "Events: Event is cancelled"
//         );
//         require(
//             _exists(eventTokenId),
//             "Events: TokenId does not exist"
//         );
//         (uint256 startTime, uint256 endTime, address eventOrganiser , , , ) = getEventDetails(eventTokenId);
//         require(
//             isEventStarted(eventTokenId) == true,
//             "Events: Event not started"
//         );
//         require(
//             block.timestamp >= startTime && endTime > block.timestamp || isEventEnded(eventTokenId) == true,
//             "Events: Event is not live" 
//         );
//         if(msg.sender == eventOrganiser) {
//             emit Joined(eventTokenId, msg.sender, block.timestamp, ticketId);
//         }
//         else {
//             require(
//                 msg.sender == ITicket(ticketNFTAddress[eventTokenId]).ownerOf(ticketId),
//                 "Events: Caller is not the owner"
//             );
//             joinEventStatus[ticketNFTAddress[eventTokenId]][ticketId] = true;
//             emit Joined(eventTokenId, msg.sender, block.timestamp, ticketId);
//         }
//     }

//     ///@notice Saves the status whether rent is paid or not
//     ///@param eventOrganiser Event organiser address
//     ///@param eventTokenId Event tokenId
//     ///@param _isRentPaid true or false
//     function rentPaid(
//         address eventOrganiser,
//         uint256 eventTokenId,
//         bool _isRentPaid
//     ) internal {
//         rentStatus[eventOrganiser][eventTokenId] = _isRentPaid;
//     }

//     function isEventStarted(uint256 eventId) public view returns (bool) {
//         return eventStartedStatus[eventId];
//     }

//     function isEventCancelled(uint256 eventId) public view returns (bool) {
//         return eventCancelledStatus[eventId];
//     }

//     function isEventEnded(uint256 eventId) public view returns (bool) {
//         return eventEndedStatus[eventId];
        
//     }

//     function getEventDetails(uint256 tokenId)
//         public
//         view
//         returns (
//             uint256 startTime,
//             uint256 endTime,
//             address payable eventOrganiser,
//             bool payNow,
//             uint256 venueTokenId,
//             uint256 ticketPrice
//         )
//     {
//         return (
//             getInfo[tokenId].startTime,
//             getInfo[tokenId].endTime,
//             getInfo[tokenId].eventOrganiser,
//             getInfo[tokenId].payNow,
//             getInfo[tokenId].venueTokenId,
//             getInfo[tokenId].ticketPrice
//         );
//     }

//       function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
//         public
//         view
//         returns (bool)
//     {
//         return joinEventStatus[_ticketNftAddress][_ticketId];
//     }
// }
