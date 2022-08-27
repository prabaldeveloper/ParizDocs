// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Ticket.sol";
import "./interface/IConversion.sol";
import "./interface/IEvents.sol";
import "./interface/IVenue.sol";

contract TicketMaster is Ticket {
    using AddressUpgradeable for address;
    // mapping for ticket NFT contract
    mapping(uint256 => address) public ticketNFTAddress;

    //mapping for storing user's address who bought the ticket of an event
    mapping(address => mapping(uint256 => bool)) public ticketBoughtAddress;

    //mapping for getting number of ticket sold against an event
    mapping(uint256 => uint256) public ticketSold;

    // mapping for getting ticket id of user
    mapping(address => uint256) public ticketIdOfUser;

    //convesion contract address
    address private eventContract;

    //ticketCommission
    uint256 private ticketCommissionPercent;

    ///@param eventContract eventContract address
    event EventContractUpdated(address eventContract);

    ///@param tokenId Event tokenId
    ///@param buyer buyer address
    event Bought(uint256 indexed tokenId, address buyer);

    ///@param ticketCommissionPercent ticketCommissionPercent
    event TicketCommissionUpdated(uint256 ticketCommissionPercent);

    ///@notice updates eventContract address
    ///@param _eventContract eventContract address
    function updateEventContract(address _eventContract) external onlyOwner {
        require(
            _eventContract.isContract(),
            "Events: Address is not a contract"
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


    ///@notice To check amount is within deviation percentage
    ///@param feeAmount price of the ticket
    ///@param price price from the conversion contract
    function checkDeviation(uint256 feeAmount, uint256 price) public view {
        uint deviationPercentage = IEvents(eventContract).getDeviationPercentage();
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
    ) external returns (address ticketNFTContract) {
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
        Ticket(ticketNFTContract).initialize(name, "EventTicket", totalSupply);
    }

    ///@notice Users can buy tickets
    ///@dev Public function
    ///@dev - Check whether event is paid or free
    ///@dev - Check whether user paid the price.
    ///@dev - Map event tokenId with user address
    ///@param eventId Event tokenId
    ///@param tokenAmount ticket Price
    function buyTicket(uint256 eventId, address tokenAddress, uint256 tokenAmount) external payable {
        require(IEvents(eventContract)._exists(eventId), "Events: TokenId does not exist");
        (, uint256 endTime,address eventOrganiser, , , uint256 actualPrice) = IEvents(
            eventContract
        ).getEventDetails(eventId); //getInfo[eventId].ticketPrice;
        require(actualPrice != 0, "Events: Event is free");
        require(block.timestamp <= endTime, "Events: Event ended");
        address conversionAddress = IEvents(eventContract).getConversionContract();
        uint256 totalCapacity =  Ticket(ticketNFTAddress[eventId]).totalSupply();
        uint256 mintedToken = Ticket(ticketNFTAddress[eventId]).mint();
        require(
            ticketSold[eventId] <= totalCapacity,
            "Event: All tickets are sold"
        );
        checkTicketFees(tokenAmount, actualPrice, eventOrganiser, tokenAddress, conversionAddress);
        ticketBoughtAddress[msg.sender][eventId] = true;
        ticketIdOfUser[msg.sender] = mintedToken;
        ticketSold[eventId]++;

        emit Bought(eventId, msg.sender);
    }

    ///@notice To check whether token is matic or any other token
    ///@param tokenAddress erc20 tokenAddress
    ///@param feeAmount price of the ticket
    function checkTicketFees(
        uint256 feeAmount,
        uint256 actualPrice,
        address eventOrganiser,
        address tokenAddress,
        address conversionAddresss
    ) internal {
        // convert base token to fee token
        uint256  convertedFeeAmount= IConversion(conversionAddresss).convertFee(
            tokenAddress,
            feeAmount
        );
        // convert base token to fee token
        uint256  convertedActualPrice= IConversion(conversionAddresss).convertFee(
            tokenAddress,
            actualPrice
        );
        if (tokenAddress != address(0)) {
            checkDeviation(convertedFeeAmount, convertedActualPrice);
            uint256 ticketCommissionFee = (convertedFeeAmount *
                ticketCommissionPercent) / 100;
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                eventOrganiser,
                convertedFeeAmount - ticketCommissionFee
            );
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                IEvents(eventContract).getTreasuryContract(),
                ticketCommissionFee
            );
        } else {
            checkDeviation(msg.value, convertedActualPrice);
            uint256 ticketCommissionFee = (msg.value *
                ticketCommissionPercent) / 100;
            (bool successOwner, ) = eventOrganiser.call{
                value: msg.value - ticketCommissionFee
            }("");
            require(successOwner, "Events: Transfer to venue owner failed");
            (bool successTreasury, ) = IEvents(eventContract).getTreasuryContract().call{
                value: ticketCommissionFee
            }("");
            require(
                successTreasury,
                "Events: Transfer to treasury contract failed"
            );
        }
    }
}
