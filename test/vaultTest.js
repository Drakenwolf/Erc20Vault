const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should deploy the contract", async function () {

    const TestToken = await ethers.getContractFactory("TestToken");
    const testToken = await TestToken.deploy();
    const testTokenAdress = testToken.address;
    const Vault = await ethers.getContractFactory("Vault");
    const vault = await Vault.deploy(testTokenAdress);
    const vaultAdress = vault.address;
  
    await vault.deployed();
    await testToken.deployed();

    console.log("testToken deployed to:", testTokenAdress);
    console.log("vault deployed to:", vaultAdress);
  });
});