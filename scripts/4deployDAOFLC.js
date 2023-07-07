const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {

    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let viewer = accounts[2];
    //-end---------- account setup--------------------------------------------------------------------------

    //-start---------- FLTP DAOFLC deploy--------------------------------------------------------------------------
    
    ODAOCAddr = "0xf002f304Cb1C34b40d59347472f2f68Fc882e61f";
    ODAOC = await ethers.getContractFactory("ODAOC");
    oDAOC = await ODAOC.attach(ODAOCAddr).connect(viewer);
    console.log("ODAOC deployed to:", oDAOC.address);
    oDAOMTCAddr = await oDAOC.ODAOMTCAddr();
    console.log("oDAOMTC deployed to:", oDAOMTCAddr);

    VDAOC = await ethers.getContractFactory("VDAOC");
    VDAOCAddr = "0x1d9Cebd90Aa66068cD9FD3d75479DbDeDA65ebeB";
    vDAOC = await VDAOC.attach(VDAOCAddr).connect(viewer);
    console.log("VDAOC deployed to:", vDAOC.address);
    vDAOMTCAddr = await vDAOC.VDAOMTCAddr();
    console.log("vDAOMTC deployed to:", vDAOMTCAddr);

    fLNFTCAddr = "0x37d18bd11e20774e9BE7c22647156564975CAe6b";

    DAOFLC = await ethers.getContractFactory("DAOFLC");
    dAOFLC = await DAOFLC.connect(fLTP).deploy(fLNFTCAddr, oDAOMTCAddr, vDAOMTCAddr);
    receipt=await dAOFLC.deployTransaction.wait();
    await dAOFLC.deployed();
    console.log("DAOFLC deployed to:", dAOFLC.address);
    dAOFLCAddr=dAOFLC.address;


    FLTokenC = await ethers.getContractFactory("FLTokenC");
    fLTokenCAddr = await dAOFLC.FLTokenCAddr();
    console.log("FLTokenC deployed to:",fLTokenCAddr);
    fLTokenC = FLTokenC.attach(fLTokenCAddr).connect(viewer);
    //-end---------- FLTP DAOFLC deploy--------------------------------------------------------------------------


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});   