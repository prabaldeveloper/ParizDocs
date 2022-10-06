// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ticket.sol";
import "./interface/IAdminFunctions.sol";
import "./interface/IEvents.sol";
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

    function initialize(address earlyAdmin) public initializer {
        adminAddress[earlyAdmin] = true;
        Ownable.ownable_init();
    }

    modifier onlyAdmin() {
        require(
            adminAddress[msg.sender] == true,
            "ERR_117:TicketMaster:Caller is not the admin"
        );
        _;
    }

    receive() external payable {}

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "ERR_118:TicketMaster:Address is not a contract"
        );
        adminContract = _adminContract;

    }

    ///@notice updates ownerStatus
    ///@param _owner owner address
    ///@param status status(true or false)
    function whitelistAdmin(address _owner, bool status) external onlyOwner {
        adminAddress[_owner] = status;
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
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(buyTicketId),
            "ERR_119:TicketMaster:TokenId does not exist"
        );
        require(
            IAdminFunctions(adminContract).isEventCancelled(buyTicketId) == false,
            "ERR_120:TicketMaster:Event is cancelled"
        );
        (
            , uint256 endTime,
            , , , uint256 actualPrice
        ) = IEvents(IAdminFunctions(adminContract).getEventContract()).getEventDetails(buyTicketId);
        require(block.timestamp <= endTime && IAdminFunctions(adminContract).isEventEnded(buyTicketId) == false, "TicketMaster: Event ended");
        uint256 totalCapacity = Ticket(ticketNFTAddress[buyTicketId]).totalSupply();
        uint256 mintedToken = Ticket(ticketNFTAddress[buyTicketId]).mint(
            msg.sender
        );
        require(
            ticketSold[buyTicketId] <= totalCapacity,
            "ERR_121:TicketMaster:All tickets are sold"
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
                IAdminFunctions(adminContract).isErc20TokenWhitelisted(tokenAddress) == true,
                "ERR_122:TicketMaster: PaymentToken Not Supported"
            );
            uint256 convertedActualPrice = IAdminFunctions(adminContract)
                    .convertFee(tokenAddress, actualPrice);
            if (tokenAddress != address(0)) {
                IAdminFunctions(adminContract).checkDeviation(feeAmount, convertedActualPrice);
                uint256 ticketCommissionFee = (feeAmount *
                    IAdminFunctions(adminContract).getTicketCommissionPercent()) / 100;
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    IAdminFunctions(adminContract).getTreasuryContract(),
                    feeAmount - ticketCommissionFee
                );
                IERC20(tokenAddress).transferFrom(
                    msg.sender,
                    IAdminFunctions(adminContract).getAdminTreasuryContract(),
                    ticketCommissionFee
                );
                ticketFeesBalance[buyTicketId][tokenAddress] += (feeAmount -
                    ticketCommissionFee);
                userTicketBalance[buyTicketId][ticketId] = feeAmount - ticketCommissionFee;
            } else {
                IAdminFunctions(adminContract).checkDeviation(msg.value, convertedActualPrice);
                uint256 ticketCommissionFee = (msg.value *
                    IAdminFunctions(adminContract).getTicketCommissionPercent()) / 100;

                (bool successOwner, ) = IAdminFunctions(adminContract).getTreasuryContract().call{
                    value: msg.value - ticketCommissionFee
                }("");
                require(
                    successOwner,
                    "ERR_123:TicketMaster:Transfer to treasury contract failed"
                );
                 (bool successAdminTreasury, ) = IAdminFunctions(adminContract).getAdminTreasuryContract().call{
                    value: ticketCommissionFee
                }("");
                require(
                    successAdminTreasury,
                    "ERR_123:TicketMaster:Transfer to  admin treasury contract failed"
                );
                ticketFeesBalance[buyTicketId][tokenAddress] += (msg.value -
                    ticketCommissionFee);
                userTicketBalance[buyTicketId][ticketId] = msg.value - ticketCommissionFee;
            }
        }
        else {
            require(
                IAdminFunctions(adminContract).isErc721TokenWhitelisted(tokenAddress) == true,
                "ERR_122:TicketMaster: PaymentToken Not Supported"
            );
            require(
                msg.sender ==
                    IERC721Upgradeable(tokenAddress).ownerOf(feeAmount),
                "ERR_124:TicketMaster: Caller is not the owner"
            );
            if(IAdminFunctions(adminContract).isERC721TokenFreePass(tokenAddress) == 0)  {
                IERC721Upgradeable(tokenAddress).transferFrom(msg.sender, IAdminFunctions(adminContract).getTreasuryContract(), feeAmount);
                userTicketBalance[buyTicketId][ticketId] = feeAmount;
                nftTicketIds[tokenAddress].push(ticketId);
                erc721Address[tokenAddress] = true;
            }
            else {
                require(nftIdPassStatus[tokenAddress][feeAmount] == false, "ERR_125:TicketMaster:Nft id already used");
                nftIdPassStatus[tokenAddress][feeAmount] = true;
            }
        }
    }

    function getUserTicketDetails(uint256 eventTokenId, uint256 ticketId) public view returns(uint256, address) {
        return (userTicketBalance[eventTokenId][ticketId], buyTicketTokenAddress[eventTokenId][ticketId]);
    }

    function getTicketNFTAddress(uint256 eventTokenId) public view returns(address) {
        return ticketNFTAddress[eventTokenId];
    }

    function isERC721TokenAddress(address tokenAddress) public view returns(bool) {
        return erc721Address[tokenAddress];
    }

    function getTicketFeesBalance(uint256 eventTokenId, address tokenAddress) public view returns(uint256) {
        return ticketFeesBalance[eventTokenId][tokenAddress];
    }

    function getTicketIds(address tokenAddress) public view returns(uint256[] memory) {
        return nftTicketIds[tokenAddress];
    }

    function getJoinEventStatus(address _ticketNftAddress, uint256 _ticketId)
        public
        view
        returns (bool)
    {
        return IEvents(IAdminFunctions(adminContract).getEventContract()).getJoinEventStatus(_ticketNftAddress, _ticketId);
    }
}
