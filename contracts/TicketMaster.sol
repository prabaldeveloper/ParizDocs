// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ticket.sol";
import "./interface/IConversion.sol";
import "./interface/IEvents.sol";
import "./interface/ITreasury.sol";
import "./utils/TicketMasterStorage.sol";
import "./utils/VerifySignature.sol";

contract TicketMaster is Ticket, TicketMasterStorage, VerifySignature {
    using AddressUpgradeable for address;

    ///@param eventContract eventContract address
    event EventContractUpdated(address eventContract);

    ///@param tokenId Event tokenId
    ///@param buyer buyer address
    event Bought(
        uint256 indexed tokenId,
        address indexed buyer,
        uint256 ticketId,
        address tokenAddress,
        uint256 tokenAmount
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

    event Exited(
        uint256 indexed tokenId,
        address indexed user,
        uint256 leavingTime
    );

    event TicketFeesClaimed(
        uint256 indexed eventTokenId,
        address eventOrganiser,
        address[] tokenAddress
    );
    event TicketFeesRefund(
        uint256 indexed eventTokenId,
        address user,
        uint256 ticketId
    );

    function initialize(address earlyAdmin) public initializer {
        adminAddress[earlyAdmin] = true;
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
        uint256 eventTokenId,
        string memory name,
        uint256[2] memory time,
        uint256 totalSupply
    ) external onlyAdmin returns (address ticketNFTContract) {
        // create ticket NFT contract
        bytes memory bytecode = type(Ticket).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, eventTokenId));
        assembly {
            ticketNFTContract := create2(
                0,
                add(bytecode, 32),
                mload(bytecode),
                salt
            )
        }
        ticketNFTAddress[eventTokenId] = ticketNFTContract;
        Ticket(ticketNFTContract).init_deploy(
            name,
            "EventTicket",
            totalSupply,
            eventTokenId,
            time
        );
        return ticketNFTContract;
    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param buyTicketId Event tokenId
    ///@param tokenAddress tokenAddress
    ///@param tokenAmount ticket Price
    function buyTicket(
        uint256 buyTicketId,
        address tokenAddress,
        uint256 tokenAmount
    ) external payable {
        require(
            IEvents(eventContract)._exists(buyTicketId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCanceled(buyTicketId) == false,
            "TicketMaster: Event is canceled"
        );
        (
            ,
            uint256 endTime,
            address eventOrganiser,
            ,
            ,
            uint256 actualPrice
        ) = IEvents(eventContract).getEventDetails(buyTicketId);
        // require(actualPrice != 0, "TicketMaster: Event is free");
        require(
            block.timestamp <= endTime ||
                IEvents(eventContract).isEventEnded(eventId) == true,
            "TicketMaster: Event ended"
        );
        address conversionAddress = IEvents(eventContract)
            .getConversionContract();
        uint256 totalCapacity = Ticket(ticketNFTAddress[buyTicketId])
            .totalSupply();
        uint256 mintedToken = Ticket(ticketNFTAddress[buyTicketId]).mint(
            msg.sender
        );
        require(
            ticketSold[buyTicketId] <= totalCapacity,
            "TicketMaster: All tickets are sold"
        );
        if (actualPrice != 0) {
            checkTicketFees(
                tokenAmount,
                actualPrice,
                eventOrganiser,
                tokenAddress,
                conversionAddress,
                mintedToken,
                buyTicketId
            );
        }
        buyTicketTokenAddress[buyTicketId][mintedToken] = tokenAddress;
        ////////////not needed this two mappings
        ticketBoughtAddress[msg.sender][buyTicketId] = true;
        ticketIdOfUser[buyTicketId][msg.sender].push(mintedToken);
        ////////////////
        ticketSold[buyTicketId]++;
        emit Bought(
            buyTicketId,
            msg.sender,
            mintedToken,
            tokenAddress,
            tokenAmount
        );
    }

    ///@notice To check whether token is matic or any other token
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount price of the ticket
    function checkTicketFees(
        uint256 feeAmount,
        uint256 actualPrice,
        address eventOrganiser,
        address tokenAddress,
        address conversionAddress,
        uint256 ticketId,
        uint256 buyTicketId
    ) internal {
        // convert base token to fee token
        address baseToken = IConversion(conversionAddress).getBaseToken();
        uint256 convertedActualPrice = feeAmount;
        if (tokenAddress != baseToken) {
            convertedActualPrice = IConversion(conversionAddress).convertFee(
                tokenAddress,
                actualPrice
            );
        }
        if (tokenAddress != address(0)) {
            checkDeviation(feeAmount, convertedActualPrice);
            uint256 ticketCommissionFee = (feeAmount *
                ticketCommissionPercent) / 100;
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                IEvents(eventContract).getTreasuryContract(),
                feeAmount
            );
            ticketFeesBalance[buyTicketId][tokenAddress] += (feeAmount -
                ticketCommissionFee);
            userTicketBalance[buyTicketId][ticketId] =
                feeAmount -
                ticketCommissionFee;
        } else {
            checkDeviation(msg.value, convertedActualPrice);
            uint256 ticketCommissionFee = (msg.value *
                ticketCommissionPercent) / 100;

            (bool successOwner, ) = IEvents(eventContract)
                .getTreasuryContract()
                .call{value: msg.value}("");
            require(
                successOwner,
                "Events: Transfer to treasury contract failed"
            );
            ticketFeesBalance[buyTicketId][tokenAddress] += (msg.value -
                ticketCommissionFee);
            userTicketBalance[buyTicketId][ticketId] =
                msg.value -
                ticketCommissionFee;
        }
    }

    function claimTicketFees(
        uint256 eventTokenId,
        address[] memory tokenAddress
    ) external {
        require(
            IEvents(eventContract)._exists(eventTokenId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCanceled(eventTokenId) == false,
            "TicketMaster: Event is canceled"
        );
        (, , address payable eventOrganiser, , , ) = IEvents(eventContract)
            .getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser, "TicketMaster: Invalid Address");
        for (uint256 i = 0; i < tokenAddress.length; i++) {
            if (ticketFeesBalance[eventTokenId][tokenAddress[i]] > 0) {
                ITreasury(IEvents(eventContract).getTreasuryContract())
                    .claimFunds(
                        eventOrganiser,
                        tokenAddress[i],
                        ticketFeesBalance[eventTokenId][tokenAddress[i]]
                    );
                ticketFeesBalance[eventTokenId][tokenAddress[i]] = 0;
            }
        }

        emit TicketFeesClaimed(eventTokenId, eventOrganiser, tokenAddress);
    }

    ///@notice Users can join events
    ///@dev Public function
    ///@dev - Check whether event is started or not
    ///@dev - Check whether user has ticket if the event is paid
    ///@dev - Join the event
    ///@param eventTokenId Event tokenId
    function join(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId,
        uint256 ticketId
    ) external {
        require(
            recoverSigner(
                getMessageHash(ticketHolder, eventTokenId, ticketId),
                signature
            ) == IEvents(eventContract).getSignerAddress()
        );
        require(
            IEvents(eventContract).isEventCanceled(eventTokenId) == false,
            "TicketMaster: Event is canceled"
        );
        require(
            IEvents(eventContract)._exists(eventTokenId),
            "Events: TokenId does not exist"
        );
        (
            uint256 startTime,
            uint256 endTime,
            address eventOrganiser,
            ,
            ,

        ) = IEvents(eventContract).getEventDetails(eventTokenId);
        require(
            IEvents(eventContract).isEventStarted(eventTokenId) == true,
            "TicketMaster: Event not started"
        );
        require(
            (block.timestamp >= startTime && endTime > block.timestamp) ||
                IEvents(eventContract).isEventEnded(eventId) == true,
            "Events: Event is not live"
        );
        if (ticketHolder == eventOrganiser) {
            emit Joined(eventTokenId, ticketHolder, block.timestamp, ticketId);
        } else {
            require(
                ticketHolder ==
                    Ticket(ticketNFTAddress[eventTokenId]).ownerOf(ticketId),
                "TicketMaster: Caller is not the owner"
            );
            joinEventStatus[ticketNFTAddress[eventTokenId]][ticketId] = true;
            emit Joined(eventTokenId, ticketHolder, block.timestamp, ticketId);
        }
    }

    function exit(
        bytes memory signature,
        address ticketHolder,
        uint256 eventTokenId
    ) external {
        require(
            recoverSigner(
                getMessageHash(ticketHolder, eventTokenId, 0),
                signature
            ) == IEvents(eventContract).getSignerAddress()
        );
        require(
            IEvents(eventContract)._exists(eventTokenId),
            "Events: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventStarted(eventTokenId) == true,
            "TicketMaster: Event not started"
        );

        exitEventStatus[ticketHolder][eventTokenId] = true;

        emit Exited(eventTokenId, ticketHolder, block.timestamp);
    }

    // function refundTicketFees(uint256 eventTokenId, uint256[] memory ticketIds)
    //     external
    // {
    //     require(
    //         IEvents(eventContract)._exists(eventTokenId),
    //         "TicketMaster: TokenId does not exist"
    //     );
    //     (, uint256 endTime, , , , uint256 actualPrice) = IEvents(eventContract)
    //         .getEventDetails(eventTokenId);
    //     require(actualPrice != 0, "TicketMaster: Event is free");
    //     require(
    //         IEvents(eventContract).isEventCanceled(eventTokenId) == true ||
    //             (IEvents(eventContract).isEventStarted(eventTokenId) == false &&
    //                 block.timestamp > endTime),
    //         "TicketMaster: Event is neither canceled not expired"
    //     );
    //     address ownerAddress = msg.sender;
    //     for (uint256 i = 0; i < ticketIds.length; i++) {
    //         if (refundTicketFeesStatus[eventTokenId][ticketIds[i]] == false) {
    //             if (
    //                 ownerAddress ==
    //                 Ticket(ticketNFTAddress[eventTokenId]).ownerOf(ticketIds[i])
    //             ) {
    //                 address tokenAddress = buyTicketTokenAddress[eventTokenId][
    //                     ticketIds[i]
    //                 ];
    //                 uint256 refundAmount = userTicketBalance[eventTokenId][
    //                     ticketIds[i]
    //                 ];
    //                 ITreasury(IEvents(eventContract).getTreasuryContract())
    //                     .claimFunds(ownerAddress, tokenAddress, refundAmount);
    //                 refundTicketFeesStatus[eventTokenId][ticketIds[i]] = true;
    //                 userTicketBalance[eventTokenId][ticketIds[i]] = 0;
    //                 emit TicketFeesRefund(
    //                     eventTokenId,
    //                     ownerAddress,
    //                     ticketIds[i]
    //                 );
    //             }
    //         }
    //     }
    // }

    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
        public
        view
        returns (bool)
    {
        return joinEventStatus[_ticketNftAddress][_ticketId];
    }
}
