// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const NETWORK = process.env.NETWORK;

  console.log(`Deploying Initial Dex Offering of VEC on network ${NETWORK}`);
  // We get the contract to deploy
  const ido = await hre.ethers.getContractFactory("IDO");

  const vecAddr = process.env.VEC_ADDR;
  const usdtAddr = "0x337610d27c682e347c9cd60bd4b3b107c9d34ddd";
  const panecakePool =
    "0x55d398326f99059ff775485246999027b3197955"; /* USDT/WBNB */
  const ratio = 1;
  const initialAmount = 1000 * 10 ** 8;

  const vecIDO = await ido.deploy(
    vecAddr,
    usdtAddr,
    panecakePool,
    ratio,
    initialAmount
  );
  await vecIDO.deployed();

  console.log(
    `IDO for VEC deployed to address ${vecIDO.address} from ${ido.signer.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
