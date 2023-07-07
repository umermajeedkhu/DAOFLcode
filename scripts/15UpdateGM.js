const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fLTP = accounts[1];
    let viewer = accounts[2];

    let odaom1 = accounts[5];
    let odaom2 = accounts[6];
    let odaom3 = accounts[7];
    let odaom4 = accounts[8];
    

    
    MultiSigC = await ethers.getContractFactory("MultiSigC");
    MultiSigCAddr = "0x7001b7f257EEDF4b970577c63095909916BD0cc0";


    //-end---------- account setup--------------------------------------------------------------------------

    //-start---------- DAO-FL interact--------------------------------------------------------------------------
    ///-start---------- DAOFLC.UpdateGM--------------------------------------------------------------------------  
    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(fLTP);
    GI = await multiSigC.GI();
    console.log("GI is:", GI);
    tx = await multiSigC.proposeUpdateGM(1, "QmXWZLdK1KCK1fognbjRwgmxdFneCbFsTSK9zSFFpbPDpi", "QmYGKr6p9MLbAVaQB8dxFPnzahEVX3NvHczZ1fEE");
    console.log("tx:", tx);
    receipt = await tx.wait();
    console.log("receipt:", receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    myevent = receipt.events.find(event => event.event === 'UpdateGMpCreated');
    proposalID = myevent.args[0].toNumber();
    console.log("proposalID:", proposalID);

    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(odaom1);
    tx = await multiSigC.approve(proposalID);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(odaom2);
    tx = await multiSigC.approve(proposalID);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }
    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(odaom3);
    tx = await multiSigC.approve(proposalID);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(odaom4);
    tx = await multiSigC.approve(proposalID);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    multiSigC = await MultiSigC.attach(MultiSigCAddr).connect(fLTP);
    tx = await multiSigC.execute(proposalID);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }
    ///-end------------------------DAOFLC.UpdateGM------------------------------------------------------------ 
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});