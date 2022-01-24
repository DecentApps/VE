// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of IDO (Initial Decentralized Offering)
 */
interface IIDO {
    /* Privileged functions */

    /**
     * @notice withdraw native coin
     * @notice owner only
     */
    function withdrawCoins(uint256) external payable;

    /**
     * @notice withdraw tokens (In case IDO can't be completed)
     * @notice owner only
     */
    function withdrawTokens(uint256) external;

    /* Permissionless functions */

    /**
     * @notice total native coins received
     */
    function totalInNative() external view returns (uint256);

    /**
     * @notice total tokens sent out
     */
    function totalOut() external view returns (uint256);

    /**
     * @notice fixed rate between stablecoin and IDO token
     */
    function getFixedRate() external view returns (uint256);

    /**
     * @notice returns the stablecoin address
     */
    function getStablecoinAddress() external view returns (address);

    /**
     * @notice returns the token address
     */
    function getTokenAddress() external view returns (address);

    /**
     * @notice returns amount of tokens at the start of offering
     */
    function getInitialOffered() external view returns (uint256);

    /**
     * @notice returns the current ratio between the native coin and the token
     * @notice uses onchain oracle for that
     */
    function getCurrentRate(address) external view returns (uint256);

    /**
     * @notice special recieve function to accept the native coin
     */
    receive() external payable;

    /* Events */

    /**
     * @notice returns how many native coins received and how many tokens sent out
     */
    event Exchanged(address buyer, uint256 coins, uint256 tokens);

    /**
     * @notice native coin or token withdrawal
     */
    event Withdrawn(uint256 coins, bool isNative);
}
