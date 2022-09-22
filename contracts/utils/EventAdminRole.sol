// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./EventStorage.sol";
import "./EventMetadata.sol";

contract EventAdminRole is EventStorage, EventMetadata {

    using AddressUpgradeable for address;

    function updateAdminContract(address _adminContract) external onlyOwner {
        require(
            _adminContract.isContract(),
            "Events: Address is not a contract"
        );
        adminContract = _adminContract;

    }
}
