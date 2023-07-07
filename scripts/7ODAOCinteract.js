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
    let odaom6k = accounts[3];

    ODAOC = await ethers.getContractFactory("ODAOC");
    ODAOCAddr = "0xf002f304Cb1C34b40d59347472f2f68Fc882e61f";

    //-end---------- account setup--------------------------------------------------------------------------

    //-start---------- ODAOC interact--------------------------------------------------------------------------
    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.proposeJoin(odaom6k.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(fLTP);
    tx = await oDAOC.voteJoin(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.voteJoin(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.proposeJoin(odaom3.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(fLTP);
    tx = await oDAOC.voteJoin(odaom3.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.voteJoin(odaom3.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom2);
    tx = await oDAOC.voteJoin(odaom3.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom2);
    tx = await oDAOC.proposeJoin(odaom4.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(fLTP);
    tx = await oDAOC.voteJoin(odaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.voteJoin(odaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom2);
    tx = await oDAOC.voteJoin(odaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom6k);
    tx = await oDAOC.voteJoin(odaom4.address, false);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom3);
    tx = await oDAOC.voteJoin(odaom4.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom2);
    tx = await oDAOC.proposeKick(odaom6k.address);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(fLTP);
    tx = await oDAOC.voteKick(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom1);
    tx = await oDAOC.voteKick(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom2);
    tx = await oDAOC.voteKick(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom3);
    tx = await oDAOC.voteKick(odaom6k.address, false);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    oDAOC = await ODAOC.attach(ODAOCAddr).connect(odaom4);
    tx = await oDAOC.voteKick(odaom6k.address, true);
    receipt = await tx.wait();
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    //-end --------------ODAOC interact ------------------------------------------------------------------

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});