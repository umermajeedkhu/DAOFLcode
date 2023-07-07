const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {

    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let viewer = accounts[2];
    //-end---------- account setup--------------------------------------------------------------------------
    

    //-start---------- FLTP MultiSigC deploy--------------------------------------------------------------------------
    ODAOCAddr = "0xf002f304Cb1C34b40d59347472f2f68Fc882e61f";
    ODAOC = await ethers.getContractFactory("ODAOC");
    oDAOC = await ODAOC.attach(ODAOCAddr).connect(viewer);
    console.log("ODAOC deployed to:", oDAOC.address);
    oDAOMTCAddr = await oDAOC.ODAOMTCAddr();
    console.log("oDAOMTC deployed to:", oDAOMTCAddr);
    
    dAOFLCAddr= "0x21314B8830c7FE06d0B0DAe0c7935794D77FD429";
    MultiSigC = await ethers.getContractFactory("MultiSigC");
    multiSigC = await MultiSigC.connect(fLTP).deploy(dAOFLCAddr, oDAOMTCAddr);
    await multiSigC.deployed();
    console.log("MultiSigC deployed to:", multiSigC.address);
    //-end---------- FLTP MultiSigC deploy--------------------------------------------------------------------------

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});