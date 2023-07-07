const { artifacts, ethers } = require("hardhat");
const { BigNumber, utils: { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack }, } = require("ethers")
const ethernal = require('hardhat-ethernal');  //comment-this-later

async function main() {
    //-start---------- account setup--------------------------------------------------------------------------
    let accounts = await ethers.getSigners();
    let fltrainer1 = accounts[15];
    let fltrainer2 = accounts[16];
    let fltrainer3 = accounts[17];
    let fltrainer4 = accounts[18];
    let fltrainer5 = accounts[19];
    let fltrainer6 = accounts[20];
    let fltrainer7 = accounts[21];
    let fltrainer8 = accounts[22];
    let fltrainer9 = accounts[23];
    let fltrainer10 = accounts[24];
    let fltrainer11 = accounts[9];

    DAOFLCAddr= "0x21314B8830c7FE06d0B0DAe0c7935794D77FD429";
    DAOFLC = await ethers.getContractFactory("DAOFLC");

    //-end---------- account setup--------------------------------------------------------------------------
    ///-start---------- DAOFLC.uploadLM-------------------------------------------------------------------------- 
    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer1)
    tx = await dAOFLC.uploadLM("QmcSQvN6hX6A5ut72ZZaNYi87A3CSr53Sv9sP48vUxe4GX", "QmT6M4onJQ2GVYtf8tFHTUMpeJmGvXF7KGrEykQCfheEMw", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer2)
    tx = await dAOFLC.uploadLM("Qme1R8zu7krxVGaKmvpngEgCkiKYxZgJTg1UgVCjhmPf5y", "QmZX8rRcTjAwoH9ki33s6WTLzz8CgTTWk5wJsbKbVD8uFu", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer3)
    tx = await dAOFLC.uploadLM("QmR2YwZi8FeVRfcR78gZR2TEpCD7KvAz2xY75pmX4Sarwr", "QmaZCetWXUfxL6RTwRKPVfEhjefaTrZD9FpnbDq3DnvXtp", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer4)
    tx = await dAOFLC.uploadLM("QmdhMbP9mwdfL5jc86jKwo1r7138vVdz1X7fhh946E6ZTK", "QmZUuqZWonFxDqc4zC2J5dJpfBs2TaDULwNkXrvDTcaAMe", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer5)
    tx = await dAOFLC.uploadLM("QmZJyntfsBfWKjtHWnzhAkgd9qCsUwoKUr6v4m8UeihypQ", "Qmf3AbTTg5Gen5GwwJjPYXBMDDHxNfQafiAN5tDcdEXPrg", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer6)
    tx = await dAOFLC.uploadLM("QmYz6W2cow1NgMWkhjciWmLeTQ2QjKwtwNw8wkRUqqiC15", "QmP9uiWNdxxoLfCNY91m6uNf74tR5UPk5oURvzUeMHEpZ6", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer7)
    tx = await dAOFLC.uploadLM("QmPA9xbPcZkwp6VjctSZ4MTLgzu8h4hpqJMUNoaguacHKF", "QmavwkyUwrr483DGdCwcuws25ytY8tDAeFPAquxMEai8F1", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer8)
    tx = await dAOFLC.uploadLM("QmaFvC6JPDs3Qu41KiQRiY1knUFzxeTScKFxs3ezC1soP5", "QmRFmzJDNdj9SRm6sm3sTjE3zN1aL12YVJc5n3p5cnGf2B", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer9)
    tx = await dAOFLC.uploadLM("QmNdtAc6KG3USrq1QvuHuCqXYm68jDMLRzjcAmwXUaTGrc", "QmYBEf2nt3vtCa9iFcUAM2xMG4WpQhxkrSJctoPdaQRxjZ", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer10)
    tx = await dAOFLC.uploadLM("QmZ7wFex5roxSg4w1xzS3Ry7ApZFAcg7C6nEmokB3rAcqV", "QmQE2gQdTd2m98JgAfULMYpodENRhJcrTxDfyWPC3UB9Kc", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    dAOFLC = await DAOFLC.attach(DAOFLCAddr).connect(fltrainer11)
    tx = await dAOFLC.uploadLM("QmWYddCPs7uR9EvHNCZzpguVFVNfHc6aM3hPVzPdAEESMc", "QmcipbXKtUWqot23XSFDvujLLYSYqNkQLumDB6gXkdMRkd", 1)
    receipt = await tx.wait();
    console.log(receipt);
    for (const event of receipt.events) {
        console.log(`Event ${event.event} with args ${event.args}`);
    }

    ///-end-------------DAOFLC.uploadLM------------------------------------------------------------ 
    
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

