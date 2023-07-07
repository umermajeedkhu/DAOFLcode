const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let odaom1 = accounts[5];
    let odaom2 = accounts[6];

    //-end---------- account setup--------------------------------------------------------------------------
    //-start---------- FLTP ODAOC deploy--------------------------------------------------------------------------
    console.log("fLTP address:", fLTP.address);
    const ODAOC = await ethers.getContractFactory("ODAOC");
    oDAOC = await ODAOC.connect(fLTP).deploy(odaom1.address, odaom2.address, "https://ipfs.io/ipfs/QmNPqQqiC1dwADZ2FLwtUi2nGi5CdkYxzZNEaroc3ZUS7R");
    receipt = await oDAOC.deployTransaction.wait();
    await oDAOC.deployed();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }
    console.log("ODAOC deployed to:", oDAOC.address);

    oDAOMTCAddr = await oDAOC.ODAOMTCAddr();
    console.log("oDAOMTC deployed to:", oDAOMTCAddr);
    ODAOMTC = await ethers.getContractFactory("ODAOMTC");

    //-end---------- FLTP deploy--------------------------------------------------------------------------

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
