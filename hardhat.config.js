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
      accounts: [`0x${process.env.M_ISSUER_KEY}`, `0x${process.env.M_TESTER_KEY}`],
      from: `0x${process.env.M_ISSUER_KEY}`,
      gas: 2100000,
      gasPrice: 8000000000,
    },
    bscTestnet: {
      chainId: 97,
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [`0x${process.env.T_ISSUER_KEY}`, `0x${process.env.T_TESTER_KEY}`],
      from: `0x${process.env.T_ISSUER_KEY}`,
      gas: 2100000,
      gasPrice: 10000000000,
    },
  },
};
