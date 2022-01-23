// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IIDO.sol";
import "../BEP20/IBEP20.sol";

/**
 * @dev Implementation of the {IDO} interface.
 */
contract IDO is IIDO {
    IBEP20 public token;

    address private _owner; /* deployers' address*/
    address private _token; /* BEP20 token address for the IDO */
    address private _stablecoin; /* stablecoin address for the IDO. Used only for getting the rate between native coinand stablecoin */
    address private _panecakePool; /* panecake pool address between stablecoin and native coin */
    uint256 private _ratio; /* fixed ratio for the offering between stablcoin and native coin */
    uint256 private _initialAmount; /* Initial amount of token for IDO */

    uint256 private totalCoinsExchanged;
    uint256 private totalTokensOffered;

    constructor(
        address __token,
        address __stablecoin,
        address __panecakePool,
        uint256 __ratio,
        uint256 __initialAmount
    ) {
        _owner = msg.sender;
        _token = __token;
        _stablecoin = __stablecoin;
        _panecakePool = __panecakePool;
        _ratio = __ratio;
        _initialAmount = __initialAmount;
        token = IBEP20(_token);
    }

    /**
     * @notice returns the current exchange rate using pancake swap (onchain oracle)
     * @param _pool - address pool at pancake
     * @return exRate - exchange rate between native coin and token
     */
    function getCurrentRate(address _pool)
        external
        view
        override
        returns (uint256 exRate)
    {
        return _getCurrentRate(_pool);
    }

    /**
     * @notice returns the fixed ratio for IDO (stablecoin to token)
     * @return offeringRate - IDO rate between token and stablecoin
     */
    function getFixedRate()
        external
        view
        override
        returns (uint256 offeringRate)
    {
        return _ratio;
    }

    /**
     * @notice returns the fixed ratio for IDO (stablecoin to token)
     * @return offeringRatio - the amount of total deposited IDO tokens (maximum offered)
     */
    function getInitialOffered()
        external
        view
        override
        returns (uint256 offeringRatio)
    {
        return _initialAmount;
    }

    /**
     * @return stablecoin - returns the stable coin address
     */
    function getStablecoinAddress()
        external
        view
        override
        returns (address stablecoin)
    {
        return _stablecoin;
    }

    /**
     * @return tokenAddr - returns the token address
     */
    function getTokenAddress()
        external
        view
        override
        returns (address tokenAddr)
    {
        return _token;
    }

    /**
     * @return totalCoins - returns the amount of native coins that exchanged so far
     */
    function totalInNative()
        external
        view
        override
        returns (uint256 totalCoins)
    {}

    /**
     * @return totalTokens - returns the amount of the token that was bought so far
     */
    function totalOut() external view override returns (uint256 totalTokens) {}

    /**
     * @notice owner only - transfer native coins to owner's wallet
     * @param _amount - how many native coins to withdraw. On zero , retrieve all avariable coins
     * @notice Emits an {Withdrawn} event.
     */
    function withdraw(uint256 _amount) external override {}

    /**
     * @notice directly accept deposit in native coins. Exchange it to tokens and return them to sender's address
     * @notice that way a fornt end client is not necessary for investors. They can use their favourite wallet
     * @notice Emits an {Exchanged} event.
     */
    receive() external payable override {
        require(msg.value > 0);

        uint256 tokenAmount = _ratio * _getCurrentRate(_panecakePool); /* may overflow, inspect */
        uint256 maxTokens = token.balanceOf(address(this));

        require(maxTokens >= tokenAmount);

        totalCoinsExchanged += msg.value;

        /* send the tokens to the caller */
        require(token.transfer(msg.sender, tokenAmount));
        totalCoinsExchanged += tokenAmount;

        emit Exchanged(msg.sender, msg.value, tokenAmount);
    }

    /* Internal functions */
    function _getCurrentRate(address _pool)
        internal
        view
        returns (uint256 exRate)
    {
        /* mockup */
        return 1;
    }
}
