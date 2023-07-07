const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {

    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let viewer = accounts[2];

    let vdaom1 = accounts[10];
    let vdaom2 = accounts[11];
    let vdaom3 = accounts[12];
    let vdaom4 = accounts[13];
    let vdaom5 = accounts[14];

    DAOFLCAddr = "0x21314B8830c7FE06d0B0DAe0c7935794D77FD429";
    DAOFLC = await ethers.getContractFactory("DAOFLC");
    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(viewer)
    vDAOMTCAddr = await dAOFLC.VDAOMTCAddr();
    console.log("VDAOMTC deployed to:", vDAOMTCAddr);
    VDAOMTC = await ethers.getContractFactory("VDAOMTC");
    vDAOMTC = VDAOMTC.attach(vDAOMTCAddr).connect(viewer);

    FLTokenC = await ethers.getContractFactory("FLTokenC");
    fLTokenCAddr = await dAOFLC.FLTokenCAddr();
    console.log("FLTokenC deployed to:", fLTokenCAddr);
    fLTokenC = FLTokenC.attach(fLTokenCAddr).connect(viewer);
    //-end---------- account setup--------------------------------------------------------------------------

    //-start---------- DAOFLC.voteLMU-------------------------------------------------------------------------- 

    GI = await dAOFLC.GI();
    console.log("GI is:", GI);
    LMuploaders = await dAOFLC.Fetch_LMUx(GI + 1);
    console.log(LMuploaders);

    console.log("balance of fLTP ", await vDAOMTC.balanceOf(fLTP.address));
    console.log("balance of vdaom1 ", await vDAOMTC.balanceOf(vdaom1.address));
    console.log("balance of vdaom2 ", await vDAOMTC.balanceOf(vdaom2.address));
    console.log("balance of vdaom3 ", await vDAOMTC.balanceOf(vdaom3.address));
    console.log("balance of vdaom4 ", await vDAOMTC.balanceOf(vdaom4.address));

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(viewer);

    console.log("fLTokenC totalSupply", await fLTokenC.totalSupply());

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[0], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[0], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[0], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[0], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[0], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[1], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[1], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[1], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[1], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[1], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[2], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[2], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[2], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[2], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[2], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[3], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[3], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[3], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[3], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[3], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }



    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[4], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[4], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[4], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[4], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[4], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }



    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[5], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[5], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[5], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[5], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[5], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[6], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[6], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[6], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[6], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[6], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[7], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[7], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[7], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[7], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[7], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[8], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[8], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[8], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[8], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[8], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[9], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[9], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[9], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[9], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[9], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fLTP);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[10], GI + 1, true);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom1);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[10], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom2);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[10], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom3);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[10], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(vdaom4);
    voteLMU = await dAOFLC.voteLMU(LMuploaders[10], GI + 1, false);
    receipt = await voteLMU.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }




    //-end---------- DAOFLC.voteLMU-------------------------------------------------------------------------- 

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

