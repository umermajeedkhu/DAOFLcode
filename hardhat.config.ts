import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-toolbox";
// import "@nomiclabs/hardhat-gas-reporter";
import "hardhat-ethernal";

// import * as tdly from "@tenderly/hardhat-tenderly";
// tdly.setup( { automaticVerifications: false });

import {
  YOUR_ETHERSCAN_API_KEY,
  Goerli_URL,
  PRIVATE_KEY_0,
  PRIVATE_KEY_1,
  PRIVATE_KEY_2,
  PRIVATE_KEY_3,
  PRIVATE_KEY_4,
  PRIVATE_KEY_5,
  PRIVATE_KEY_6,
  PRIVATE_KEY_7,
  PRIVATE_KEY_8,
  PRIVATE_KEY_9,
  PRIVATE_KEY_10,
  PRIVATE_KEY_11,
  PRIVATE_KEY_12,
  PRIVATE_KEY_13,
  PRIVATE_KEY_14,
  PRIVATE_KEY_15,
  PRIVATE_KEY_16,
  PRIVATE_KEY_17,
  PRIVATE_KEY_18,
  PRIVATE_KEY_19,
  ETHERNAL_EMAIL,
  ETHERNAL_PASSWORD,
  DEVNET_URL,
  sepolia_URL,
  TPRIVATE_KEY_0,
  TPRIVATE_KEY_1,
  TPRIVATE_KEY_2,
  TPRIVATE_KEY_3,
  TPRIVATE_KEY_4,
  TPRIVATE_KEY_5,
  TPRIVATE_KEY_6,
  TPRIVATE_KEY_7,
  TPRIVATE_KEY_8,
  TPRIVATE_KEY_9,
  TPRIVATE_KEY_10,
  TPRIVATE_KEY_11



} from './constants/constants'

dotenv.config({ path: ".env" });



const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  ethernal: {
    email: ETHERNAL_EMAIL,
    password: ETHERNAL_PASSWORD,
    uploadAst: true,
    disabled: false,

  },
  networks: {
    hardhat: {
      chainId: 1337,
      accounts: [
      { 
        privateKey:
        PRIVATE_KEY_0,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_1,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_2,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_3,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_4,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_5,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_6,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_7,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_8,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_9,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_10,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_11,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_12,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_13,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_14,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_15,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_16,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_17,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_18,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: PRIVATE_KEY_19,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: TPRIVATE_KEY_0,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: TPRIVATE_KEY_2,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: TPRIVATE_KEY_9,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: TPRIVATE_KEY_10,
        balance: "100000000000000000000000000000000"
      },
      {
        privateKey: TPRIVATE_KEY_11,
        balance: "100000000000000000000000000000000"
      }

    ]
    },
    goerli: {
      url: Goerli_URL,
      accounts: [PRIVATE_KEY_0,PRIVATE_KEY_1,PRIVATE_KEY_2,PRIVATE_KEY_3,PRIVATE_KEY_4, PRIVATE_KEY_5,  PRIVATE_KEY_6,PRIVATE_KEY_7,PRIVATE_KEY_8,PRIVATE_KEY_9,PRIVATE_KEY_10,PRIVATE_KEY_11, PRIVATE_KEY_12,PRIVATE_KEY_13,PRIVATE_KEY_14,PRIVATE_KEY_15,PRIVATE_KEY_16,PRIVATE_KEY_17,PRIVATE_KEY_18,PRIVATE_KEY_19, TPRIVATE_KEY_0, TPRIVATE_KEY_2, TPRIVATE_KEY_9, TPRIVATE_KEY_10, TPRIVATE_KEY_11],
    },
    sepolia: {
      url: sepolia_URL,
      accounts: [TPRIVATE_KEY_0,TPRIVATE_KEY_1,TPRIVATE_KEY_2,TPRIVATE_KEY_3,TPRIVATE_KEY_4, TPRIVATE_KEY_5,  TPRIVATE_KEY_6,TPRIVATE_KEY_7,TPRIVATE_KEY_8,TPRIVATE_KEY_9,TPRIVATE_KEY_10,TPRIVATE_KEY_11],
    }
    // devnet: {
    //   url: DEVNET_URL,
    //   accounts: [PRIVATE_KEY_0,PRIVATE_KEY_1,PRIVATE_KEY_2,PRIVATE_KEY_3,PRIVATE_KEY_4, PRIVATE_KEY_5,  PRIVATE_KEY_6,PRIVATE_KEY_7,PRIVATE_KEY_8,PRIVATE_KEY_9,PRIVATE_KEY_10,PRIVATE_KEY_11,PRIVATE_KEY_12,PRIVATE_KEY_13,PRIVATE_KEY_14,PRIVATE_KEY_15,PRIVATE_KEY_16,PRIVATE_KEY_17,PRIVATE_KEY_18,PRIVATE_KEY_19],
    //   chainId: 1,
  
    // }

  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  etherscan: {
    apiKey: YOUR_ETHERSCAN_API_KEY,
  },
  mocha: {
    timeout: 100000
  },
  // tenderly: { // as before
  //   username: "umermjd11",
  //   project: "DAOFL",
  //   privateVerification: false
  // }
};


export default config;

