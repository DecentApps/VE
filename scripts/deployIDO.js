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
  const usdtAddr = hre.config.networks[NETWORK].usdt;
  const router = hre.config.networks[NETWORK].swapRouter;

  /* USDT/WBNB */
  const panecakePool = hre.config.networks[NETWORK].pool;
  const ratio = 1;
  const initialAmount = 1000 * 10 ** 8;

  const vecIDO = await ido.deploy(
    vecAddr,
    usdtAddr,
    router,
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
