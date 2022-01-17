// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IIDO.sol";

/**
 * @dev Implementation of the {IDO} interface.
 */
contract IDO is IIDO {

    constructor() {}
    function getCurrentRate() external view override returns (uint256) {}

    function getFixedRate(address) external view override returns (uint256) {}

    function getInitialOffered() external view override returns (uint256) {}

    function getStablecoinAddress() external view override returns (address) {}

    function getTokenAddress() external view override returns (address) {}

    function totalInNative() external view override returns (uint256) {}

    function totalOut() external view override returns (uint256) {}

    function withdraw(uint256) external override {}
}
