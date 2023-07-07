# Description
> This file contains the guidelines for FLTrainers for Local model uploads which is in accordance with the creteria for rewarding Local model uploads to FLT.

# Guidelines
To get the Approval vote for LMU by VDAOMs and get the reward for LMU, the FLTrainers must follow these guidelines: 

1. The local model upload (LMU) should be done using `function uploadLM(string memory _LMCID, string memory _LMURI, uint _GI)`; where: `GI` must be the progressing global iteration, `_LMCID` must be IPFS CID for `.pkl` file of the local model, `_LMURI` must be the IPFS CID of `.json` that contains metaData for LMU.
2. The `_LMCID` and `_LMURI` must be the `IPFS_CID` without anything else: i.e. `IPFS_CID` could be `QmcfsZCGdcXyHJP8MupMQwYuSET8TFJCHUhAaoJwe4EJuP`
3. The LM in LMU should be trained using the GM from previous iteration.
4. The LM should contribute to the GM for progressing iteration. For this, it must satisfy the guidelines for training the LM according to specific FLT.