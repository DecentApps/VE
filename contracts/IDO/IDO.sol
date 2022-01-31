// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IIDO.sol";
import "../BEP20/IBEP20.sol";
import "./IPancakeRouter02.sol";

/**
 * @dev Implementation of the {IDO} interface.
 */
contract IDO is IIDO {
    IBEP20 public token;
    IPancakeRouter02 public router;

    address payable private _owner; /* deployers' address*/
    address immutable private _token; /* BEP20 token address for the IDO */
    address immutable private _stablecoin; /* stablecoin address for the IDO. Used only for getting the rate between native coinand stablecoin */
    address immutable private _panecakePool; /* panecake pool address between stablecoin and native coin */
    uint256 private _ratio; /* fixed ratio for the offering between stablcoin and native coin */
    uint256 private _initialAmount; /* Initial amount of tokens for IDO */

    uint256 private _totalCoinsExchanged;
    uint256 private _totalTokensOffered;

    constructor(
        address __token,
        address __stablecoin,
        address __panecakePool,
        uint256 __ratio,
        uint256 __initialAmount
    ) {
        _owner = payable(msg.sender);
        _token = __token;
        _stablecoin = __stablecoin;
        _panecakePool = __panecakePool;
        _ratio = __ratio;
        _initialAmount = __initialAmount;
        token = IBEP20(__token);
    }

    /**
     * @notice returns the current exchange rate using pancake swap (onchain oracle)
     * @param _amountIn - native coin amount
     * @return exRate - exchange rate between native coin and token
     */
    function getCurrentRate(uint256 _amountIn)
        external
        view
        override
        returns (uint256 exRate)
    {
        return _getCurrentRate(_amountIn);
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
    {
        return _totalCoinsExchanged;
    }

    /**
     * @return totalTokens - returns the amount of the token that was bought so far
     */
    function totalOut() external view override returns (uint256 totalTokens) {
        return _totalTokensOffered;
    }

    /**
     * @notice owner only - transfer native coins to owner's wallet
     * @param _amount - how many native coins to withdraw. On zero , retrieve all avariable coins
     * @notice Emits an {Withdrawn} event.
     */
    function withdrawCoins(uint256 _amount) external payable override {
        assert(msg.sender == _owner);
        uint256 remainingCoins = address(this).balance;
        require(remainingCoins > 0);
        uint256 transferAmount = _amount;
        if (_amount == 0 || _amount > remainingCoins) {
            transferAmount = remainingCoins;
        }

        (bool successfulTransfer, ) = _owner.call{value: _amount}("");
        require(successfulTransfer);
        emit Withdrawn(transferAmount, true);
    }

    /**
     * @notice owner only - transfer tokens to owner's wallet
     * @param _amount - how many tokens to withdraw. On zero , retrieve all tokens left
     * @notice Emits an {Withdrawn} event.
     */
    function withdrawTokens(uint256 _amount) external override {
        assert(msg.sender == _owner);
        uint256 remainingTokens = token.balanceOf(address(this));
        require(remainingTokens > 0);
        uint256 transferAmount = _amount;
        if (_amount == 0 || _amount > remainingTokens) {
            transferAmount = remainingTokens;
        }

        require(token.transfer(_owner, transferAmount));
        emit Withdrawn(transferAmount, false);
    }

    /**
     * @notice directly accept deposit in native coins. Exchange it to tokens and return them to sender's address
     * @notice that way a fornt end client is not necessary for investors. They can use their favourite wallet
     * @notice Emits an {Exchanged} event.
     */
    receive() external payable override {
        require(msg.value > 0);

        uint256 tokenAmount = _ratio * _getCurrentRate(msg.value); /* may overflow, inspect */
        uint256 maxTokens = token.balanceOf(address(this));

        require(maxTokens >= tokenAmount);

        _totalCoinsExchanged += msg.value;

        /* send the tokens to the caller */
        require(token.transfer(msg.sender, tokenAmount));
        _totalTokensOffered += tokenAmount;

        emit Exchanged(msg.sender, msg.value, tokenAmount);
    }

    /* Internal functions */
    function _getCurrentRate(uint256 _amountOut)
        internal
        view
        returns (uint256 exRate)
    {
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = _stablecoin;

        return router.getAmountsOut(_amountOut, path)[1];
    }
}
