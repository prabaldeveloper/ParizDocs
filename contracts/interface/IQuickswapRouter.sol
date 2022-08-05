
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IQuickswapRouter {
    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);
}
