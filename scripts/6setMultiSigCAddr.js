const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    DAOFLCAddr= "0x21314B8830c7FE06d0B0DAe0c7935794D77FD429";
    MultiSigCAddr = "0x7001b7f257EEDF4b970577c63095909916BD0cc0";

    //-end---------- account setup--------------------------------------------------------------------------

    //-start---------- MultiSigCAddr set in DAOFLC interact--------------------------------------------------------------------------
    
    DAOFLC = await ethers.getContractFactory("DAOFLC");
    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    tx = await dAOFLC.setMultiSigCAddr(MultiSigCAddr);
    receipt = await tx.wait();
    console.log("dAOFLC.MultiSigCAddr is:", await dAOFLC.MultiSigCAddr());

    //-end---------- MultiSigCAddr set in DAOFLC interact--------------------------------------------------------------------------
    
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});