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
    let vdaom6k = accounts[4];

    VDAOC = await ethers.getContractFactory("VDAOC");
    VDAOCAddr = "0x1d9Cebd90Aa66068cD9FD3d75479DbDeDA65ebeB";

    //-end---------- account setup--------------------------------------------------------------------------
    //-start---------- VDAOC interact--------------------------------------------------------------------------

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom1);

    tx = await vDAOC.proposeJoin(vdaom3.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(fLTP);
    tx = await vDAOC.voteJoin(vdaom3.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom1);
    tx = await vDAOC.voteJoin(vdaom3.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom1);

    tx = await vDAOC.proposeJoin(vdaom4.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(fLTP);
    tx = await vDAOC.voteJoin(vdaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom1);
    tx = await vDAOC.voteJoin(vdaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom2);
    tx = await vDAOC.voteJoin(vdaom4.address, false);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    vDAOC = await VDAOC.attach(VDAOCAddr).connect(vdaom3);
    tx = await vDAOC.voteJoin(vdaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    //-end --------------VDAOC interact ------------------------------------------------------------------
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});