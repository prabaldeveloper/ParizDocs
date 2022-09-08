// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ticket.sol";
import "./interface/IConversion.sol";
import "./interface/IEvents.sol";
import "./interface/ITreasury.sol";

contract TicketMaster is Ticket {
    using AddressUpgradeable for address;
    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    //mapping for storing user's address who bought the ticket of an event
    mapping(address => mapping(uint256 => bool)) public ticketBoughtAddress;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    //mapping for getting ticket id of user
    mapping(address => mapping(uint256 => uint256)) public ticketIdOfUser;

    mapping(address => mapping(uint256 => bool)) public joinEventStatus;

    //mapping for getting the tokenAddress using which ticket can be bought
    mapping(uint256 => mapping(uint256 => address))
        public buyTicketTokenAddress;

    mapping(uint256 => mapping(address => uint256)) public ticketFeesBalance;

    mapping(uint256 => mapping(uint256 => bool)) public refundTicketFeesStatus;

    //mapping for storing owner address status
    mapping(address => bool) public adminAddress;

    //event contract address
    address private eventContract;

    //manageEvent contract address
    // address private manageEventContract;

    //ticketCommission
    uint256 private ticketCommissionPercent;

    ///@param eventContract eventContract address
    event EventContractUpdated(address eventContract);

    // ///@param manageEventContract manageEvent address
    // event ManageEventContractUpdated(address manageEventContract);

    ///@param tokenId Event tokenId
    ///@param buyer buyer address
    event Bought(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 ticketId
    );

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@param tokenId Event tokenId
    ///@param user User address
    event Joined(
        uint256 indexed tokenId,
        address indexed user,
        uint256 joiningTime,
        uint256 ticketId
    );

    event RefundClaimed(uint256 indexed eventTokenId, uint256 ticketId);

    function initialize(address earlyAdmin) public initializer {
        adminAddress[earlyAdmin] == true;
        Ownable.ownable_init();
    }

    modifier onlyAdmin() {
        require(
            adminAddress[msg.sender] == true,
            "TicketMaster: Caller is not the admin"
        );
        _;
    }

    receive() external payable {}

    ///@notice updates eventContract address
    ///@param _eventContract eventContract address
    function updateEventContract(address _eventContract) external onlyOwner {
        require(
            _eventContract.isContract(),
            "TicketMaster: Address is not a contract"
        );
        eventContract = _eventContract;
        emit EventContractUpdated(_eventContract);
    }

    // ///@notice updates _manageEventContract address
    // ///@param _manageEventContract _manageEventContract address
    // function updateManageEventContract(address _manageEventContract)
    //     external
    //     onlyOwner
    // {
    //     require(
    //         _manageEventContract.isContract(),
    //         "TicketMaster: Address is not a contract"
    //     );
    //     manageEventContract = _manageEventContract;
    //     emit ManageEventContractUpdated(_manageEventContract);
    // }

    ///@notice updates ticketCommissionPercent
    ///@param _ticketCommissionPercent ticketCommissionPercent
    function updateTicketCommission(uint256 _ticketCommissionPercent)
        external
        onlyOwner
    {
        ticketCommissionPercent = _ticketCommissionPercent;
        emit TicketCommissionUpdated(ticketCommissionPercent);
    }

    ///@notice updates ownerStatus
    ///@param _owner owner address
    ///@param status status(true or false)
    function whitelistAdmin(address _owner, bool status) external onlyOwner {
        adminAddress[_owner] = status;
    }

    ///@notice To check amount is within deviation percentage
    ///@param feeAmount price of the ticket
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        uint256 deviationPercentage = IEvents(eventContract)
            .getDeviationPercentage();
        require(
            feeAmount >= price - ((price * (deviationPercentage)) / (100)) &&
                feeAmount <= price + ((price * (deviationPercentage)) / (100)),
            "Events: Amount not within deviation percentage"
        );
    }

    function deployTicketNFT(
        uint256 eventId,
        string memory name,
        uint256[2] memory time,
        uint256 totalSupply
    ) external onlyAdmin returns (address ticketNFTContract) {
        // create ticket NFT contract
        bytes memory bytecode = type(Ticket).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, eventId));
        assembly {
            ticketNFTContract := create2(
                0,
                add(bytecode, 32),
                mload(bytecode),
                salt
            )
        }
        ticketNFTAddress[eventId] = ticketNFTContract;
        Ticket(ticketNFTContract).init_deploy(
            name,
            "EventTicket",
            totalSupply,
            eventId,
            time
        );
        return ticketNFTContract;
    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param eventId Event tokenId
    ///@param tokenAddress tokenAddress
    ///@param tokenAmount ticket Price
    function buyTicket(
        uint256 eventId,
        address tokenAddress,
        uint256 tokenAmount
    ) external payable {
        require(
            IEvents(eventContract)._exists(eventId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCanceled(eventId) == false,
            "TicketMaster: Event is canceled"
        );
        (
            ,
            uint256 endTime,
            address eventOrganiser,
            ,
            ,
            uint256 actualPrice
        ) = IEvents(eventContract).getEventDetails(eventId);
        require(actualPrice != 0, "TicketMaster: Event is free");
        require(block.timestamp <= endTime, "TicketMaster: Event ended");

        address conversionAddress = IEvents(eventContract)
            .getConversionContract();
        uint256 totalCapacity = Ticket(ticketNFTAddress[eventId]).totalSupply();
        uint256 mintedToken = Ticket(ticketNFTAddress[eventId]).mint(
            msg.sender
        );
        require(
            ticketSold[eventId] <= totalCapacity,
            "TicketMaster: All tickets are sold"
        );
        checkTicketFees(
            tokenAmount,
            actualPrice,
            eventOrganiser,
            tokenAddress,
            conversionAddress
        );
        buyTicketTokenAddress[eventId][mintedToken] = tokenAddress;
        ////////////not needed this two mappings
        ticketBoughtAddress[msg.sender][eventId] = true;
        ticketIdOfUser[msg.sender][eventId] = mintedToken;
        ////////////////
        ticketSold[eventId]++;
        emit Bought(eventId, msg.sender, mintedToken);
    }

    ///@notice To check whether token is matic or any other token
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount price of the ticket
    function checkTicketFees(
        uint256 feeAmount,
        uint256 actualPrice,
        address eventOrganiser,
        address tokenAddress,
        address conversionAddress
    ) internal {
        // convert base token to fee token
        uint256 convertedActualPrice = IConversion(conversionAddress)
            .convertFee(tokenAddress, actualPrice);
        if (tokenAddress != address(0)) {
            checkDeviation(feeAmount, convertedActualPrice);
            uint256 ticketCommissionFee = (feeAmount *
                ticketCommissionPercent) / 100;
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                IEvents(eventContract).getTreasuryContract(),
                feeAmount
            );
            ticketFeesBalance[eventId][tokenAddress] += (feeAmount -
                ticketCommissionFee);
        } else {
            checkDeviation(msg.value, convertedActualPrice);
            uint256 ticketCommissionFee = (msg.value *
                ticketCommissionPercent) / 100;

            (bool successOwner, ) = IEvents(eventContract).getTreasuryContract().call{
                value: msg.value
            }("");
            require(
                successOwner,
                "Events: Transfer to treasury contract failed"
            );
            // (bool successTreasury, ) = IEvents(eventContract)
            //     .getTreasuryContract()
            //     .call{value: ticketCommissionFee}("");
            // require(
            //     successTreasury,
            //     "Events: Transfer to treasury contract failed"
            // );
            ticketFeesBalance[eventId][tokenAddress] += (msg.value -
                ticketCommissionFee);
        }
    }

    function claimTicketFees(uint256 eventTokenId, address[] memory tokenAddress) external {
        require(
            IEvents(eventContract)._exists(eventId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCanceled(eventId) == false,
            "TicketMaster: Event is canceled"
        );
        (, , address payable eventOrganiser, , , ) = IEvents(eventContract)
            .getEventDetails(eventId);
        require(msg.sender == eventOrganiser, "TicketMaster: Invalid Address");
        for(uint256 i=0; i< tokenAddress.length; i++) {
            require(ticketFeesBalance[eventTokenId][tokenAddress[i]] > 0, "TicketMaster:  Funds already transferred");
            ITreasury(IEvents(eventContract).getTreasuryContract()).claimFunds(eventOrganiser, tokenAddress[i],ticketFeesBalance[eventId][tokenAddress[i]]);
            ticketFeesBalance[eventId][tokenAddress[i]] = 0;
        }
    }

    ///@notice Users can join events
    ///@dev Public function
    ///@dev - Check whether event is started or not
    ///@dev - Check whether user has ticket if the event is paid
    ///@dev - Join the event
    ///@param eventId Event tokenId
    function join(uint256 eventId, uint256 ticketId) external {
        require(
            IEvents(eventContract).isEventCanceled(eventId) == false,
            "TicketMaster: Event is canceled"
        );

        require(
            IEvents(eventContract)._exists(eventId),
            "Events: TokenId does not exist"
        );
        (uint256 startTime, uint256 endTime, , bool payNow, , ) = IEvents(
            eventContract
        ).getEventDetails(eventId);
        if (payNow == false) {
            require(
                IEvents(eventContract).isEventStarted(eventId) == true,
                "TicketMaster: Event not started"
            );
        }
        require(
            block.timestamp >= startTime && endTime > block.timestamp,
            "Events: Event is not live"
        );
        // require(
        //     ticketBoughtAddress[msg.sender][eventId] == true,
        //     "Events: User has no ticket"
        // );
        //
        require(
            msg.sender == Ticket(ticketNFTAddress[eventId]).ownerOf(ticketId),
            "TicketMaster: Caller is not the owner"
        );
        joinEventStatus[ticketNFTAddress[eventId]][ticketId] = true;

        emit Joined(eventId, msg.sender, block.timestamp, ticketId);
    }

    function refundTicketFees(uint256 eventTokenId, uint256 ticketId) external {
        require(
            IEvents(eventContract)._exists(eventId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCanceled(eventId) == true,
            "TicketMaster: Event is not canceled"
        );
        require(
            refundTicketFeesStatus[eventTokenId][ticketId] == false,
            "TicketMaster: Funds already transferred"
        );
        require(
            msg.sender == Ticket(ticketNFTAddress[eventId]).ownerOf(ticketId),
            "TicketMaster: Caller is not the owner"
        );
        (, , , , , uint256 actualPrice) = IEvents(eventContract)
            .getEventDetails(eventId);
        require(actualPrice != 0, "TicketMaster: Event is free");
        address tokenAddress = buyTicketTokenAddress[eventId][ticketId];
        address conversionAddress = IEvents(eventContract)
            .getConversionContract();
        uint256 convertedActualPrice = IConversion(conversionAddress)
            .convertFee(tokenAddress, actualPrice);
        uint256 ticketCommissionFee = (convertedActualPrice *
            ticketCommissionPercent) / 100;
        ITreasury(IEvents(eventContract).getTreasuryContract()).claimFunds(payable(msg.sender), tokenAddress,convertedActualPrice - ticketCommissionFee);
        // if (tokenAddress == address(0)) {
        //     payable(msg.sender).transfer(
        //         convertedActualPrice - ticketCommissionFee
        //     );
        // } else {
        //     IERC20(tokenAddress).transfer(
        //         msg.sender,
        //         convertedActualPrice - ticketCommissionFee
        //     );
        // }
        refundTicketFeesStatus[eventTokenId][ticketId] == true;
        emit RefundClaimed(eventTokenId, ticketId);
    }

    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
        public
        view
        returns (bool)
    {
        return joinEventStatus[_ticketNftAddress][_ticketId];
    }
}
