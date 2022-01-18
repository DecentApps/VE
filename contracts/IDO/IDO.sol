// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IIDO.sol";

/**
 * @dev Implementation of the {IDO} interface.
 */
contract IDO is IIDO {
    address private _owner; /* deployers' address*/
    address private _token; /* BEP20 token address for the IDO */
    address private _stablecoin; /* stablecoin address for the IDO. Used only for getting the rate between native coinand stablecoin */
    address private _panecakePool; /* panecake pool address between stablecoin and native coin */
    uint256 private _ratio; /* fixed ratio for the offering between stablcoin and native coin */

    constructor(
        address __token,
        address __stablecoin,
        address __panecakePool,
        uint256 __ratio
    ) {
        _owner = msg.sender;
        _token = __token;
        _stablecoin = __stablecoin;
        _panecakePool = __panecakePool;
        _ratio = __ratio;
    }

    function getCurrentRate() external view override returns (uint256) {}

    function getFixedRate(address) external view override returns (uint256) {}

    function getInitialOffered() external view override returns (uint256) {}

    function getStablecoinAddress() external view override returns (address) {}

    function getTokenAddress() external view override returns (address) {}

    function totalInNative() external view override returns (uint256) {}

    function totalOut() external view override returns (uint256) {}

    function withdraw(uint256) external override {}
}
