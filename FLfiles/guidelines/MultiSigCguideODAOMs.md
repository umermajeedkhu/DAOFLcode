# Description
> This file contains the creteria for approval vote by ODAOMs on `createFLNFT` and `UpdateGM` proposal along with guideline for ODAOMs to perform coressponding operations on MultiSigC. 

# Creteria for Approval vote by ODAOMs on  `createFLNFT` and `UpdateGM` proposal
To get the Approval vote by ODAOMs on `createFLNFT` and `UpdateGM` proposal, these creteria must be met: 

1. The `tokenURI` submitted by FLTP to MultiSigC via `function proposecreateFLNFT(string memory _tokenURI, string memory _GMCID)` and `function proposeUpdateGM(uint _pGI, string memory _tokenURI, string memory _GMCID)` must be IPFS CID for `.json` file that contains metaData for GM. 
2. The `_GMCID` submitted by FLTP to MultiSigC via `function proposecreateFLNFT(string memory _tokenURI, string memory _GMCID)` and `function proposeUpdateGM(uint _pGI, string memory _tokenURI, string memory _GMCID)` must be IPFS CID for `.pkl` file of the GM.

# Guideline for ODAOMs for Approval vote on  `createFLNFT` and `UpdateGM` proposal
1. The ODAOMs should submit  transaction`function approve(uint256 proposalId)` to approve the proposals, where `proposalId` is the ID of proposal, `_GI` is progressing GI, and `_vote` is boolean vote decision for LMU. The ODAOMs do decentralized output verification for Federated Learning process by submitting these transactions.