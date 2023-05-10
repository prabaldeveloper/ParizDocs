// SPDX-License-Identifier: UNLICENSED

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IAdminFunctions.sol";
import "./interface/IEvents.sol";
import "./access/Ownable.sol";
import "./utils/TicketControllerStorage.sol";

//search - check for

pragma solidity ^0.8.0;


contract TicketController is Ownable, TicketControllerStorage {
    using AddressUpgradeable for address;

    function initialize() public initializer {
        Ownable.ownable_init();
    }

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "ERR_116:Events:Address is not a contract"
        );
        adminContract = _adminContract;

    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param buyTicketId Event tokenId
    ///@param ticketTime Event ticketTime
    function buyTicketInternal(
        uint256 buyTicketId,
        uint256 ticketTime
    ) internal view returns(uint256) {
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
        require(ticketTime <= endTime, "TicketMaster: Event ended");
        return actualPrice;
    }

    function checkTicketFeesInternal(uint256 feeAmount,
        uint256 actualPrice,
        address tokenAddress,
        uint256 buyTicketId,
        string memory tokenType
    ) internal returns(uint256) {
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
                //check for msg.sender
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
                return ticketCommissionFee;
            }  else {
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
                return ticketCommissionFee;
            }
         }
         else {
            require(
                IAdminFunctions(adminContract).isErc721TokenWhitelisted(buyTicketId, tokenAddress) == true,
                "ERR_122:TicketMaster: PaymentToken Not Supported"
            );

            //check for msg.sender
            require(
                msg.sender ==
                    IERC721Upgradeable(tokenAddress).ownerOf(feeAmount),
                "ERR_124:TicketMaster: Caller is not the owner"
            );

            return 0;
            
         }

    }  

    function claimTicketFeesInternal(uint256 eventTokenId) internal view returns(address) {
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId),
            "ERR_132:ManageEvent:TokenId does not exist"
        );
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == false && IAdminFunctions(adminContract).isEventStarted(eventTokenId) == true,
            "ERR_138:ManageEvent:Event is cancelled"
        );
        (, , address payable eventOrganiser, , , ) = IEvents(IAdminFunctions(adminContract).getEventContract())
            .getEventDetails(eventTokenId);
        //check for msg.sender
        require(msg.sender == eventOrganiser, "ERR_131:ManageEvent:Invalid Address");
        return eventOrganiser;
    }

    function refundTicketFeesInternal(uint256 eventTokenId) internal view{
        require(
            IEvents(IAdminFunctions(adminContract).getEventContract())._exists(eventTokenId),
            "ERR_132:ManageEvent:TokenId does not exist"
        );
        (, uint256 endTime , , , , uint256 actualPrice) = IEvents(IAdminFunctions(adminContract).getEventContract())
        .getEventDetails(eventTokenId);
        require(actualPrice != 0, "ERR_144:ManageEvent:Event is free");
        require(
            IAdminFunctions(adminContract).isEventCancelled(eventTokenId) == true || IAdminFunctions(adminContract).isEventStarted(eventTokenId) == false && block.timestamp > endTime,
            "ERR_145:ManageEvent:Event is neither cancelled nor expired"
        );

    }


}