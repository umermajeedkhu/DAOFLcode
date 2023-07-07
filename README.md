# Description

> This repository contains code for DAO-FL framework which orchestrates rhe Federated Learning Process through DAOs.

# Commands

## Etherscan verification commands
### FLNFTC
`npx hardhat verify --network sepolia 0x37d18bd11e20774e9BE7c22647156564975CAe6b "Federated Learning NFT", "FLNFT", "https://ipfs.io/ipfs/"`
### ODAOC
`npx hardhat verify --network sepolia 0xf002f304Cb1C34b40d59347472f2f68Fc882e61f 0x0effc261fbbdcc1a9f6254e2a539eb5be4397e4a 0xf0a229bd3f527aa97d8bad83e30274bb40f56194 "https://ipfs.io/ipfs/QmNPqQqiC1dwADZ2FLwtUi2nGi5CdkYxzZNEaroc3ZUS7R"`
### ODAOMTC
`npx hardhat verify --contract contracts/ODAOC.sol:ODAOMTC --network sepolia 0xDfF3E610ce7DCb727150E1351c44e58154E28108 "Orchestrator-DAOMT" "ODAOMT" "https://ipfs.io/ipfs/QmNPqQqiC1dwADZ2FLwtUi2nGi5CdkYxzZNEaroc3ZUS7R"`

### VDAOC
`npx hardhat verify --network sepolia 0x1d9Cebd90Aa66068cD9FD3d75479DbDeDA65ebeB 0xaB09054354f92E03f490f3bB141c6388e544d4EA 0x6106E228ebfc879Dc89414C9Bc070E05ea16d09C "https://ipfs.io/ipfs/QmRrHTzcCJvFDWVq9DUnUTgxnCNyWUAANy8TyMRMeQhPp3"`
### VDAOMTC
`npx hardhat verify --contract contracts/VDAOC.sol:VDAOMTC --network sepolia 0x5303b5a16655C69D7914cf6fcdF5A5429C41279F "Validation-DAOMT" "VDAOMT" "https://ipfs.io/ipfs/QmRrHTzcCJvFDWVq9DUnUTgxnCNyWUAANy8TyMRMeQhPp3"`

### DAOFLC
`npx hardhat verify --network sepolia 0x21314B8830c7FE06d0B0DAe0c7935794D77FD429 0x37d18bd11e20774e9BE7c22647156564975CAe6b 0xDfF3E610ce7DCb727150E1351c44e58154E28108 0x5303b5a16655C69D7914cf6fcdF5A5429C41279F`

### FLTokenC
`npx hardhat verify --network sepolia 0x13C3A1a153F7C50a018177aeaC5D70D98A3B2c2C "Federated Learning Token" "FLToken"`

### MultiSigC
`npx hardhat verify --network sepolia 0x7001b7f257EEDF4b970577c63095909916BD0cc0 0x21314B8830c7FE06d0B0DAe0c7935794D77FD429 0xDfF3E610ce7DCb727150E1351c44e58154E28108`

## flatten contracts
```bash
npx hardhat flatten contracts/FLNFTC.sol > flat_contracts/flat_FLNFTC.sol
npx hardhat flatten contracts/DAOFLC.sol > flat_contracts/flat_DAOFLC.sol
npx hardhat flatten contracts/ODAOC.sol > flat_contracts/flat_ODAOC.sol
npx hardhat flatten contracts/VDAOC.sol > flat_contracts/flat_VDAOC.sol
npx hardhat flatten contracts/DAOC.sol > flat_contracts/flat_DAOC.sol
npx hardhat flatten contracts/MultiSigC.sol > flat_contracts/flat_MultiSigC.sol
```
