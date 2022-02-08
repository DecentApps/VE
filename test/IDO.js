const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
require("dotenv").config();

describe("IDO for VEC smart contract", function () {
  it("Checking IDO contract functionality", async function () {
    const accounts = await hre.ethers.getSigners();
    const ido = await ethers.getContractFactory("IDO");
    const CONTRACT_ADDR = process.env.IDO_ADDR;

    const vecIDO = await ido.attach("0x" + CONTRACT_ADDR);
    const deployer = vecIDO.signer.address;
    const usdtAddr = await vecIDO.getStablecoinAddress();
    const vecAddr = await vecIDO.getTokenAddress();
    const vecDecimals = 8;
    const bnbDecimals = 18;
    const usdtDecimals = 6;
    const initallyOffered = await vecIDO.getInitialOffered();
    const ratio = await vecIDO.getFixedRate();

    console.log(`IDO address: ${CONTRACT_ADDR}`);
    console.log(`Deployer is: ${deployer}`);
    console.log(`VEC address: ${vecAddr}`);
    console.log(`USDT address: ${usdtAddr}`);

    console.log(`Initial offer: ${initallyOffered / 10 ** vecDecimals}`);
    console.log(`Fixed ratio of VEC/USDT: ${ratio}`);

    let coinsExchnged = await vecIDO.totalInNative();
    let vecSent = await vecIDO.totalOut();

    console.log(`BNB so far: ${coinsExchnged / 10 ** bnbDecimals} BNB`);
    console.log(`VEC distributed so far: ${vecSent / 10 ** vecDecimals} VEC`);

    let currentRate = await vecIDO.getCurrentRate(1 * 10 ** usdtDecimals);
    currentRate /= 10 ** usdtDecimals;
    console.log(`Current rate : ${currentRate}`);
  });
});
