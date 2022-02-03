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
      swapFactory: "0x182859893230dC89b114d6e2D547BFFE30474a21",
      swapRouter: "0xdc4904b5f716Ff30d8495e35dC99c109bb5eCf81",
    },
  },
};
