// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IQuickswapFactory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}
