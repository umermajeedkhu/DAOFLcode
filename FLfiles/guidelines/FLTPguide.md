# Description
> This file contains the guidelines for the FLTP for the Federated Learning Task (FLT).

# Guidelines
1. The `tokenURI` submitted by FLTP to MultiSigC via `function proposecreateFLNFT(string memory _tokenURI, string memory _GMCID)` and `function proposeUpdateGM(uint _pGI, string memory _tokenURI, string memory _GMCID)` should be IPFS CID for `.json` file that contains metaData for GM. 
2. The `_GMCID` submitted by FLTP to MultiSigC via `function proposecreateFLNFT(string memory _tokenURI, string memory _GMCID)` and `function proposeUpdateGM(uint _pGI, string memory _tokenURI, string memory _GMCID)` should be IPFS CID for `.pkl` file of the GM.