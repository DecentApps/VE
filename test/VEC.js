const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("VEC smart contract", function () {
  it("Checking VEC contract functionality", async function () {
    const accounts = await hre.ethers.getSigners();
    const bep20 = await ethers.getContractFactory("BEP20");
    const vec = await bep20.deploy();
    await vec.deployed();
    const deployer = vec.deployTransaction.from;
    const symbol = await vec.symbol();
    const decimals = await vec.decimals();

    /* check constructor */
    expect(await vec.name()).to.equal("Virtual Economy Coin");
    expect(symbol).to.equal("VEC");
    expect(decimals).to.equal(8);
    const expectedSupply =
      ethers.BigNumber.from("100000000000000000"); /* 10**(9+8) */
    expect(await vec.totalSupply()).to.equal(expectedSupply);
    expect(await vec.balanceOf(deployer)).to.equal(expectedSupply);

    console.log("Constructor was successful");

    /* check token transfering */
    const receiver = accounts[1].address;
    const amount = 2 * 10 ** decimals;
    const transferTx = await vec.transfer(receiver, amount);
    /* wait until the transaction is mined */
    await transferTx.wait();

    if (transferTx.hash == null) {
      assert.fail("Transfer failed!");
    } else {
      console.log(`Transfer completed. Hash: ${transferTx.hash}`);
      const transferedAmount = await vec.balanceOf(receiver);
      console.log(
        `Receiver's balance is ${transferedAmount / 10 ** decimals} ${symbol}`
      );

      expect(transferedAmount).to.equal(amount);
    }
  });
});
