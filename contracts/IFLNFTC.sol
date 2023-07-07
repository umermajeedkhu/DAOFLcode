// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IFLNFTC {
    function craftFLNFT(address minter, address _OrchestratorAddress, string memory _tokenURI, string memory _GMCID) external  returns (uint256);
    function assignTokenURI(uint256 _tokenId, string memory _tokenURI) external returns(bool);
    function assignGMCID(uint256 _tokenId, string memory _GMCID) external returns(bool);
    function ownerOf(uint256 tokenId) external view returns (address owner);
}


