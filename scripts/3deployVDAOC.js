const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let vdaom1 = accounts[10];
    let vdaom2 = accounts[11];

    //-end---------- account setup--------------------------------------------------------------------------
    //-start---------- FLTP VDAOC deploy--------------------------------------------------------------------------
    console.log("fLTP address:", fLTP.address);
    VDAOC = await ethers.getContractFactory("VDAOC");
    vDAOC = await VDAOC.connect(fLTP).deploy(vdaom1.address,vdaom2.address, "https://ipfs.io/ipfs/QmRrHTzcCJvFDWVq9DUnUTgxnCNyWUAANy8TyMRMeQhPp3");
    receipt=await vDAOC.deployTransaction.wait();
    await vDAOC.deployed();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }
    console.log("VDAOC deployed to:", vDAOC.address);

    vDAOMTCAddr = await vDAOC.VDAOMTCAddr();
    console.log("VDAOMTC deployed to:", vDAOMTCAddr);
    VDAOMTC = await ethers.getContractFactory("VDAOMTC");

    //-end---------- FLTP deploy--------------------------------------------------------------------------

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
