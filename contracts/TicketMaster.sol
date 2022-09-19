// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ticket.sol";
import "./interface/IConversion.sol";
import "./interface/IEvents.sol";
import "./interface/ITreasury.sol";
import "./utils/TicketMasterStorage.sol";

contract TicketMaster is Ticket, TicketMasterStorage {
    using AddressUpgradeable for address;

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

    event TicketFeesClaimed(uint256 indexed eventTokenId, address eventOrganiser, address[] tokenAddress);
    event TicketFeesRefund(uint256 indexed eventTokenId, address user, uint256 ticketId);

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

     function getEventContract() public view returns (address) {
        return eventContract;
    }

    function getTicketCommissionPercent() public view returns (uint256) {
        return ticketCommissionPercent;
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
            "TicketMaster: Amount not within deviation percentage"
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
        uint256 tokenAmount,
        string memory tokenType
    ) external payable {
        require(
            IEvents(eventContract)._exists(buyTicketId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCancelled(buyTicketId) == false,
            "TicketMaster: Event is cancelled"
        );
        (
            , uint256 endTime,
            , , , uint256 actualPrice
        ) = IEvents(eventContract).getEventDetails(buyTicketId);
        require(block.timestamp <= endTime || IEvents(eventContract).isEventEnded(buyTicketId) == true, "TicketMaster: Event ended");
        uint256 totalCapacity = Ticket(ticketNFTAddress[buyTicketId]).totalSupply();
        uint256 mintedToken = Ticket(ticketNFTAddress[buyTicketId]).mint(
            msg.sender
        );
        require(
            ticketSold[buyTicketId] <= totalCapacity,
            "TicketMaster: All tickets are sold"
        );
        if(actualPrice != 0) {
            checkTicketFees(
                tokenAmount,
                actualPrice,
                tokenAddress,
                mintedToken,
                buyTicketId,
                tokenType
            );
        }
        buyTicketTokenAddress[buyTicketId][mintedToken] = tokenAddress;
        ticketSold[buyTicketId]++;
        emit Bought(buyTicketId, msg.sender, mintedToken, tokenAddress, tokenAmount);
    }

    ///@notice To check whether token is matic or any other token
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount price of the ticket
    ///@param tokenAddress tokenAddress
    ///@param ticketId ticketId
    ///@param buyTicketId Event tokenId
    function checkTicketFees(
        uint256 feeAmount,
        uint256 actualPrice,
        address tokenAddress,
        uint256 ticketId,
        uint256 buyTicketId,
        string memory tokenType
    ) internal {
        if (keccak256(abi.encodePacked((tokenType))) == keccak256(abi.encodePacked(("ERC20")))) {
            require(
                IEvents(eventContract).isErc20TokenWhitelisted(tokenAddress) == true,
                "TicketMaster : PaymentToken Not Supported"
            );
            address conversionAddress = IEvents(eventContract)
            .getConversionContract();
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
                ticketFeesBalance[buyTicketId][tokenAddress] += (feeAmount -
                    ticketCommissionFee);
                userTicketBalance[buyTicketId][ticketId] = feeAmount - ticketCommissionFee;
            } else {
                checkDeviation(msg.value, convertedActualPrice);
                uint256 ticketCommissionFee = (msg.value *
                    ticketCommissionPercent) / 100;

                (bool successOwner, ) = IEvents(eventContract).getTreasuryContract().call{
                    value: msg.value
                }("");
                require(
                    successOwner,
                    "TicketMaster: Transfer to treasury contract failed"
                );
                ticketFeesBalance[buyTicketId][tokenAddress] += (msg.value -
                    ticketCommissionFee);
                userTicketBalance[buyTicketId][ticketId] = msg.value - ticketCommissionFee;
            }
        }
        else {
            require(
                IEvents(eventContract).isErc721TokenWhitelisted(tokenAddress) == true,
                "TicketMaster : PaymentToken Not Supported"
            );
            require(
                msg.sender ==
                    IERC721Upgradeable(tokenAddress).ownerOf(feeAmount),
                "TicketMaster : Caller is not the owner"
            );
            IERC721Upgradeable(tokenAddress).transferFrom(msg.sender, IEvents(eventContract).getTreasuryContract(), feeAmount);
            userTicketBalance[buyTicketId][ticketId] = feeAmount;
            nftTicketIds[tokenAddress].push(ticketId);
            erc721Address[tokenAddress] = true;
        }
    }

    function claimTicketFees(uint256 eventTokenId, address[] memory tokenAddress) external {
        require(
            IEvents(eventContract)._exists(eventTokenId),
            "TicketMaster: TokenId does not exist"
        );
        require(
            IEvents(eventContract).isEventCancelled(eventTokenId) == false && IEvents(eventContract).isEventStarted(eventTokenId) == true,
            "TicketMaster: Event is cancelled"
        );
        (, , address payable eventOrganiser, , , ) = IEvents(eventContract)
            .getEventDetails(eventTokenId);
        require(msg.sender == eventOrganiser, "TicketMaster: Invalid Address");
        for(uint256 i = 0; i< tokenAddress.length; i++) {
            if(erc721Address[tokenAddress[i]] == true) {
                uint256[] memory ticketIds = nftTicketIds[tokenAddress[i]];
                for(uint256 j = 0; j < ticketIds.length; j++) {
                    if(userTicketBalance[eventTokenId][ticketIds[j]] > 0) {
                        ITreasury(IEvents(eventContract).getTreasuryContract()).claimNft(eventOrganiser, tokenAddress[i], userTicketBalance[eventTokenId][ticketIds[j]]);
                        userTicketBalance[eventTokenId][ticketIds[j]] = 0;
                    }
                }
            }
            else {
                if(ticketFeesBalance[eventTokenId][tokenAddress[i]] > 0) {
                    ITreasury(IEvents(eventContract).getTreasuryContract()).claimFunds(eventOrganiser, tokenAddress[i], ticketFeesBalance[eventTokenId][tokenAddress[i]]);
                    ticketFeesBalance[eventTokenId][tokenAddress[i]] = 0;
                }
            }
        }
        emit TicketFeesClaimed(eventTokenId, eventOrganiser, tokenAddress);
    }

    function refundTicketFees(uint256 eventTokenId, uint256[] memory ticketIds) external {
        require(
            IEvents(eventContract)._exists(eventTokenId),
            "TicketMaster: TokenId does not exist"
        );
        (, uint256 endTime , , , , uint256 actualPrice) = IEvents(eventContract)
        .getEventDetails(eventTokenId);
        require(actualPrice != 0, "TicketMaster: Event is free");
        require(
            IEvents(eventContract).isEventCancelled(eventTokenId) == true || IEvents(eventContract).isEventStarted(eventTokenId) == false && block.timestamp > endTime,
            "TicketMaster: Event is neither cancelled not expired"
        );
        address ownerAddress = msg.sender;
        for(uint256 i=0; i < ticketIds.length; i++) {
            if(refundTicketFeesStatus[eventTokenId][ticketIds[i]] == false) {
                if(ownerAddress == Ticket(ticketNFTAddress[eventTokenId]).ownerOf(ticketIds[i])) {
                    address tokenAddress = buyTicketTokenAddress[eventTokenId][ticketIds[i]];
                    uint256 refundAmount = userTicketBalance[eventTokenId][ticketIds[i]];
                    if(erc721Address[tokenAddress] == true) {
                        ITreasury(IEvents(eventContract).getTreasuryContract()).claimNft(ownerAddress, tokenAddress, refundAmount);
                    }
                    else {
                        ITreasury(IEvents(eventContract).getTreasuryContract()).claimFunds(ownerAddress, tokenAddress, refundAmount);
                    }
                    refundTicketFeesStatus[eventTokenId][ticketIds[i]] = true;
                    userTicketBalance[eventTokenId][ticketIds[i]] = 0;
                    emit TicketFeesRefund(eventTokenId, ownerAddress, ticketIds[i]);
                }
            }
        }
    }

    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
        public
        view
        returns (bool)
    {
        return IEvents(eventContract).getJoinEventStatus(_ticketNftAddress, _ticketId);
    }
}
