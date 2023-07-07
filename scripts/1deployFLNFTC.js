const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let regulator = accounts[0];
    //-end---------- account setup--------------------------------------------------------------------------


    //-start---------- Regulator deploy--------------------------------------------------------------------------

    console.log("Regulator address is:", regulator.address);
    const FLNFTC = await ethers.getContractFactory("FLNFTC");
    const fLNFTC = await FLNFTC.connect(regulator).deploy("Federated Learning NFT", "FLNFT", "https://ipfs.io/ipfs/");
    let receipt = await fLNFTC.deployTransaction.wait();
    await fLNFTC.deployed();
    console.log(receipt);

    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }


    console.log("FLNFTC deployed to:", fLNFTC.address);

    //-end---------- Regulator deploy--------------------------------------------------------------------------


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});