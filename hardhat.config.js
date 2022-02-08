require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const t = process.env.TEST;
  console.log(t);
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  defaultNetwork: process.env.NETWORK,
  networks: {
    bscMainnet: {
      chainId: 56,
      url: "https://bsc-dataseed.binance.org/",
      accounts: [
        `0x${process.env.M_ISSUER_KEY}`,
        `0x${process.env.M_TESTER_KEY}`,
      ],
      from: `0x${process.env.M_ISSUER_KEY}`,
      gas: 2100000,
      gasPrice: 8000000000,
      swapFactory: "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73",
      swapRouter: "0x10ED43C718714eb63d5aA57B78B54704E256024E",
      usdt: "0x55d398326f99059fF775485246999027B3197955",
      pool: "0x16b9a82891338f9ba80e2d6970fdda79d1eb0dae",
    },
    bscTestnet: {
      chainId: 97,
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [
        `0x${process.env.T_ISSUER_KEY}`,
        `0x${process.env.T_TESTER_KEY}`,
      ],
      from: `0x${process.env.T_ISSUER_KEY}`,
      gas: 2100000,
      gasPrice: 10000000000,
      swapFactory: "0xb7926c0430afb07aa7defde6da862ae0bde767bc ",
      swapRouter: "0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",
      usdt: "0x7ef95a0fee0dd31b22626fa2e10ee6a223f8a684",
      pool: "0xF855E52ecc8b3b795Ac289f85F6Fd7A99883492b",
    },
  },
};
